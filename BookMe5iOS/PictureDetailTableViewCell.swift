//
//  PictureDetailTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 04/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import PINRemoteImage

class PictureDetailCellViewModel: CellModel {

    var picture: String?
    
    init(image: String) {
        self.picture = image
        super.init(cell: PictureDetailTableViewCell.self, height: 200, selectionHandler: nil)
    }
}

class PictureDetailTableViewCell: Cell, CellType {

    typealias CellModel = PictureDetailCellViewModel
    
    @IBOutlet weak var imageViewPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.imageViewPicture.layer.masksToBounds = true
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel,
            let picture = cellmodel.picture,
        let url = NSURL(string: picture) else {
            return
        }
        self.imageViewPicture.pin_setImageFromURL(url)
    }
}
