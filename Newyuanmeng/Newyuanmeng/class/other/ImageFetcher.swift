//
//  ALImageFetchingInteractor.swift
//  ALImagePickerViewController
//
//  Created by Alex Littlejohn on 2015/06/09.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import Photos

@available(iOS 8.0, *)
public typealias ImageFetcherSuccess = (_ assets: PHFetchResult<AnyObject>) -> ()
public typealias ImageFetcherFailure = (_ error: NSError) -> ()

@available(iOS 8.0, *)
//extension PHFetchResult: Sequence {
//    public func makeIterator() -> NSFastEnumerationIterator {
//        return NSFastEnumerationIterator(self)
//    }
//}
struct ResultSequence<Element: AnyObject>: Sequence {
    var result: PHFetchResult<Element>
    init(_ result: PHFetchResult<Element>) {
        self.result = result
    }
    func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self.result)
    }
}

@available(iOS 8.0, *)
open class ImageFetcher {

    fileprivate var success: ImageFetcherSuccess?
    fileprivate var failure: ImageFetcherFailure?
    
    fileprivate var authRequested = false
    fileprivate let errorDomain = "com.zero.imageFetcher"
    
    let libraryQueue = DispatchQueue(label: "com.zero.ALCameraViewController.LibraryQueue", attributes: []);
    
    open func onSuccess(_ success: @escaping ImageFetcherSuccess) -> Self {
        self.success = success
        return self
    }
    
    open func onFailure(_ failure:  @escaping ImageFetcherFailure) -> Self {
        self.failure = failure
        return self
    }
    
    open func fetch() -> Self {
        handleAuthorization(PHPhotoLibrary.authorizationStatus())
        return self
    }
    
    fileprivate func onAuthorized() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        libraryQueue.async {
            let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
            DispatchQueue.main.async {
                self.success?(assets as! PHFetchResult<AnyObject>)
            }
        }
    }
    
    fileprivate func onDeniedOrRestricted() {
        let error = errorWithKey("error.access-denied", domain: errorDomain)
        DispatchQueue.main.async {
            self.failure?(error)
        }
    }
    
    fileprivate func handleAuthorization(_ status: PHAuthorizationStatus) -> Void {
        switch status {
        case .notDetermined:
            if !authRequested {
                PHPhotoLibrary.requestAuthorization(handleAuthorization)
                authRequested = true
            } else {
                onDeniedOrRestricted()
            }
            break
        case .authorized:
            onAuthorized()
            break
        case .denied, .restricted:
            onDeniedOrRestricted()
            break
        }
    }
}
