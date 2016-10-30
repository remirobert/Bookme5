//
//  DetailThumbServiceCollectionViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 11/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class DetailThumbServiceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewDetail: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds) + 100, 100)
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        self.viewContent.backgroundColor = UIColor.clearColor()
        self.viewContent.layer.insertSublayer(gradient, atIndex: 0)
    }
}
