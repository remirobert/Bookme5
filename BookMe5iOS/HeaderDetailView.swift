//
//  HeaderDetailTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 11/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class HeaderDetailView: UIView {

    @IBOutlet weak var imageViewDetail: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var categorieView: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    
    private var maskLayer: CAShapeLayer!
    
    private func updateCategorieMaskLayer() {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 60))
        path.addLineToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: CGRectGetWidth(UIScreen.mainScreen().bounds), y: 60))
        path.addLineToPoint(CGPoint(x: 0, y: 60))
        self.maskLayer.path = path.CGPath
    }
    
    override func layoutSubviews() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds) + 100, 300)
        gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor, UIColor.clearColor().CGColor]
        self.contentView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    override func awakeFromNib() {
        self.imageViewDetail.layer.masksToBounds = true
        
        self.maskLayer = CAShapeLayer()
        self.maskLayer.fillColor = UIColor.redColor().CGColor
        self.categorieView.layer.mask = self.maskLayer
        self.updateCategorieMaskLayer()
    }
}
