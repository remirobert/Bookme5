//
//  GroupeMessage.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 17/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

struct GroupMessage {

    let id: String
    let business: Buisiness?
    var messages = [Message]()
    
    init?(json: JSON) {
        print("json : \(json)")
        guard let businessJson = json["business"] as? JSON else {
            return nil
        }
        
        self.id = json["_id"] as? String ?? ""
        self.business = Buisiness(json: businessJson)
        if let messagesJson = json["messages"] as? [JSON] {
            self.messages = messagesJson.map({ json -> Message in
                return Message(json: json)
            })
        }
        print("messages : \(self.messages.count)")
        print("messages : \(self.messages.count)")
    }
}
