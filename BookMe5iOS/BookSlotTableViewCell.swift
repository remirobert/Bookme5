//
//  BookSlotTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 23/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import SwiftMoment

class BookSlotViewModel: CellModel {
    
    let date: NSDate
    var timeInterval: Int
    var booked = false
    
    init(date: NSDate, interval: Int) {
        self.date = date
        self.timeInterval = interval
        super.init(cell: BookSlotTableViewCell.self, height: 44, selectionHandler: nil)
    }
}

class BookSlotTableViewCell: Cell, CellType {
    
    typealias CellModel = BookSlotViewModel
    
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var viewSeparator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        
        self.labelHour.textColor = cellmodel.booked ? UIColor.whiteColor() : UIColor.darkGrayColor()
        
        self.contentView.backgroundColor = cellmodel.booked ? UIColor(red:0.49, green:0.85, blue:0.50, alpha:1.00) : UIColor.whiteColor()
        
        let momentDate = moment(cellmodel.date)
        print("display cell time : \(momentDate.date)")
        self.labelHour.text = momentDate.format("HH:mm")
        
        self.viewSeparator.backgroundColor = cellmodel.booked ? UIColor.whiteColor() : UIColor.lightGrayColor()
    }
}
