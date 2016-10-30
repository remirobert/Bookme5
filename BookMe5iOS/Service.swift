//
//  Service.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 08/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class Service {
    var id: String?
    var title: String?
    var description: String?
    var price: String?
    var image: String?
    var duration: Double?
    var date: NSDate?
    var people: Int = 0
    
    init(json: JSON) {
        self.id = json["_id"] as? String
        self.title = json["title"] as? String
        self.description = json["description"] as? String
        self.price = json["price"] as? String
        self.image = json["picture"] as? String
        self.duration = json["duration"] as? Double
        self.people = json["people"] as? Int ?? 0
        
        print("json / \(json)")
        print("people/ : \(self.people)")
    }
}

extension Service {
    class func instance(response: [String: AnyObject]) -> [Service]? {
        guard let services = response["objects"] as? [JSON] else {
            return nil
        }
        
        return services.map({ (service: [String : AnyObject]) -> Service in
            return Service(json: service)
        })
    }
}
