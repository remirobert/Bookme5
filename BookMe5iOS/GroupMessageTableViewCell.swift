//
//  GroupMessageTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 17/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba

class GroupMessageTableViewCellModel: CellModel {
    let group: GroupMessage
    
    init(group: GroupMessage) {
        self.group = group
        super.init(cell: GroupMessageTableViewCell.self, height: 44)
    }
}

class GroupMessageTableViewCell: Cell, CellType {

    typealias CellModel = GroupMessageTableViewCellModel
    
    @IBOutlet weak var labelMessageCount: UILabel!
    @IBOutlet weak var labelNameBusiness: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        let group = cellmodel.group
        self.labelMessageCount.text = "\(group.messages.count)"
        self.labelNameBusiness.text = "\(group.business?.description)"
    }
}
