//
//  PointOfInterestViewController.swift
//  nature-logger
//
//  Created by Donat on 12.11.20.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit

class PointOfInterestViewController: UIViewController {
    
    private var imageValue: UIImage?
    var image: UIImage? {
        get {
            capturedImage.image
        }
        set {
            if let imageView = capturedImage {
                imageView.image = newValue
            } else {
                imageValue = newValue
            }
        }
    }
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        capturedImage.image = imageValue
    }
    
    @IBAction func submitEntry(_ sender: Any) {
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
