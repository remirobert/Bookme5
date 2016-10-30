//
//  ProfileReservationTableViewCell.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 22/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Hakuba
import SwiftMoment

class ProfileReservationModel: CellModel {
    let reservation: Reservation
    
    init(reservation: Reservation) {
        self.reservation = reservation
        super.init(cell: ProfileReservationTableViewCell.self, height: 55)
    }
}

class ProfileReservationTableViewCell: Cell, CellType {
    
    typealias CellModel = ProfileReservationModel
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00)
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else {
            return
        }
        let reservation = cellmodel.reservation
        self.labelTitle.text = reservation.service?.title
        if let date = reservation.start {
            let momentDate = moment(date, timeZone: NSTimeZone.defaultTimeZone(),
                                    locale: NSLocale(localeIdentifier: "fr"))
            self.labelTime.text = "Le \(momentDate.format("d MMMM, yyyy")), à \(momentDate.format("HH:mm"))"
        }
    }
}
