//
//  DetailBookingLocationTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 07/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class DetailBookingLocationViewModel: CellModel {
    var buisiness: Buisiness
    
    init(buisiness: Buisiness) {
        self.buisiness = buisiness
        super.init(cell: DetailBookingLocationTableViewCell.self, height: 100, selectionHandler: nil)
    }
}

class DetailBookingLocationTableViewCell: Cell, CellType {
    
    typealias CellModel = DetailBookingLocationViewModel
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        let buisiness = cellmodel.buisiness
    }
}
