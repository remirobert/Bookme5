//
//  SearchCategoriesTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 12/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class SearchCategoriesViewModel: CellModel {
    
    var category: String
    
    init(category: String) {
        self.category = category
        super.init(cell: SearchCategoriesTableViewCell.self, height: 60, selectionHandler: nil)
    }
}

class SearchCategoriesTableViewCell: Cell, CellType {
    
    typealias CellModel = SearchCategoriesViewModel
    
    @IBOutlet weak var labelCategorie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        self.labelCategorie.text = cellmodel.category
    }
}
