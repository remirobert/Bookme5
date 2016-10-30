//
//  HeaderServicesTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 04/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class HeaderServicesViewModel: HeaderFooterViewModel {
    
    let titleHeader: String
    
    init(title: String) {
        self.titleHeader = title
        super.init(view: HeaderServicesTableViewCell.self)
        self.height = 50
    }
}

class HeaderServicesTableViewCell: HeaderFooterView, HeaderFooterViewType {

    typealias ViewModel = HeaderServicesViewModel
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        self.labelTitle.text = self.viewmodel?.titleHeader
    }
}
