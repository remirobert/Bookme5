//
//  FeedListViewModel.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 27/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class FeedListViewModel {
    
    let disposeBag = DisposeBag()
    var buisiness: Variable<Array<FeedListCellViewModel>> = Variable([])
    
    func fetchFeedList() {
        let request = APIBookMe5.FeedBusinesses
        
        Network.send(request: request, parse: Buisiness.instanceBuisiness).subscribeNext { (results: [Buisiness]?) in
            
            guard let results = results else {
                self.buisiness.value = []
                return
            }
            
            self.buisiness.value = results.map({ (buisiness: Buisiness) -> FeedListCellViewModel in
                return FeedListCellViewModel(buisiness: buisiness)
            })
            
            }.addDisposableTo(self.disposeBag)        
    }
    
    func selectedBuisiness(row: Int) -> Buisiness {
        return self.buisiness.value[row].buisiness
    }
}
