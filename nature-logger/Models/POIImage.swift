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
    private let id = UUID().uuidString
    var filename: URL {
        getDocumentsDirectory().appendingPathComponent(id)
    }
    
    init(image: UIImage) {
        self.image = image
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImage() {
        try? image.pngData()?.write(to: filename)
    }
}
