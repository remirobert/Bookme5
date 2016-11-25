
//
//  User.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 10/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class User {
    
    var id: String?
    var firstName: String!
    var lastName: String!
    var pictureProfileUrl: String?
    var email: String?
    
    class var sharedInstance: User {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: User? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = User()
        }
        return Static.instance!
    }
    
    class func fromJSON(json: JSON) -> User? {
        guard let info = json["profile"] as? JSON else { return nil }
        guard let firstName = info["firstname"] as? String else { return nil }
        guard let lastName = info["lastname"] as? String else { return nil }
        let pictureUrl = info["pictureProfileUrl"] as? String
        
        User.sharedInstance.id = json["user_id"] as? String ?? ""
        User.sharedInstance.email = json["email"] as? String
        User.sharedInstance.firstName = firstName
        User.sharedInstance.lastName = lastName
        User.sharedInstance.pictureProfileUrl = pictureUrl
        return User.sharedInstance
    }
    
    class func instance(jsonResponse: [String: AnyObject]) -> Observable<User?> {
        return Observable.create({ observer in
            defer {
                observer.onCompleted()
            }
            guard let user = self.fromJSON(jsonResponse) else {
                observer.onNext(nil)
                return NopDisposable.instance
            }
            observer.onNext(user)
            return NopDisposable.instance
        })
    }    
}
