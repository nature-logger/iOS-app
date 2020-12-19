//
//  Image.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 17/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation
import UIKit

class POIImage {
    private var image: UIImage
    let id = "poiimage"
    var filename: String {
        id
    }
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    init(image: UIImage) {
        self.image = image
    }
    
    func saveImage() {
        save(image: image)
    }
    
    private func save(image: UIImage){
        let fileName = id
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
        }
        print("Error saving image")
    }
}
