//
//  ImageHelper.swift
//  MiVideo
//
//  Created by 张晓飞 on 16/3/3.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

let kLimitSize: CGFloat = 1280

class ImageHelper: NSObject {
    
    static func scaleImage(_ inputImage: UIImage, isFrontCamera: Bool) -> UIImage {
        var width = inputImage.size.width
        var height = inputImage.size.height
        var outputImage = inputImage
        let maxValue = max(width, height)
        if isFrontCamera {
            outputImage = UIImage(cgImage: inputImage.cgImage!, scale: inputImage.scale, orientation: UIImageOrientation.leftMirrored)
        }
        if maxValue > kLimitSize {
            if  height >= width {
                height = kLimitSize
                width = inputImage.size.width / inputImage.size.height * kLimitSize
            } else {
                width = kLimitSize
                height = inputImage.size.height / inputImage.size.width * kLimitSize
            }
        }
        outputImage = scaleToSize(outputImage, size: CGSize(width: width, height: height))
        
        return outputImage
    }
    
    static func scaleToSize(_ inputImage: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        inputImage.draw(in: CGRect(x: 0,y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    static func clipImage(_ inputImage: UIImage, toRect: CGRect) -> UIImage {
        let cgImageRef = inputImage.cgImage
        let subImageRef = cgImageRef?.cropping(to: toRect)
        let smallBounds = CGRect(x: 0, y: 0, width: CGFloat((subImageRef?.width)!), height: CGFloat((subImageRef?.height)!))
        UIGraphicsBeginImageContext(smallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(subImageRef!, in: smallBounds)
        let smallImage = UIImage(cgImage: subImageRef!)
        UIGraphicsEndImageContext()
        return smallImage
    }
    
}

extension UIImage {
    
    static func createImageWithColor(_ color: UIColor, width: CGFloat = 1, height: CGFloat = 1) -> UIImage
    {
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
    
}
