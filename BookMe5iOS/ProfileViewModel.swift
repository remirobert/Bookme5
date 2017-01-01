//
//  ProfileViewModel.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 25/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

enum ProfileProperty: String {
    case FirstName = "firstName"
    case LastName = "lastName"
}

class ProfileViewModel {
    
    private var _login = Variable("")
    var login: Observable<String> { return _login.asObservable() }
    
    private var _pictureUrl = Variable("")
    var pictureUrl: Observable<String> {
        return self._pictureUrl.asObservable()
    }
    
    var reservations = Variable<[Reservation]>([])
    
    let disposeBag = DisposeBag()
    
    func getReservationsUser() {
        let request = APIBookMe5.GetReservations

        Network.send(request: request).subscribeNext { response in
            guard let tasks = response?["tasks"] as? [JSON] else {
                return
            }
            self.reservations.value = tasks.map({ jsonReservation -> Reservation? in
                return Reservation(json: jsonReservation)
            }).flatMap({ $0 })
        }.addDisposableTo(self.disposeBag)
    }
    
    private func bindUserInfos() {
        guard let firstName = User.sharedInstance.firstName, let lastName = User.sharedInstance.lastName else {
            return
        }
        self._login.value = "\(firstName) \(lastName)"
        if let pictureUrl = User.sharedInstance.pictureProfileUrl {
            self._pictureUrl.value = pictureUrl
        }
    }

    func cancelReservation(reservation: Reservation) {
        guard let id = reservation.id else {
            return
        }

        let request = APIBookMe5.CancelBooking(id: id)
        Network.send(request: request, debug: true).subscribeNext { _ in
            self.getReservationsUser()
        }.addDisposableTo(self.disposeBag)
    }
    
    func fetchUserInfos() {
        let request = APIBookMe5.User
        Network.send(request: request, parse: User.fromJSON).subscribeNext { user in
            self.bindUserInfos()
        }.addDisposableTo(self.disposeBag)
    }
    
    private func updateProfileInfos() -> Observable<Bool> {
        let parameters: JSON = [
            "firstname": User.sharedInstance.firstName ?? "",
            "lastname": User.sharedInstance.lastName ?? ""
        ]
        
        let request = APIBookMe5.UpdateUserInfo(params: parameters)
        
        return Network.send(request: request) { (response: JSON) -> Bool? in
            return response["success"] as? Bool
            }.flatMap { (success: Bool?) -> Observable<Bool> in
            return Observable.just(success ?? false)
        }
    }
    
    func updateProfileInfos(property: ProfileProperty, content: String) -> Observable<Bool> {
        switch property {
        case .FirstName: User.sharedInstance.firstName = content
        case .LastName: User.sharedInstance.lastName = content
        }
        return self.updateProfileInfos()
    }
    
    func logout() -> Observable<Bool> {
        return Observable.create { observer in
            do {
                try TokenAccess.removeToken()
                observer.onNext(true)
            }
            catch {
                observer.onNext(false)
            }
            observer.onCompleted()
            return NopDisposable.instance
        }
    }
    
    init() {
        self.fetchUserInfos()
    }
}
