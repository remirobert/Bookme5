//
//  Network.swift
//  YooplessIOS
//
//  Created by Remi Robert on 10/03/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

typealias JSON = [String: AnyObject]

public enum NetworkMethod: String {
    case GET, POST, PUT, DELETE
    
    func alamofireMethod() -> Alamofire.Method {
        switch self {
        case .GET: return Alamofire.Method.GET
        case .POST: return Alamofire.Method.POST
        case .PUT: return Alamofire.Method.PUT
        case .DELETE: return Alamofire.Method.DELETE
        }
    }
}

protocol NetworkRequest {
    func parameters() -> [String: AnyObject]?
    func path() -> String
    func method() -> NetworkMethod
    func headers() -> [String: String]?
    func uploadData() -> NSData?
}

extension NetworkRequest {
    func parameters() -> [String: AnyObject]? { return nil }
    func headers() -> [String: String]? { return nil }
    func uploadData() -> NSData? { return nil }
}

class Network {
    
    private var tasks = Array<Request>()
    
    private class var sharedInstance: Network {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Network? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Network()
        }
        return Static.instance!
    }
    
    private static func handleJSONResponse(request: Request, observer: AnyObserver<JSON?>) {
        request.validate().responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) -> Void in
            
            switch response.result {
            case .Success(let value):
                
                if let value = value as? [String: AnyObject] {
                    observer.onNext(value)
                }
                else {
                    observer.onNext(["objects": value])
                }                
                observer.onCompleted()
            case .Failure(let err):
                observer.onError(err)
            }
        })
    }
    
    static func send(request request: NetworkRequest, debug: Bool = false) -> Observable<JSON?> {
        let method = request.method().alamofireMethod()
        let path = request.path()
        let parameters = request.parameters()
        let headers = request.headers()
        
        print("[🔥] fire request :\(path)")
        
        let request = Alamofire.request(method, path, parameters: parameters, encoding: .JSON, headers: headers)
        if debug { debugPrint(request) }
        
        self.sharedInstance.tasks.append(request)
        
        return Observable.create { observer in
            self.handleJSONResponse(request, observer: observer)
            
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
    
    static func send<A>(request request: NetworkRequest, parse: JSON -> A?) -> Observable<A?> {
        return self.send(request: request).flatMap { (response: JSON?) -> Observable<A?> in
            guard let json = response else {
                return Observable.just(nil)
            }
            return Observable.just(parse(json))
        }
    }
    
    static func download(request request: NetworkRequest, progress: (Int64 -> Void)? = nil) -> Observable<NSURL?> {
        let method = request.method().alamofireMethod()
        let path = request.path()
        let parameters = request.parameters()
        let headers = request.headers()
        
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        let request = Alamofire.download(method, path, parameters: parameters, encoding: .URL, headers: headers, destination: destination)
        
        return Observable.create { observer in
            request.validate().progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                progress?(totalBytesRead)
                }.response { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
                    
                    if let error = error {
                        observer.onError(error)
                    }
                    if let response = response {
                        let path = destination(NSURL(string: "")!, response)
                        observer.onNext(path)
                    }
                    observer.onCompleted()
            }
            
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
    
    static func upload(request request: NetworkRequest, progress: (Int64 -> Void)? = nil) -> Observable<JSON?> {
        let method = request.method().alamofireMethod()
        let path = request.path()
        let parameters = request.parameters()
        let headers = request.headers()
        var alamofireRequest: Request?
        
        return Observable.create({ observer in
            Alamofire.upload(method, path, headers: headers, multipartFormData: { multipartFormData in
                
                if let data = request.uploadData() {
                    multipartFormData.appendBodyPart(data: data, name: "file", fileName: "file", mimeType: "image/png")
                }
                if let parameters = parameters {
                    for (key, value) in parameters {
                        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :key)
                    }
                }
                
                }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold, encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        alamofireRequest = upload
                        
                        if let progressBlock = progress {
                            upload.progress({ bytesRead, totalBytesRead, totalBytesExpectedToRead in
                                progressBlock(bytesRead)
                            })
                        }
                        self.handleJSONResponse(upload, observer: observer)
                        
                    case .Failure(let encodingError):
                        observer.onError(encodingError)
                    }
            })
            return AnonymousDisposable {
                alamofireRequest?.cancel()
            }
        })
    }
}
