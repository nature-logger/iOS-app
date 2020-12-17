//
//  PlantsDetailedViewController.swift
//  nature-logger
//
//  Created by Frederik Helth on 15/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit

class PlantsDetailedViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var plant:Plants.Result?
    
    /// - Description:Sets the virables and downloads the image from the API url if there is one
    ///
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = plant?.common_name
        
        var imageUrl = URL(string: "placeholder.png")!
        
        if(plant?.image_url != nil){
            imageUrl = URL(string: plant!.image_url)!
        }
        ImageDownload().downloadImage(from: imageUrl, completed: {data in
            self.imageView.image = UIImage(data: data!)
        });
        
    }
}
