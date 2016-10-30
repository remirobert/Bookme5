//
//  DetailServiceViewModel.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 08/07/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import Hakuba

class DetailServiceViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    var models = Variable<[CellModel]>([])
    
    var service: Service
    var buisiness: Buisiness
    
    func initModels() {
        var models = [CellModel]()
        
        if let image = self.service.image {
            let modelPicture = ServicePictureViewModel(url: image)
            models.append(modelPicture)
        }
        
        if let title = self.service.title {
            models.append(ServiceDescriptionViewModel(content: title))
        }
        models.append(ServiceInfoViewModel(service: self.service))
        if let description = self.service.description {
            models.append(ServiceDescriptionViewModel(content: description))
        }
        self.models.value = models
    }
    
    init(service: Service, buisiness: Buisiness) {
        self.service = service
        self.buisiness = buisiness
        
    }
}
