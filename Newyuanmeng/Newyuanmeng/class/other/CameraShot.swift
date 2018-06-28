//
//  ALCameraShot.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2015/06/17.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import AVFoundation

public typealias ALCameraShotCompletion = (UIImage) -> Void

internal class CameraShot: NSObject {
    func takePhoto(_ stillImageOutput: AVCaptureStillImageOutput, videoOrientation: AVCaptureVideoOrientation, cropSize: CGSize, completion: @escaping ALCameraShotCompletion) {
        
        guard let videoConnection: AVCaptureConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) else {
            return
        }
        
        videoConnection.videoOrientation = videoOrientation
        
        stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { buffer, error in
            
            guard let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer), let image = UIImage(data: imageData) else {
                return
            }
            
            completion(image)
        })
    }
}
