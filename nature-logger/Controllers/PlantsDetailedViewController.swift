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
    @IBOutlet weak var attrLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var legsLabel: UILabel!
    
    var hero:Plants.Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = hero?.common_name
        

        var imageUrl = URL(string: "placeholder.png")!
        
        if(hero?.image_url != nil){
            imageUrl = URL(string: hero!.image_url)!
        }
        ImageDownload().downloadImage(from: imageUrl, completed: {data in
            self.imageView.image = UIImage(data: data!)
        });
        
        //downloadImage(from: url)
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
