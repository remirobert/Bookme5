//
//  ServiceInfoTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 07/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class ServiceInfoViewModel: CellModel {
    var service: Service
    
    init(service: Service) {
        self.service = service
        super.init(cell: ServiceInfoTableViewCell.self, height: 40, selectionHandler: nil)
    }
}

class ServiceInfoTableViewCell: Cell, CellType {
    
    typealias CellModel = ServiceInfoViewModel
    
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelPeople: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        self.labelPeople.text = nil
        if cellmodel.service.people > 0 {
            self.labelPeople.text = "\(cellmodel.service.people) personnes"
        }
        
        self.labelPrice.text = nil
        if let price = cellmodel.service.price {
            self.labelPrice.text = "\(price)€"
        }
        
        self.labelDuration.text = nil
        if let duration = cellmodel.service.duration {
            self.labelDuration.text = "\(duration) minutes"
        }
    }
}
