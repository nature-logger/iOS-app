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
    
    private var documentsUrl: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    
    init(image: UIImage) {
        self.image = image
    }
    
    func saveImage() -> String? {
        if (documentsUrl != nil){
            let fileName =  UUID().uuidString.replacingOccurrences(of: "-", with: "_").lowercased() + ".jpg"
            let fileURL = documentsUrl!.appendingPathComponent(fileName)
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
