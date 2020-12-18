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
    let id = UUID().uuidString
    var filename: URL? {
        getDocumentsDirectory()?.appendingPathComponent(id).appendingPathExtension("png")
    }
    
    init(image: UIImage) {
        self.image = image
    }
    
    func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func saveImage() {
        guard filename != nil else {
            return
        }
        try? image.pngData()?.write(to: filename!)
    }
}
