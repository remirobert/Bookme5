//
//  HeaderDetailBuisinessTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 03/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class HeaderDetailBuisinessViewModel: HeaderFooterViewModel {
    
    var name: String
    
    init(name: String) {
        self.name = name
        super.init(view: HeaderDetailBuisinessTableViewCell.self)
        self.height = 70
    }
}

class HeaderDetailBuisinessTableViewCell: HeaderFooterView, HeaderFooterViewType {
    
    typealias ViewModel = HeaderDetailBuisinessViewModel
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backButton.setImage(UIImage(named: "backButton")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        self.backButton.tintColor = UIColor.whiteColor()
    }
    
    override func configure() {
        guard let viewmodel = self.viewmodel else {
            return
        }
        self.labelName.text = viewmodel.name
    }
}
