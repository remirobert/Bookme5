//
//  LocationManager.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 07/08/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import MapKit

class LocationManager {
    
    class func region(address: String, completion: (region: MKCoordinateRegion?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (places: [CLPlacemark]?, _) in
            guard let place = places?.first else {
                completion(region: nil)
                return
            }
            let placemark = MKPlacemark(placemark: place)
            var region = MKCoordinateRegion()
            region.center.latitude = placemark.coordinate.latitude
            region.center.longitude = placemark.coordinate.longitude
            region.span.longitudeDelta = 0.15
            region.span.latitudeDelta = 0.15
            completion(region: region)
        }
    }
}
