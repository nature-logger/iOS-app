//
//  LogEntry.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 18/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation

class LogEntries: Codable {
    var pois: [PointOfInterest] = []
    var file = "entries.json"
    
    init(poi: PointOfInterest) {
        self.readFromPath()
        self.pois.append(poi)
        self.saveToPath()
    }
    
    func saveToPath() {
        let jsonEncoder = JSONEncoder()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let data = try? jsonEncoder.encode(pois)
            let fileURL = dir.appendingPathComponent(file)
            try? data?.write(to: fileURL)
            print(pois)
        }
    }
    
    func readFromPath() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            let data = try? Data(contentsOf: fileURL)
            if (data != nil) {
                let poiData = try? JSONDecoder().decode([PointOfInterest].self, from: data!)
                pois = poiData ?? []
            }
        }
    }
}
