//
//  HeaderDetailBookingView.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 07/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class HeaderDetailBookingViewModel: HeaderFooterViewModel {
    let titleBuisiness: String
    
    init(title: String) {
        self.titleBuisiness = title
        super.init(view: HeaderDetailBookingView.self)
        self.height = 64
    }
}

class HeaderDetailBookingView: HeaderFooterView, HeaderFooterViewType {
    
    typealias ViewModel = HeaderDetailBookingViewModel
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let viewmodel = self.viewmodel else {
            return
        }
        self.labelTitle.text = viewmodel.titleBuisiness
    }
}
