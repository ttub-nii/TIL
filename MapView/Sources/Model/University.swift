//
//  University.swift
//  MapView
//
//  Created by 황수빈 on 11/06/2019.
//  Copyright © 2019 황수빈. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class University: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    init (title: String, latitude: Double, longitude: Double) {
        self.title = title
        self.coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = latitude
        self.coordinate.longitude = longitude
    }
}
