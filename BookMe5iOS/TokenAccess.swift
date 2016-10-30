//
//  TokenAccess.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 25/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class TokenAccess {

    private let accessToken: Variable<String?> = Variable(nil)
    
    private class var sharedInstance: TokenAccess {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: TokenAccess? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TokenAccess()
        }
        return Static.instance!
    }
    
    class var observableTokenAccess: Observable<String?> {
        return TokenAccess.sharedInstance.accessToken.asObservable()
    }
    
    class var accessToken: String? {
        return self.sharedInstance.accessToken.value
    }
    
    private func initTokens(tokenAccess: String) {
        self.accessToken.value = nil

        self.accessToken.value = tokenAccess
        KeychainSecuredStorageManager.storeToken()
    }
    
    class func instanceNewTokenAccess(json: JSON) -> TokenAccess? {
        guard let tokenAccess = json["accessToken"] as? String else {
            return nil
        }
        self.sharedInstance.initTokens(tokenAccess)
        self.sharedInstance.accessToken.value = tokenAccess
        return self.sharedInstance
    }
    
    class func removeToken() throws {
        self.sharedInstance.accessToken.value = nil
        KeychainSecuredStorageManager.removeToken()
    }
    
    class func initTokenFromSecureStore() {
        guard let token = KeychainSecuredStorageManager.getToken() else {
            return
        }
        TokenAccess.sharedInstance.accessToken.value = token
    }
}
