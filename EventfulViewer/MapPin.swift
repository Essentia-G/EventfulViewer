//
//  MapPin.swift
//  EventfulViewer
//
//  Created by Станислава on 28/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let descript: String
    let url: URL?
    let startTime: String

    init(coordinate: CLLocationCoordinate2D, title: String?, descript: String, url: URL?, startTime: String) {
        self.coordinate = coordinate
        self.title = title
        self.descript = descript
        self.url = url
        self.startTime = startTime
        super.init()
    }
}
