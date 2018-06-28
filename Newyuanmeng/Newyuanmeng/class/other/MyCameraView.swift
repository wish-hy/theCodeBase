//
//  CameraView.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2015/06/17.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import AVFoundation

open class MyCameraView: UIView {
    
    var session: AVCaptureSession!
    var input: AVCaptureDeviceInput!
    var device: AVCaptureDevice!
    var imageOutput: AVCaptureStillImageOutput!
    var preview: AVCaptureVideoPreviewLayer!
    
    let cameraQueue = DispatchQueue(label: "com.zero.ALCameraViewController.Queue", attributes: []);
    
    let focusView = CropOverlay(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    open var currentPosition = AVCaptureDevicePosition.back
    
    open func startSession() {
        cameraQueue.async {
            self.createSession()
            self.session?.startRunning()
        }
    }
    
    open func stopSession() {
        cameraQueue.async {
            self.session?.stopRunning()
            self.preview?.removeFromSuperlayer()
            
            self.session = nil
            self.input = nil
            self.imageOutput = nil
            self.preview = nil
            self.device = nil
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if let p = preview {
            p.frame = bounds
        }
    }
    
    open func configureFocus() {
        
        if let gestureRecognizers = gestureRecognizers {
            for gesture in gestureRecognizers {
                removeGestureRecognizer(gesture)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "focus:")
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        addSubview(focusView)
        
        focusView.isHidden = true
        
        let lines = focusView.horizontalLines + focusView.verticalLines + focusView.outerLines
        
        lines.forEach { line in
            line.alpha = 0
        }
        
    }
    
    internal func focus(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self)
        guard let device = device else { return }
        do { try device.lockForConfiguration() } catch {
            return
        }
        
        if device.isFocusModeSupported(.locked) {
            
            let focusPoint = CGPoint(x: point.x / frame.width, y: point.y / frame.height)
            
            device.focusPointOfInterest = focusPoint
            device.unlockForConfiguration()
            
            focusView.isHidden = false
            focusView.center = point
            focusView.alpha = 0
            focusView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

            bringSubview(toFront: focusView)
            
            UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: { () -> Void in
                    self.focusView.alpha = 1
                    self.focusView.transform = CGAffineTransform.identity
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.80, relativeDuration: 0.20, animations: { () -> Void in
                    self.focusView.alpha = 0
                    self.focusView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
                
                
            }, completion: { finished in
                if finished {
                    self.focusView.isHidden = true
                }
            })
        }
    }
    
    fileprivate func createSession() {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        DispatchQueue.main.async {
            self.createPreview()
        }
    }
    
    fileprivate func createPreview() {
        device = cameraWithPosition(currentPosition)
        if device.hasFlash {
            do {
                try device.lockForConfiguration()
                device.flashMode = .auto
                device.unlockForConfiguration()
            } catch _ {}
        }
        
        let outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error as NSError {
            input = nil
//            print("Error: \(error.localizedDescription)")
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        imageOutput = AVCaptureStillImageOutput()
        imageOutput.outputSettings = outputSettings
        
        session.addOutput(imageOutput)
        
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        preview.frame = bounds
        

        layer.addSublayer(preview)
    }
    
    fileprivate func cameraWithPosition(_ position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        var _device: AVCaptureDevice?
        for d in devices! {
            if (d as AnyObject).position == position {
                _device = d as? AVCaptureDevice
                break
            }
        }
        
        return _device
    }
    
    open func capturePhoto(_ completion: @escaping ALCameraShotCompletion) {
        cameraQueue.async {
            let orientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
            CameraShot().takePhoto(self.imageOutput, videoOrientation: orientation, cropSize: self.frame.size) { image in
                completion(image)
            }
        }
    }

    open func swapCameraInput() {
        if session != nil && input != nil {
            session.beginConfiguration()
            session.removeInput(input)
            
            if input.device.position == AVCaptureDevicePosition.back {
                currentPosition = AVCaptureDevicePosition.front
                device = cameraWithPosition(currentPosition)
            } else {
                currentPosition = AVCaptureDevicePosition.back
                device = cameraWithPosition(currentPosition)
            }
            
            let error: NSErrorPointer = nil
            do {
                input = try AVCaptureDeviceInput(device: device)
            } catch let error1 as NSError {
                error?.pointee = error1
                input = nil
            }
            
            session.addInput(input)
            session.commitConfiguration()
        }
    }
}
