//
//  DetailReservationViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 23/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Hakuba

class DetailReservationViewModel {
    
    var models = Variable<[CellModel]>([])
    
    func bindUi(reservation: Reservation) {
        var models = [CellModel]()
        if let image = reservation.service?.image {
            models.append(DetailBookingImageModel(image: image))
        }
        if let date = reservation.start, let service = reservation.service {
            models.append(DetailBookingDetailViewModel(service: service, date: date))
        }
        let location = reservation.business?.location
        
        let model = DetailLocationCellViewModel()
        model.location = location
        models.append(model)
        self.models.value = models
    }
}
