//
//  DetailMessageViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 18/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import SwiftMoment
import JSQMessagesViewController

class DetailMessageViewController: JSQMessagesViewController {
    
    var viewModel: MessageViewModel!
    private var outBuble: JSQMessagesBubbleImage!
    private var inBuble:  JSQMessagesBubbleImage!
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.viewModel.groupMessage.business?.name
        
        let factor = JSQMessagesBubbleImageFactory()
        self.outBuble = factor.outgoingMessagesBubbleImageWithColor(UIColor(red:1.00, green:0.76, blue:0.00, alpha:1.00))
        self.inBuble = factor.incomingMessagesBubbleImageWithColor(UIColor(red:1.00, green:0.76, blue:0.00, alpha:1.00))
        
        self.edgesForExtendedLayout = UIRectEdge.None

        self.senderId = User.sharedInstance.id ?? ""
        self.senderDisplayName = "\(User.sharedInstance.firstName ?? "") \(User.sharedInstance.lastName ?? "")"
        
        socket.on("message-\(self.viewModel.groupMessage.id)") { data, _ in
            guard let json = data.first as? JSON else { return }
            guard let messageJSON = json["message"] as? JSON else { return }
            
            dispatch_async(dispatch_get_main_queue(), { 
                let message = Message(json: messageJSON)
                self.viewModel.addMessage(message)
                self.collectionView.reloadData()
                self.scrollToBottomAnimated(true)
            })
        }
    }
}

extension DetailMessageViewController {
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = self.viewModel.messages.value[indexPath.row]
        if (message.senderId == self.senderId) {
            return outBuble
        }
        return inBuble
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = self.viewModel.messages.value[indexPath.row]
        
        if let date = message.date {
            let dateString = moment(date).add(1, TimeUnit.Hours).format("HH:mm")
            let dateString2 = moment(date).format("MMMM d, yyyy")
            return NSAttributedString(string: "\(dateString) \(dateString2)")
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.viewModel.messages.value[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.messages.value.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let msg = self.viewModel.messages.value[indexPath.row]
        
        if (!msg.isMediaMessage)  {
            if self.senderId == msg.senderId {
                cell.textView.textColor = UIColor.whiteColor()
            }
            else {
                cell.textView.textColor = UIColor.whiteColor()
            }
            cell.textView.text = msg.text ?? ""
        }
        return cell
    }
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let msg = self.viewModel.messages.value[indexPath.row]
        if self.senderId == msg.senderId {
            return nil
        }
        return NSAttributedString(string: msg.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let msg = self.viewModel.messages.value[indexPath.row]
        
        if msg.senderId == self.senderId {
            return 0
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        socket.emit("post-message", [
            "group": self.viewModel.groupMessage.id,
            "id": User.sharedInstance.id ?? "",
            "message": text
        ])

//        var message = Message(json: [:])
//        message.userId = User.sharedInstance.id
//        message.content = text
//        message.userName = User.sharedInstance.firstName
//        self.viewModel.addMessage(message)
//        self.collectionView.reloadData()
//        self.scrollToBottomAnimated(true)
    }
}