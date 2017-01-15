//
//  Comment.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 29/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import SwiftMoment

struct Comment {
    var content: String?
    var author: String?
    var date: NSDate?
    var mark: Int?
    
    init?(json: JSON) {
        guard let content = json["comment"] as? String,
            let dateString = json["date"] as? String else {
                return nil
        }

        if let user = json["user"] as? JSON {
            self.author = user["name"] as? String
        }
        self.mark = json["mark"] as? Int
        self.content = content
        if let moment = moment(dateString) {
            self.date = moment.date
        }
    }
}
