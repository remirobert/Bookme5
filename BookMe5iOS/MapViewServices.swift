//
//  MapViewServices.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 13/03/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewServicesDelegate: class {
    func didSelectView(b: Buisiness)
}

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

class MapViewServices: UIView, MKMapViewDelegate {

    @IBOutlet weak var mapview: MKMapView!

    weak var delegate: MapViewServicesDelegate?

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

    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapview.delegate = self
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let pinView: MKAnnotationView?

        if let view = self.mapview.dequeueReusableAnnotationViewWithIdentifier("cell") {
            pinView = view
        }
        else {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "cell")
        }
        pinView?.canShowCallout = false
        pinView?.image = UIImage(named: "pin")
        return pinView
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        guard let annotation = view.annotation as? PointMapModel else {
            return
        }
        self.delegate?.didSelectView(annotation.buisiness)
    }
}
