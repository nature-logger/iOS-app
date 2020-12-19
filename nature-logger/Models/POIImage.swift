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
    var filename: String {
        id + ".jpeg"
    }
    
    init(image: UIImage) {
        self.image = image
    }
    
    func saveImage() {
        self.image.saveImage(imageName: filename)
    }
}
