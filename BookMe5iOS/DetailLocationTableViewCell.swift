//
//  DetailLocationTableViewCell.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 11/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import MapKit
import Hakuba

class DetailLocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(lat: Double, lon: Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

class DetailLocationCellViewModel: CellModel {
    
    var location: BuisinessLocation?
    
    init() {
        super.init(cell: DetailLocationTableViewCell.self, height: 220, selectionHandler: nil)
    }
}

class DetailLocationTableViewCell: Cell, CellType {
    
    typealias CellModel = DetailLocationCellViewModel
    
    @IBOutlet weak var labelAdress: UILabel!
    @IBOutlet weak var mapPreview: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    override func configure() {
        guard let cellmodel = self.cellmodel else { return }
        guard let location = cellmodel.location else { return }
        
        self.labelAdress.text = location.addr
        
        guard let address = location.addr else { return }
        LocationManager.region(address) { (region) in
            guard let region = region else {
                return
            }
            let annotation = DetailLocationAnnotation(lat: region.center.latitude, lon: region.center.longitude)
            self.mapPreview.addAnnotation(annotation)
            self.mapPreview.setRegion(region, animated: false)
        }
    }
}
