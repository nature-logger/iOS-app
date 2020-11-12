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
        
        let item = UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: nil)
        items?.append(item)
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
            
            if let currentInput = input, currentSession.canAddInput(input!) {
                currentSession.addInput(currentInput)
                stillImageOutput = AVCapturePhotoOutput()
                stillImageOutput?.setValue(AVVideoCodecType.jpeg, forKey: AVVideoCodecKey)
                
                if stillImageOutput != nil && currentSession.canAddOutput(stillImageOutput!){
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: currentSession)
                    videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewView.layer.addSublayer(videoPreviewLayer!)
                    currentSession.startRunning()
                }
                
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
