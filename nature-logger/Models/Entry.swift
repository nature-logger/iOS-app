//
//  Entry.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 04/11/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation
import CoreLocation

class Entry:Codable {
    var timestamp: Date
    //var coordinate: CLLocationCoordinate2D?
    var title: String
    var description: String?
    var imagePath: URL?
    var owner: String? //For future online features maybe.
    
    init(title: String) {
        self.timestamp = Date()
        self.title = title
    }
}
