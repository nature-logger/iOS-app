//
//  SaveImage.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 19/12/2020. With link: https://stackoverflow.com/questions/37344822/saving-image-and-then-loading-it-in-swift-ios/53894441#53894441
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit

extension UIImage {
    func saveImage(imageName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = self.jpegData(compressionQuality: 1)
        else {
            return
        }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    convenience init?(withName fileName: URL) {
        do {
            let data = try Data(contentsOf: fileName)
            self.init(data: data, scale: 1.0)
        } catch {
            return nil
        }
    }
}
