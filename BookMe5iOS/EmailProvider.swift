//
//  EmailProvider.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire

class EmailProvider: Provider {

    let providerType = LoginProviderType.Email
    var email: String
    var password: String
    var delegate: LoginProviderDelegate?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func isValid() -> Bool {
        //check the email here regex or everything you want.
        //If you don't know what you want, please skip this method 😳.
        //Avoid the boring stuff please.
        return true
    }
    
    func login() {
        if self.isValid() {
            self.delegate?.loginProvider(self, didSucceed: APILogin.loginWithEmail(self.email, password: self.password))
        }
        else {
            self.delegate?.loginProvider(self, didError: nil)
        }
    }    
}
