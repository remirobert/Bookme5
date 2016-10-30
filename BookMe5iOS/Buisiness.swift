//
//  Shop.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 27/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import SwiftMoment

struct BuisinessLocation {
    var addr: String?
    var lat: Double?
    var lon: Double?
    
    init(json: JSON) {
        self.addr = json["addr"] as? String
        self.lat = json["lat"] as? Double
        self.lon = json["lon"] as? Double
    }
}

class Buisiness {
    
    var id: String
    var name: String
    var description: String?
    var pictures: [String]?
    var location: BuisinessLocation?
    var services: [String]?
    var start: NSDate?
    var end: NSDate?
    
    init?(json: JSON) {
        guard let id = json["_id"] as? String else { return nil }
        guard let name = json["name"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.description = json["description"] as? String
        
        if let picturesJson = json["images"] as? [JSON] {
            self.pictures = picturesJson.flatMap({ (json: JSON) -> String? in
                return json["url"] as? String
            })
        }
        if let locationJson = json["location"] as? JSON {
            self.location = BuisinessLocation(json: locationJson)
        }
        
        if let services = json["services"] as? [String] {
            self.services = services
        }
        
        if let hours = json["openingHours"] as? JSON {
            guard let start = hours["start"] as? String, let end = hours["end"] as? String else {
                return
            }
            self.start = moment(start)?.date
            self.end = moment(end)?.date
        }
    }
    
    private class func parseResponse(json: JSON) -> [JSON]? {
        if let buisiness = json["businesses"] as? [JSON] {
            return buisiness
        }
        return json["objects"] as? [JSON]
    }
    
    class func instanceBuisiness(json: JSON) -> [Buisiness]? {
        print("\(json)")
        
        guard let jsonBuisiness = self.parseResponse(json) else {
            return nil
        }
        return jsonBuisiness.flatMap({ (json: JSON) -> Buisiness? in
            return Buisiness(json: json)
        })
    }
}
