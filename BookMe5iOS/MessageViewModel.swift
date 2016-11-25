//
//  MessageViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 18/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import JSQMessagesViewController

class MessageViewModel {
    
    let groupMessage: GroupMessage
    var messages: Variable<[JSQMessage]> = Variable([JSQMessage]())
    
    func addMessage(message: Message) {
        guard let content = message.content, let userId = message.userId, let userName = message.userName else {
            return
        }
        let newMessage = JSQMessage(senderId: userId, displayName: userName, text: content)
        self.messages.value.append(newMessage)
    }
    
    init(group: GroupMessage) {
        self.groupMessage = group
        
        self.messages.value =  self.groupMessage.messages.flatMap { message -> JSQMessage? in
            guard let content = message.content, let userId = message.userId, let userName = message.userName else {
                return nil
            }
            return JSQMessage(senderId: userId, displayName: userName, text: content)
        }
    }
}
