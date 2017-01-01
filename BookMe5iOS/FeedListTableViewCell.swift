//
//  FeedListTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 27/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import PINRemoteImage
import HCSStarRatingView
import Hakuba

class FeedListCellViewModel: CellModel {
    var buisiness: Buisiness
    
    init(buisiness: Buisiness) {
        self.buisiness = buisiness
        super.init(cell: FeedListTableViewCell.self, height: 109, selectionHandler: nil)
    }
}


class FeedListTableViewCell: Cell, CellType {
    
    typealias CellModel = FeedListCellViewModel
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageViewPlace: UIImageView!
    @IBOutlet weak var ratingView: HCSStarRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None

        self.imageViewPlace.backgroundColor = UIColor.lightGrayColor()
        self.imageViewPlace.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func prepareForReuse() {
        self.imageViewPlace.image = nil
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        
        let buisiness = cellmodel.buisiness

        self.ratingView.value = CGFloat(buisiness.rating)
        
        self.labelName.text = buisiness.name
        self.labelDescription.text = buisiness.description

        self.labelDescription.sizeToFit()
        
        self.imageViewPlace.image = nil
        if let pictureUrl = buisiness.pictures?.first, let url = NSURL(string: pictureUrl) {
            self.imageViewPlace.pin_setImageFromURL(url)
        }
    }
}
