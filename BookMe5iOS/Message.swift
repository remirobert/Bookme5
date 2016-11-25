//
//  Message.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 17/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

struct Message {
    
    var content: String?
    var userId: String?
    var userName: String?
    
    init(json: JSON) {
        print("\(json)")
        if let user = json["sender"] as? JSON {
            self.userId = user["_id"] as? String
        }
        else {
            self.userId = json["sender"] as? String
        }
        self.userName = json["senderName"] as? String
        self.content = json["message"] as? String
    }
}
