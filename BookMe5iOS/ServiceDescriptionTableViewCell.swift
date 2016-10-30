//
//  ServiceDescriptionTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 07/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class ServiceDescriptionViewModel: CellModel {
    var content: String
    
    init(content: String) {
        self.content = content
        super.init(cell: ServiceDescriptionTableViewCell.self, height: 100, selectionHandler: nil)
    }
}

class ServiceDescriptionTableViewCell: Cell, CellType {
    
    typealias CellModel = ServiceDescriptionViewModel
    
    @IBOutlet weak var labelContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        print("description : \(cellmodel.content)")
        self.labelContent.text = cellmodel.content
        cellmodel.height = heightForView(cellmodel.content, width: UIScreen.mainScreen().bounds.size.width) + 20
    }
}
