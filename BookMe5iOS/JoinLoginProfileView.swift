//
//  JoinLoginProfileView.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 16/02/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class JoinLoginProfileView: UIView {

    @IBOutlet weak var imageViewMap: UIImageView!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var observableLogin: ControlEvent<Void> {
        return self.buttonLogin.rx_controlEvent(.TouchUpInside)
    }
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        self.sendSubviewToBack(self.imageViewMap)
    }
}
