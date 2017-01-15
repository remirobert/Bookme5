//
//  DetailBookViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 24/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import SwiftMoment
import RealmSwift

protocol DetailBookViewModelDelegate {
    func didGetErrorBooking()
    func didGetSuccessBooking()
}

class DetailBookViewModel {
    
    private var disposeBag = DisposeBag()
    
    var service: Service?
    var buisiness: Buisiness?
    var date: NSDate?
    
    var delegate: DetailBookViewModelDelegate?
    
    func postStatsBook() {
        guard let id = self.buisiness?.id else {
            return
        }
        let request = APIBookMe5.PostStatsBook(id: id)
        Network.send(request: request).subscribeNext { response in
            print("response book stats : \(response)")
            }.addDisposableTo(self.disposeBag)
    }
    
    private func createReservation() {
        guard let service = self.service, let buisiness = self.buisiness else {
            return
        }

        guard let date = service.date else {
            return
        }

        let notification = UILocalNotification()
        notification.fireDate = date
        notification.alertBody = "Rappel réservation : \(service.title ?? "")"
        notification.timeZone = NSTimeZone.defaultTimeZone()
        UIApplication.sharedApplication().scheduleLocalNotification(notification)

//        let reservation = Reservation()
//        reservation.businessId = buisiness.id
//        reservation.date = self.date
//        reservation.descriptionService = service.description
//        reservation.title = service.title
//        reservation.price = service.price
//        reservation.durationService = service.duration ?? 0
//        reservation.image = service.image
//        reservation.businessName = buisiness.name
//        reservation.latitude = buisiness.location?.lat ?? 0
//        reservation.longitude = buisiness.location?.lon ?? 0
//        reservation.address = buisiness.location?.addr
//        
//        do {
//            let realm = try Realm()
//            try realm.write({ 
//                realm.add(reservation)
//            })
//        }
//        catch {
//            print("Error realm save reservation")
//        }
    }
    
    func bookService() {
        guard let serviceId = self.service?.id,
            let buisinessId = self.buisiness?.id,
            let dateBook = self.date else {
                return
        }
        
        let stringDate = moment(dateBook).format()
        
        let request = APIBookMe5.BookService(id: buisinessId, service: serviceId, date: stringDate)
        
        Network.send(request: request, debug: true).subscribe { (event) in
            switch event {
            case .Next(let response):
                print("response : \(response)")
                self.postStatsBook()
                self.createReservation()
                self.delegate?.didGetSuccessBooking()
            case .Error(let error):
                self.delegate?.didGetErrorBooking()
                print("error : \(error)")
            default: break
            }
            }.addDisposableTo(self.disposeBag)
    }
}
