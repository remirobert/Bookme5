//
//  Bookmark.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 05/09/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RealmSwift

class Bookmark: Object {
    dynamic var id: String = ""
    dynamic var name: String?
    dynamic var descriptionBusiness: String?
    dynamic var start: NSDate?
    dynamic var end: NSDate?
    dynamic var addr: String?
    dynamic var lat: Double = 0
    dynamic var lon: Double = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
