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
    
    init?(json: JSON) {
        guard let content = json["content"] as? String,
            let author = json["author"] as? String,
            let dateString = json["published_at"] as? String else {
                return nil
        }
        
        self.content = content
        self.author = author
        if let moment = moment(dateString) {
            self.date = moment.date
        }
    }
}
