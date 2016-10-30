//
//  DetailBuisinessViewModel.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 18/02/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Hakuba

class DetailBuisinessViewModel: NSObject {
    
    private var cellModels = [CellModel]()
    private var disposeBag = DisposeBag()
    private var worker = false
    
    var models: Variable<[CellModel]> = Variable([CellModel]())
    var services: Variable<[ServiceCellViewModel]> = Variable([ServiceCellViewModel]())
    var comments = Variable<[Comment]>([])
    var header: Variable<HeaderDetailBuisinessViewModel?> = Variable(nil)
    var book = Variable<Bool?>(nil)
    var buisiness: Buisiness?
    
    func postStatsVisit() {
        guard let id = self.buisiness?.id else {
            return
        }
        let request = APIBookMe5.PostStatsVisit(id: id)
        Network.send(request: request).subscribeNext { response in
            print("response visit : \(response)")
        }.addDisposableTo(self.disposeBag)
    }
    
    func bookmark() {
        if self.worker {
            return
        }
        self.worker = true
        guard let id = self.buisiness?.id else {
            return
        }
        let request = APIBookMe5.PostBookMark(id: id)
        Network.send(request: request).subscribeNext { response in
            self.worker = false
            guard let response = response, let _ = response["res"] as? String else {
                return
            }
            self.getBookmarkStatus()
            }.addDisposableTo(self.disposeBag)
    }
    
    private func getBookmarkStatus() {
        guard let id = self.buisiness?.id else {
            return
        }
        let request = APIBookMe5.GetBookMark(id: id)
        Network.send(request: request).subscribeNext { response in
            guard let response = response, let res = response["res"] as? Bool else {
                return
            }
            self.book.value = !res
            }.addDisposableTo(self.disposeBag)
    }
    
    private func getServices() {
        guard let buisinessServices = self.buisiness?.services else {
            return
        }
        
        print("services : \(buisinessServices)")
        
        
        let requestsObservable = buisinessServices.map { (id: String) -> Observable<JSON?> in
            return Network.send(request: APIBookMe5.GetService(id: id))
        }
        
        requestsObservable.toObservable().merge().subscribeNext { (response: JSON?) in
            guard let response = response, let serviceJson = response["service"] as? JSON else {
                return
            }
            let service = Service(json: serviceJson)
            let model = ServiceCellViewModel(service: service)
            self.services.value.append(model)
            
            }.addDisposableTo(self.disposeBag)
    }
    
    private func initLocationModel() {
        let model = DetailLocationCellViewModel()
        model.location = self.buisiness?.location
        self.cellModels.append(model)
    }
    
    private func initDescriptionModel() {
        guard let description = self.buisiness!.description else {
            return
        }
        let model = DescriptionCellViewModel(description: description)
        self.cellModels.append(model)
    }
    
    private func initPictureModel() {
        guard let image = self.buisiness?.pictures?.first else {
            return
        }
        
        let model = PictureDetailCellViewModel(image: image)
        self.cellModels.append(model)
    }
    
    private func getComments() {
        let request = APIBookMe5.Comment
        Network.send(request: request).subscribeNext { response in
            print("response comments : \(response)")
            guard let response = response?["objects"] as? [JSON] else {
                return
            }
            self.comments.value = response.map({ commentJson -> Comment? in
                return Comment(json: commentJson)
            }).flatMap({ $0 })
            print("comments : \(self.comments.value)")
        }.addDisposableTo(self.disposeBag)
    }
    
    func initModels() {
        guard let buisiness = self.buisiness else {
            return
        }
        
        self.header.value = HeaderDetailBuisinessViewModel(name: buisiness.name)
        self.cellModels.removeAll()
        self.initPictureModel()
        self.initDescriptionModel()
        self.initLocationModel()
        
        self.models.value = self.cellModels
        
        self.getServices()
        self.getBookmarkStatus()
        self.getComments()
    }
}
