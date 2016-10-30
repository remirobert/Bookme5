//
//  ProfileHeaderSelector.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 04/09/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import RxSwift
import RxCocoa

enum ProfileStateEvent: Int {
    case Comming
    case Past
}

class ProfileHeaderViewModel: HeaderFooterViewModel {
    
    var state = Variable<ProfileStateEvent>(.Comming)
    
    init() {
        super.init(view: ProfileHeaderSelector.self)
        self.height = 44
    }
}

class ProfileHeaderSelector: HeaderFooterView, HeaderFooterViewType {
    
    typealias ViewModel = ProfileHeaderViewModel
    
    private let disposebag = DisposeBag()
    
    @IBOutlet weak var selector: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let viewmodel = self.viewmodel else {
            return
        }
        
        self.selector.rx_value.asObservable().subscribeNext {
            viewmodel.state.value = ProfileStateEvent(rawValue: $0)!
            }.addDisposableTo(self.disposebag)
    }
}
