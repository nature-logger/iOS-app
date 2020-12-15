//
//  ImageDownload.swift
//  nature-logger
//
//  Created by Frederik Helth on 15/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation

class ImageDownload {
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completed: @escaping (Data?) -> ()) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                //self?.imageView.image = UIImage(data: data)
                completed(data)
            }
        }
    }
    
}
