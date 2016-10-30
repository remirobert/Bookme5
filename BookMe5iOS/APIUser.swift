
//
//  APIUser.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 25/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire

class APIUser {

    private class var path: String {
        return "/users"
    }
    
    class func user(tokenAccess: String) -> Request {
        let url = API.baseUrl + self.path + "/info"
        let headers: [String: String] = ["Authorization": "Bearer \(tokenAccess)"]
        
        return Alamofire.request(.GET, url, parameters: nil, encoding: ParameterEncoding.JSON,
            headers: headers)
    }
    
    class func updateInfos(tokenAccess: String, user: User) -> Request {
        let url = API.baseUrl + self.path + "/profile"
        let headers: [String: String] = ["Authorization": "Bearer \(tokenAccess)"]
        var parameters = Dictionary<String, String>()
        if let firstName = user.firstName {
            parameters["firstname"] = firstName
        }
        if let lastName = user.lastName {
            parameters["lastname"] = lastName
        }
        
        print("parameters : \(parameters)")
        
        return Alamofire.request(.PUT, url, parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
    }
    
    class func signupUser(email: String, firstName: String, lastName: String, password: String) -> Request {
        let url = API.baseUrl + self.path + "/"
        
        let parameters = [
            "email": email,
            "firstname": firstName,
            "lastname": lastName,
            "password": password
        ]
        
        return Alamofire.request(.POST, url, parameters: parameters, encoding: ParameterEncoding.JSON, headers: nil)
    }
}
