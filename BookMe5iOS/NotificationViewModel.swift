//
//  NotificationViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 05/09/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class NotificationViewModel {
    
    private let disposeBag = DisposeBag()
    var models = Variable<[BookmarkListCellViewModel]>([])
    var business = Variable<[FeedListCellViewModel]>([])
    
    func fetchBookmarks() {
        let request = APIBookMe5.GetBookMarks
        
        Network.send(request: request).subscribeNext { response in
            guard let response = response, array = response["objects"] as? [JSON] else {
                self.business.value = []
                return
            }
            
            self.business.value.removeAll()
            for json in array {
                print("curre : \(json)")
                if let business = Buisiness(json: json["business"] as! JSON) {
                    self.business.value.append(FeedListCellViewModel(buisiness: business))
                }
            }
            }.addDisposableTo(self.disposeBag)
    }
}
