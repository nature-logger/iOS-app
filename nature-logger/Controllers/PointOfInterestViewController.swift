//
//  PointOfInterestViewController.swift
//  nature-logger
//
//  Created by Donat on 12.11.20.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit
import CoreLocation

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
                // Cache image until view is rendered.
                imageValue = newValue
            }
        }
    }
    var keyboardIsOpen = false
    var poiImage: POIImage? {
        if (image != nil) {
            return POIImage(image: image!)
        } else {
            return nil
        }
    }
    
    private var geoCoder: CLGeocoder!
    private var locationManager: CLLocationManager!
    private var location: CLLocation!
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAndTextFieldLayout()
        
        geoCoder = CLGeocoder()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        registerNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        capturedImage.image = imageValue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func submitEntry(_ sender: Any) {
        locationManager.requestLocation()
        let fileName = self.poiImage?.saveImage()
        let storyboard = UIStoryboard(name: "LogEntries", bundle: nil)
        let logEntriesTableViewController = storyboard.instantiateViewController(identifier: "LogEntriesTableViewController") as! LogEntriesTableViewController
        let poi = PointOfInterest(title: titleText.text ?? "Untitled", description: descriptionText.text, imageFileName: fileName, longitude: locationManager.location?.coordinate.longitude, latitude: locationManager.location?.coordinate.latitude)
        logEntriesTableViewController.poi = poi
        show(logEntriesTableViewController, sender: self)
    }
    
    // Sets the keyboard for the scrollview with the keyboard height as the contentInset
    func setInsetAndScroll(notification: NSNotification, keyboardShown: Bool) {
        let isKeyboardInUse = !keyboardIsOpen && keyboardShown || keyboardIsOpen && !keyboardShown
        
        guard let userInfo = notification.userInfo, isKeyboardInUse, var keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        keyboardSize = self.view.convert(keyboardSize, from: nil)
        var contentOffset = scrollView.contentOffset
        if (keyboardIsOpen) {
            self.scrollView.contentInset = .zero
            contentOffset.y -= keyboardSize.size.height
        } else {
            self.scrollView.contentInset.bottom = keyboardSize.size.height
            contentOffset.y += keyboardSize.size.height
        }
        keyboardIsOpen = !keyboardIsOpen
        self.scrollView.setContentOffset(contentOffset, animated: false)
    }
    
    // borrowed from exercise 11 about CoreLocation
    func showError(_ error: Error) {
        print(error.localizedDescription)
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setButtonAndTextFieldLayout() {
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        descriptionText.layer.cornerRadius = 10
        descriptionText.clipsToBounds = true
        titleText.layer.cornerRadius = 10
        titleText.clipsToBounds = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        setInsetAndScroll(notification: notification, keyboardShown: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        setInsetAndScroll(notification: notification, keyboardShown: false)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension PointOfInterestViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            location = locations.first
            self.geoCoder.reverseGeocodeLocation(manager.location!, completionHandler: { placemarks, error in
                if let p = placemarks?.first {
                    print(p.locality!)
                    print(p.administrativeArea!)
                    print(p.country!)
                } else if let e = error {
                    self.showError(e)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showError(error)
    }
}
