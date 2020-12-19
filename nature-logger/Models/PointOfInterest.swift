//
//  Entry.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 04/11/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation
import CoreLocation

class PointOfInterest: Codable {
    let created: Date
    private var longitude: Double?
    private var latitude: Double?
    var location: CLLocationCoordinate2D? {
        get {
            if let longitude = self.longitude, let latitude = self.latitude {
                return CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
            }
            return nil
        }
        set {
            if let location = newValue {
                longitude = location.longitude
                latitude = location.latitude
            }
        }
    }
    private(set) var description: String?
    private(set) var id: UUID?
    private(set) var owner: String? //For future online features maybe.
    private(set) var title: String
    
    init(title: String, description: String?, uuid: UUID?) {
        self.created = Date()
        self.title = title
        self.description = description
        self.id = uuid
    }
    	
    public func setTitle(title: String){
        self.title = title
    }
    
    public func setOwner(owner: String){
        self.owner = owner
    }
    
    public func setDescription(description: String){
        self.description = description
    }
    
    func filePath() -> URL? {
        if let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first, id != nil {
            let imageURL = URL(fileURLWithPath: paths).appendingPathComponent(id!.uuidString)
            return imageURL
        } else {
            return nil
        }
    }
}
