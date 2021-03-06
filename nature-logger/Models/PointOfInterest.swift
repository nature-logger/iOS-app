//
//  Entry.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 04/11/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

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
    private(set) var imageFileName: String?
    private(set) var owner: String? //For future online features maybe.
    private(set) var title: String
    
    init(title: String, description: String?, imageFileName: String?) {
        self.created = Date()
        self.title = title
        self.description = description
        self.imageFileName = imageFileName
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
    
    func loadImage() -> UIImage? {
        if let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, imageFileName != nil {
            let fileURL = filePath.appendingPathComponent(imageFileName!)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
        }
        return nil
    }
}
