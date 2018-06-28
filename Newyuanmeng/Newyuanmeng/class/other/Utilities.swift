//
//  ALUtilities.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2015/06/25.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

internal func radians(_ degrees: Double) -> Double {
    return degrees / 180 * M_PI
}

internal func SpringAnimation(_ animations: @escaping () -> Void) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
        animations()
        }, completion: nil)
}

internal func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, tableName: CameraGlobals.shared.stringsTable, bundle: CameraGlobals.shared.bundle, comment: key)
}

internal func currentRotation() -> Double {
    var rotation: Double = 0
    
    if UIDevice.current.orientation == .landscapeLeft {
        rotation = 90
    } else if UIDevice.current.orientation == .landscapeRight {
        rotation = 270
    } else if UIDevice.current.orientation == .portraitUpsideDown {
        rotation = 180
    }
    
    return rotation
}

internal func largestPhotoSize() -> CGSize {
    let scale = UIScreen.main.scale
    let screenSize = UIScreen.main.bounds.size
    let size = CGSize(width: screenSize.width * scale, height: screenSize.height * scale)
    return size
}

internal func errorWithKey(_ key: String, domain: String) -> NSError {
    let errorString = LocalizedString(key)
    let errorInfo = [NSLocalizedDescriptionKey: errorString]
    let error = NSError(domain: domain, code: 0, userInfo: errorInfo)
    return error
}

internal func normalizedRect(_ rect: CGRect, orientation: UIImageOrientation) -> CGRect {
    let normalizedX = rect.origin.x
    let normalizedY = rect.origin.y
    
    let normalizedWidth = rect.width
    let normalizedHeight = rect.height
    
    var normalizedRect: CGRect
    
    switch orientation {
    case .up, .upMirrored:
        normalizedRect = CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight)
    case .down, .downMirrored:
        normalizedRect = CGRect(x: 1-normalizedX-normalizedWidth, y: 1-normalizedY-normalizedHeight, width: normalizedWidth, height: normalizedHeight)
    case .left, .leftMirrored:
        normalizedRect = CGRect(x: 1-normalizedY-normalizedHeight, y: normalizedX, width: normalizedHeight, height: normalizedWidth)
    case .right, .rightMirrored:
        normalizedRect = CGRect(x: normalizedY, y: 1-normalizedX-normalizedWidth, width: normalizedHeight, height: normalizedWidth)
    }
    
    return normalizedRect
    
}
