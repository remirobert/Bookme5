//
//  DetailBookingImageTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 22/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import PINRemoteImage

class DetailBookingImageModel: CellModel {
    let image: String
    
    init(image: String) {
        self.image = image
        super.init(cell: DetailBookingImageTableViewCell.self, height: 200)
    }
}

class DetailBookingImageTableViewCell: Cell, CellType {
    
    typealias CellModel = DetailBookingImageModel
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageview.layer.masksToBounds = true
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        guard let url = NSURL(string: cellmodel.image) else {
            return
        }
        self.imageview.pin_setImageFromURL(url)
    }
}
