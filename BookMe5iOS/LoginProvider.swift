//
//  LoginProvider.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

typealias successCompletionRequestBlock = ((request: Request) -> Void)
typealias successCompletionUserBlock = ((user: User?) -> Void)
typealias successCompletionTokenBlock = ((token: String) -> Void)
typealias errorCompletionBlock = ((error: NSError?) -> Void)


enum LoginProviderType: String {
    case Facebook = "Facebook"
    case Google = "Google"
    case Email = "Email"
}

protocol Provider {
    var providerType: LoginProviderType {get}
    var delegate: LoginProviderDelegate? {get set}
    func login()
}

protocol LoginProviderDelegate {
    func loginProvider(loginProvider: Provider, didSucceed request: Request)
    func loginProvider(loginProvider: Provider, didSucceed user: User)
    func loginProvider(loginProvider: Provider, didSucceed token: String)
    func loginProvider(loginProvider: Provider, didError error: NSError?)
}

class LoginProvider: LoginProviderDelegate {
    
    private var successRequestBlock: successCompletionRequestBlock?
    private var observble: Observable<Request>?
    var successUserBlock: successCompletionUserBlock?
    var successTokenBlock: successCompletionTokenBlock?
    var errorBlock: errorCompletionBlock?
    var currentProvider: Provider!

    func rx_login(provider: Provider) -> Observable<Request> {
        return Observable.create({ observer in
            
            self.login(provider, completionRequest: { (request) -> Void in
                observer.onNext(request)
                observer.onCompleted()
            })
            
            return NopDisposable.instance
        })
    }
    
    func login(provider: Provider, completionRequest: successCompletionRequestBlock) {
        self.successRequestBlock = completionRequest
        self.login(provider)
    }
    
    func login(provider: Provider) {
        self.currentProvider = provider
//        provider.delegate = self
        provider.login()
    }
    
    func loginProvider(loginProvider: Provider, didSucceed request: Request) {
        if let requestBlock = self.successRequestBlock {
            requestBlock(request: request)
        }
    }
    
    func loginProvider(loginProvider: Provider, didSucceed token: String) {
        self.successTokenBlock?(token: token)
    }
    
    func loginProvider(loginProvider: Provider, didSucceed user: User) {
        self.successUserBlock?(user: user)
    }
    
    func loginProvider(loginProvider: Provider, didError error: NSError?) {
        self.errorBlock?(error: error)
    }
}