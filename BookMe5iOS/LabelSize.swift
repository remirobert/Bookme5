//
//  LabelSize.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 08/09/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

func heightForView(text:String, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}
