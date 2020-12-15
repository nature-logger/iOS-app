//
//  CameraViewController.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 11/11/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var captureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Snap new Point of Interest"
        
        var items = toolBar.items
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cameraButton = UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
        let plusButton = UIBarButtonItem.init(barButtonSystemItem: .compose, target: self, action: #selector(addPOIWithPhoto))
        
        items?.append(spacer)
        items?.append(cameraButton)
        items?.append(spacer)
        items?.append(plusButton)
        toolBar.setItems(items, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
                previewView.bringSubviewToFront(captureImageView)
            }
        }
        catch _ {
            print("Unable to initialize backcamera")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPOI" {
            let destinationVC = segue.destination as! PointOfInterestViewController
            destinationVC.image = captureImageView.image
        }
    }

    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
        else {
            return
        }
        let image = UIImage(data: imageData)
        captureImageView.contentMode = .scaleAspectFill
        captureImageView.image = image
    }
    
    @objc func takePhoto() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func addPOIWithPhoto() {
        performSegue(withIdentifier: "addPOI", sender: nil)
    }
}
