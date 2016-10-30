//
//  ServicePictureTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 07/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import PINRemoteImage

class ServicePictureViewModel: CellModel {
    
    var url: String
    
    init(url: String) {
        self.url = url
        super.init(cell: ServicePictureTableViewCell.self, height: 250, selectionHandler: nil)
    }
}

class ServicePictureTableViewCell: Cell, CellType {
    
    typealias CellModel = ServicePictureViewModel
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel,
            let url = NSURL(string: cellmodel.url) else {
                return
        }
        self.imageview.pin_setImageFromURL(url)
    }
}
