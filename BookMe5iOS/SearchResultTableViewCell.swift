//
//  SearchResultTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 17/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class SearchResultViewModel: CellModel {
    
    let buisiness: Buisiness
    
    init(buisiness: Buisiness) {
        self.buisiness = buisiness
        super.init(cell: SearchResultTableViewCell.self, height: 50, selectionHandler: nil)
    }
}

class SearchResultTableViewCell: Cell, CellType {
    
    typealias CellModel = SearchResultViewModel
    
    @IBOutlet weak var labelBuissiness: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        let buisiness = cellmodel.buisiness
        self.labelBuissiness.text = buisiness.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.labelBuissiness.text = nil
    }
}
