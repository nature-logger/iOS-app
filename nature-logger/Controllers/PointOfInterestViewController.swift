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
    var keyboardIsOpen = false
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        descriptionText.layer.cornerRadius = 10
        descriptionText.clipsToBounds = true
        titleText.layer.cornerRadius = 10
        titleText.clipsToBounds = true
        
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
    }
    
    func setInsentAndScroll(notification: NSNotification, keyboardShown: Bool) {
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
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        setInsentAndScroll(notification: notification, keyboardShown: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        setInsentAndScroll(notification: notification, keyboardShown: false)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
