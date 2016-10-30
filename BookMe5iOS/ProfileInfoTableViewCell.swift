//
//  ProfileInfoTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 22/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import PINRemoteImage

class ProfileInfoModel: CellModel {
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(cell: ProfileInfoTableViewCell.self, height: 100)
    }
}

class ProfileInfoTableViewCell: Cell, CellType {
    
    typealias CellModel = ProfileInfoModel
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageview.layer.masksToBounds = true
        self.imageview.layer.cornerRadius = 35
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        if let image = cellmodel.user.pictureProfileUrl {
            if let url = NSURL(string: image) {
                self.imageview.pin_setImageFromURL(url)
            }
        }
        self.labelName.text = "\(cellmodel.user.firstName ?? "") \(cellmodel.user.lastName ?? "")"
        self.labelEmail.text = cellmodel.user.email
    }
}
