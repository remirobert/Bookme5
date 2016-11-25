//
//  BookCalendarViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 23/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import SwiftMoment

struct UnavailabilitySlot {
    var start: Int
    var end: Int
}

class BookCalendarViewModel {
    
    private let disposeBag = DisposeBag()
    var service: Service?
    var buisiness: Buisiness?
    
    var slots: Variable<[BookSlotViewModel]> = Variable([])
    
    private func generateUnavailabilitySlots(response: [JSON], date: NSDate) -> [UnavailabilitySlot] {
        return response.map { (slotJSON: [String : AnyObject]) -> UnavailabilitySlot? in
            guard let end = slotJSON["end"] as? String, let start = slotJSON["start"] as? String else {
                return nil
            }
            guard let startDateMoment = moment(start) else {
                return nil
            }
            print("start current timeinterval : \(startDateMoment.hour)")
            guard let startTime = moment(end)?.hour,
                let endTime = moment(start)?.hour else {
                    return nil
            }
            print("start time duration : \(startTime * 60 + 60)")
            return UnavailabilitySlot(start: startTime * 60 + 60, end: endTime * 60 + 60)
            }.flatMap({ $0 })
    }
    
    private func generateSlots(date: NSDate, unavailabilitySlots: [UnavailabilitySlot]) {
        self.slots.value.removeAll()
        
        guard let start = self.buisiness?.start, let end = self.buisiness?.end else {
            return
        }
        
        let startTime = (moment(start).hour + 2) * 60
        let endTime = (moment(end).hour + 2)  * 60
        
        let timeInterval = self.service!.duration!
        var currentTime = Double(startTime)
        var slotsAvailable = [BookSlotViewModel]()
        
        while currentTime < Double(endTime) {
            var momentCurrent = moment(date)
            momentCurrent = momentCurrent.subtract(momentCurrent.hour + 2, .Hours)
            momentCurrent = momentCurrent.subtract(momentCurrent.minute, .Minutes)
            momentCurrent = momentCurrent.subtract(momentCurrent.second, .Seconds)
            momentCurrent = momentCurrent.add(currentTime, .Minutes)
            print("current time : \(currentTime) date : \(momentCurrent.date)")
            let slot = BookSlotViewModel(date: momentCurrent.date, interval: Int(currentTime))
            slotsAvailable.append(slot)
            currentTime += timeInterval
        }
        
        self.slots.value = slotsAvailable.filter({ (slot: BookSlotViewModel) -> Bool in
            for unavailability in unavailabilitySlots {
                if unavailability.start == slot.timeInterval {
                    print("slot time : \(unavailability.start) : \(slot.date)")
                    return false
                }
            }
            return true
        })
        
        for slot in self.slots.value {
            print("slot dispo : \(slot.date)")
        }
    }
    
    func getSlotsDate(date: NSDate) {
        guard let service = self.service, let id = service.id else {
            return
        }
        let request = APIBookMe5.ServiceIndisponibilities(id: id, date: date)
        Network.send(request: request).subscribe { (event) in
            switch event {
            case .Next(let response):
                var unavailabilitySlots = [UnavailabilitySlot]()
                if let response = response?["unavailability"] as? [JSON] {
                    unavailabilitySlots = self.generateUnavailabilitySlots(response, date: date)
                }
                print("number slots : \(unavailabilitySlots.count)")
                self.generateSlots(date, unavailabilitySlots: unavailabilitySlots)
            case .Error(let error):
                self.slots.value = []
                print("error : \(error)")
            default: break
            }
            }.addDisposableTo(self.disposeBag)
    }
}
