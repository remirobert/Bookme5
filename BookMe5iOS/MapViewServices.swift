//
//  MapViewServices.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 13/03/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import MapKit

class PointMapModel: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    let buisiness: Buisiness
    var coordinate: CLLocationCoordinate2D
    
    init(buisiness: Buisiness) {
        self.buisiness = buisiness
        self.title = buisiness.name
        self.subtitle = buisiness.location?.addr
        self.coordinate = CLLocationCoordinate2D(latitude: buisiness.location?.lat ?? 0, longitude: buisiness.location?.lon ?? 0)
    }
}

class MapViewServices: UIView {
    
    @IBOutlet weak var mapview: MKMapView!
    
    private var points: [PointMapModel]? {
        didSet {
            guard let points = self.points else {
                return
            }
            self.mapview.addAnnotations(points)
        }
    }
    
    func configure(datas: [Buisiness]) {
        self.points = datas.map { PointMapModel(buisiness: $0) }
    }
}
