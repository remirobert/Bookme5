//
//  BookmarkListTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 05/09/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class BookmarkListCellViewModel: CellModel {
    let name: String
    let description: String?
    let id: String
    
    init(name: String, description: String?, id: String) {
        self.name = name
        self.description = name
        self.id = id
        super.init(cell: BookmarkListTableViewCell.self)
        self.dynamicHeightEnabled = true
    }
}

class BookmarkListTableViewCell: Cell, CellType {
    
    typealias CellModel = BookmarkListCellViewModel
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        self.labelTitle.text = cellmodel.name
        self.labelDescription.text = cellmodel.description
    }
}
