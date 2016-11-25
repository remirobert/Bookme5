//
//  GroupMessageViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 17/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class GroupMessageViewModel {
    
    private let disposeBag = DisposeBag()
    var group = Variable<[GroupMessageTableViewCellModel]>([])
    
    func fetchGroup() {
        let request = APIBookMe5.GetGroupeMessage
        
        Network.send(request: request).subscribeNext { response in
            print("response : \(response)")
            guard let response = response, let groups = response["groups"] as? [JSON] else {
                return
            }
            self.group.value.removeAll()
            for group in groups {
                if let groupMessage = GroupMessage(json: group) {
                    self.group.value.append(GroupMessageTableViewCellModel(group: groupMessage))
                }
            }
            print("groups : \(self.group.value)")
        }.addDisposableTo(self.disposeBag)
    }
}
