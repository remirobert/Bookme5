//
//  DescriptionTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 03/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class DescriptionCellViewModel: CellModel {
    
    var descriptionDeatail: String
    
    init(description: String) {
        self.descriptionDeatail = description
        super.init(cell: DescriptionTableViewCell.self)
        //self.dynamicHeightEnabled = true
    }
}

class DescriptionTableViewCell: Cell, CellType {
    
    typealias CellModel = DescriptionCellViewModel
    
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.cellmodel?.dynamicHeightEnabled = true
        self.labelDescription.numberOfLines = 0
        self.selectionStyle = .None
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        
        self.labelDescription.text = cellmodel.descriptionDeatail
        cellmodel.height = heightForView(cellmodel.descriptionDeatail, width: UIScreen.mainScreen().bounds.size.width)
    }
}
