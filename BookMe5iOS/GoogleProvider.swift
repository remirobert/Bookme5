//
//  GoogleProvider.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class GoogleProvider: NSObject, Provider, GIDSignInDelegate, GIDSignInUIDelegate {

    let providerType = LoginProviderType.Google
    var delegate: LoginProviderDelegate?
    private var parentController: UIViewController!
    private var blockCompletion: (NetworkRequest -> Void)!
    private var blockError: (ErrorType -> Void)!
    
    @objc func signIn(signIn: GIDSignIn!,
        presentViewController viewController: UIViewController!) {
            self.parentController.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @objc func signIn(signIn: GIDSignIn!,
        dismissViewController viewController: UIViewController!) {
            self.parentController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        print("error sign in login google : \(error)")
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            let idToken = user.authentication.idToken
            
            print("token idGoogle : \(idToken)")
            let request = APIBookMe5.LoginGoogle(token: idToken)
            self.blockCompletion(request);
//            self.delegate?.loginProvider(self, didSucceed: idToken)
//            self.delegate?.loginProvider(self, didSucceed: APILogin.loginWithGoogle(idToken))
//        } else {
//            self.delegate?.loginProvider(self, didError: error)
        }
        else {
            self.blockError(error)
        }
    }
    
    func login() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
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
    
    init(parentController: UIViewController) {
        self.parentController = parentController
    }
}
