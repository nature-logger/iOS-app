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
    private let fileExtension = ".jpg"
    private var image: UIImage
    
    
    init(image: UIImage) {
        self.image = image
    }
    
    func saveImage() -> String? {
        if let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName =  UUID().uuidString + fileExtension
            let fileURL = filePath.appendingPathComponent(fileName)
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                do {
                    try imageData.write(to: fileURL, options: .atomic)
                    return fileName
                } catch {
                   print(error)
                }
            }
        }
        return nil
    }
}
