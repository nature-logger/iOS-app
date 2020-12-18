//
//  ImageDownload.swift
//  nature-logger
//
//  Created by Frederik Helth on 15/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation

class ImageDownload {
    
    /// - Description: Downloads the data from the image url and runs the completion function
    ///
    /// - Parameter url: URL to fetch the data from
    /// - Parameter completion: Function to execute once the fetching is done
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    /// - Description: Handles the data from the getData function async and update the main thread once finished
    ///
    /// - Parameter url: URL to fetch the data from
    /// - Parameter completed: Function to execute once the function is done
    func downloadImage(from url: URL, completed: @escaping (Data?) -> ()) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completed(data)
            }
        }
    }
    
}
