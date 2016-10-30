//
//  LoginViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 25/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class LoginViewModel {

    private var googleProvider: GoogleProvider
    private var facebookProvider: FacebookProvider
    
    var tokenAccess: String?
    
    var observableLoginGoogle: Observable<NetworkRequest> { return self.googleProvider.rx_login() }
    var observableLoginFacebook: Observable<NetworkRequest> { return self.facebookProvider.rx_login() }
    
    func loginWithProvider(request: NetworkRequest) -> Observable<TokenAccess?> {
        return Network.send(request: request, parse: TokenAccess.instanceNewTokenAccess)
            .flatMap({ (token: TokenAccess?) -> Observable<TokenAccess?> in
            return Observable.just(token)
        })
    }
        
    init(parentController: UIViewController) {
        self.googleProvider = GoogleProvider(parentController: parentController)
        self.facebookProvider = FacebookProvider(parentController: parentController)
    }
}
