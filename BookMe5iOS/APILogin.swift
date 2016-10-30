//
//  APILogin.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 25/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire

class APILogin: NSObject {
    
    private class var path: String {
        return "/login"
    }

    class func loginWithGoogle(token: String) -> Request {
        let url = API.baseUrl + self.path + "/google/token"
        
        return Alamofire.request(.POST, url, parameters: ["access_token":token], encoding: ParameterEncoding.JSON,
            headers: nil)
    }
    
    class func loginWithEmail(email: String, password: String) -> Request {
        let url = API.baseUrl + self.path + "/email"
        
        return Alamofire.request(.POST, url, parameters: ["username":email, "password":password], encoding: ParameterEncoding.JSON,
            headers: nil)
    }

    class func loginWithFacebook(token: String) -> Request {
        let url = API.baseUrl + self.path + "/facebook/token"
        
        return Alamofire.request(.POST, url, parameters: ["access_token":token], encoding: ParameterEncoding.JSON,
            headers: nil)
    }    
}
