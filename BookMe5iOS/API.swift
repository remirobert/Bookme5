//
//  API.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 25/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

enum APIResponse {
    case JSON(data: AnyObject?)
    case Error(code: Int, error: NSError)
}

class API {
    
    static var baseUrl: String {
        return "http://127.0.0.1:4242/api"
    }
    
    class func responseFrom(request: Request) -> Observable<APIResponse> {
        return Observable.create({ observer in
            
            request.responseJSON(completionHandler: { response in
                                
                if let request = response.response, let response = response.result.value {
                    let codeRequest = request.statusCode
                    if codeRequest == 200 {
                        observer.onNext(APIResponse.JSON(data: response))
                    }
                    else {
                        if let errorString = response.objectForKey("error") as? String {
                            let error = NSError(domain: errorString, code: codeRequest, userInfo: nil)
                            observer.onNext(APIResponse.Error(code: request.statusCode, error: error))
                        }
                    }
                }
                else {
                }
                observer.onCompleted()
                
            }).response(completionHandler: { (_, response: NSHTTPURLResponse?, _, error: NSError?) -> Void in
                if let error = error {
                    observer.onError(error)
                }
            })
            
            return AnonymousDisposable {
                request.cancel()
            }
        })
    }
}
