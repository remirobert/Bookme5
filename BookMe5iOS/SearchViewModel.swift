//
//  SearchViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 20/05/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewModel {
    
    private let disposeBag = DisposeBag()
    var searchResult: Variable<[SearchResultViewModel]> = Variable([])
    
    func search(input: String) {
        let request = APIBookMe5.SearchBuisiness(input: input)
        Network.send(request: request, parse: Buisiness.instanceBuisiness).subscribeNext { (results: [Buisiness]?) in
            guard let results = results else {
                self.searchResult.value = []
                return
            }
            
            self.searchResult.value = results.map({ (buisiness: Buisiness) -> SearchResultViewModel in
                return SearchResultViewModel(buisiness: buisiness)
            })
            }.addDisposableTo(self.disposeBag)
    }
}
