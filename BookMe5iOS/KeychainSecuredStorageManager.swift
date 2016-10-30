//
//  KeychainSecuredStorageManager.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 10/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Valet

class KeychainSecuredStorageManager {

    private static let identifier = "com.bookme5.token_access"
    private static var valetInstance = VALValet(identifier: identifier, accessibility: VALAccessibility.WhenUnlocked)
    
    class func storeToken() {
        guard let instance = self.valetInstance, let token = TokenAccess.accessToken else {
            return
        }
        instance.setString(token, forKey: "access_token")
    }

    class func getToken() -> String? {
        guard let instance = self.valetInstance else {
            return nil
        }
        return instance.stringForKey("access_token")
    }
    
    class func removeToken() {
        guard let instance = self.valetInstance else {
            return
        }
        instance.removeObjectForKey("access_token")
    }
}
