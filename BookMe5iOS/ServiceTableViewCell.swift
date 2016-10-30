//
//  ServiceTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 08/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class ServiceCellViewModel: CellModel {
    
    var service: Service
    
    init(service: Service) {
        self.service = service
        super.init(cell: ServiceTableViewCell.self)
    }
}

class ServiceTableViewCell: Cell, CellType {
    
    typealias CellModel = ServiceCellViewModel
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelNumberPerson: UILabel!
    @IBOutlet weak var labelPriceService: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else { return }
        
        self.labelTitle.text = cellmodel.service.title
        self.labelPrice.text = cellmodel.service.description
        self.labelTime.text = nil
        if let price = cellmodel.service.price {
            self.labelTime.text = "\(price) minutes"
        }
        
        self.labelNumberPerson.text = nil
        if cellmodel.service.people > 0 {
            self.labelNumberPerson.text = "\(cellmodel.service.people) personnes"
        }
        
        self.labelPriceService.text = nil
        if let price = cellmodel.service.price {
            self.labelPriceService.text = "\(price)€"
        }
        
        if let description = cellmodel.service.description {
            cellmodel.height = heightForView(description, width: UIScreen.mainScreen().bounds.size.width) + 55
        }
        else {
            cellmodel.height = 55
        }
    }
}
