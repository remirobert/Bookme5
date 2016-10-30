//
//  FacebookProvider.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import FBSDKLoginKit

class FacebookProvider: Provider {

    let providerType = LoginProviderType.Facebook
    var delegate: LoginProviderDelegate?
    
    private var blockCompletion: (NetworkRequest -> Void)!
    private var blockError: (ErrorType -> Void)!

    private var parentController: UIViewController!
    private var permissions: [String]!
    
    init(parentController: UIViewController, permissions: [String] = ["public_profile", "email", "user_friends"]) {
        self.permissions = permissions
        self.parentController = parentController
    }
    
    func login() {
        let loginManager = FBSDKLoginManager()
        
        loginManager.logOut()
        loginManager.loginBehavior = .Native
        
        loginManager.logInWithReadPermissions(self.permissions, fromViewController: self.parentController) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            
            if error != nil || result == nil {
                self.blockError(error)
            }
            else {
                if let resultToken = result.token, let tokenString = resultToken.tokenString {
                    let request = APIBookMe5.LoginFacebook(token: tokenString)
                    self.blockCompletion(request)
                }
            }
        }        
    }
    
    func rx_login() -> Observable<NetworkRequest> {
        self.login()
        return Observable.create({ observer in
            self.blockCompletion = { request in
                observer.onNext(request)
            }
            self.blockError = { error in
                observer.onError(error)
            }
            return NopDisposable.instance
        })
    }
}
