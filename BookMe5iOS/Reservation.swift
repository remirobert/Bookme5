//
//  Reservation.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 21/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftMoment

class Reservation {
    var start: NSDate?
    var end: NSDate?
    var service: Service?
    var business: Buisiness?
    var id: String?
    
    init?(json: JSON) {
        guard let jsonService = json["serviceId"] as? JSON else {
            return nil
        }
        guard let business = json["businessId"] as? JSON else {
            return nil
        }
        self.id = json["_id"] as? String
        self.business = Buisiness(json: business)
        self.service = Service(json: jsonService)
        guard let jsonDate = json["serviceTime"] as? JSON else {
            return nil
        }
        if let startDate = jsonDate["start"] as? String {
            self.start = moment(startDate)?.date
        }
        if let endDate = jsonDate["end"] as? String {
            self.start = moment(endDate)?.date
        }
    }
}