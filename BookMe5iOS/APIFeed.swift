//
//  APIFeed.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 27/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire

class APIFeed {

    private class var path: String {
        return "/businesses"
    }
    
    class func getBusinesses(tokenAccess: String) -> Request {
        let url = API.baseUrl + self.path + "/"
        let headers: [String: String] = ["Authorization": "Bearer \(tokenAccess)"]
        
        return Alamofire.request(.GET, url, parameters: nil, encoding: ParameterEncoding.JSON,
            headers: headers)
    }
}
