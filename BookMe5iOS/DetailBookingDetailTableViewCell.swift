//
//  DetailBookingDetailTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 07/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import SwiftMoment

class DetailBookingDetailViewModel: CellModel {
    let service: Service
    let date: NSDate
    
    init(service: Service, date: NSDate) {
        self.service = service
        self.date = date
        super.init(cell: DetailBookingDetailTableViewCell.self, height: 120, selectionHandler: nil)
    }
}

class DetailBookingDetailTableViewCell: Cell, CellType {
    
    typealias CellModel = DetailBookingDetailViewModel
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelHours: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        let service = cellmodel.service
        self.labelTitle.text = service.title
        
        let momentDate = moment(cellmodel.date,
                                timeZone: NSTimeZone.defaultTimeZone(),
                                locale: NSLocale(localeIdentifier: "fr"))
        self.labelDate.text = "Le \(momentDate.format("d MMMM, yyyy"))"
        self.labelHours.text = "à \(momentDate.format("HH:mm"))"
    }
}
