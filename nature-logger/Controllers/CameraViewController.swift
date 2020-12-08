//
//  CameraViewController.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 11/11/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var session: AVCaptureSession?
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var captureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Snap new Point of Interest"
        
        var items = toolBar.items
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cameraButton = UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: nil)
        let plusButton = UIBarButtonItem.init(barButtonSystemItem: .compose, target: self, action: nil)
        
        items?.append(spacer)
        items?.append(cameraButton)
        items?.append(spacer)
        items?.append(plusButton)
        toolBar.setItems(items, animated: false)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if videoPreviewLayer != nil {
            videoPreviewLayer!.frame = previewView.bounds
        }
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
    }
    
    func setupLivePreview() {
        if let currentSession = session, var preview = videoPreviewLayer {
            preview = AVCaptureVideoPreviewLayer(session: currentSession)
            preview.videoGravity = .resizeAspect
            preview.connection?.videoOrientation = .portrait
            previewView.layer.addSublayer(preview)
            
            DispatchQueue.global(qos: .userInitiated).async {
                currentSession.startRunning()
                DispatchQueue.main.async {
                    preview.frame = self.previewView.bounds
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session = AVCaptureSession()
        if let currentSession = session, let backCamera = AVCaptureDevice.default(for: AVMediaType.video){
            currentSession.sessionPreset = AVCaptureSession.Preset.photo
            var input: AVCaptureDeviceInput?
            
            do { input = try AVCaptureDeviceInput(device: backCamera)}
            catch let error as NSError {
                // TODO: popup / segue to other view (create entry)
                print(error.localizedDescription)
            }
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if input != nil && stillImageOutput != nil && currentSession.canAddInput(input!) && currentSession.canAddOutput(stillImageOutput!) { //maybe refactor this.
                currentSession.addInput(input!)
                currentSession.addOutput(stillImageOutput!)
                setupLivePreview()
            }
        }
    }
}
