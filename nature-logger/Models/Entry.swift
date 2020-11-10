//
//  Entry.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 04/11/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable {
    var longitude: Double
    var latitude: Double
    init(location: CLLocationCoordinate2D){
        longitude = location.longitude
        latitude = location.latitude
    }
    init(longitude: Double, latitude: Double){
        self.longitude = longitude
        self.latitude = latitude
    }
}

class Entry:Codable {
    var timestamp: Date
    var title: String
    var location: Location?
    var description: String?
    var imagePath: URL?
    var owner: String? //For future online features maybe.
    
    init(title: String) {
        self.timestamp = Date()
        self.title = title
    }
}
