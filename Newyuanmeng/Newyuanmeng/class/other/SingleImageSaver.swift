//
//  SingleImageSavingInteractor.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2016/02/16.
//  Copyright © 2016 zero. All rights reserved.
//

import UIKit
import Photos

public typealias SingleImageSaverSuccess = (_ asset: PHAsset) -> Void
public typealias SingleImageSaverFailure = (_ error: NSError) -> Void

open class SingleImageSaver {
    fileprivate let errorDomain = "com.zero.singleImageSaver"
    
    fileprivate var success: SingleImageSaverSuccess?
    fileprivate var failure: SingleImageSaverFailure?
    
    fileprivate var image: UIImage?
    
    open func onSuccess(_ success: @escaping SingleImageSaverSuccess) -> Self {
        self.success = success
        return self
    }
    
    open func onFailure(_ failure: @escaping SingleImageSaverFailure) -> Self {
        self.failure = failure
        return self
    }
    
    open func setImage(_ image: UIImage) -> Self {
        self.image = image
        return self
    }
    
    open func save() -> Self {
        
        guard let image = image else {
            let error = errorWithKey("error.cant-fetch-photo", domain: errorDomain)
            failure?(error)
            return self
        }
        
        var assetIdentifier: PHObjectPlaceholder?
        
        PHPhotoLibrary.shared()
            .performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                assetIdentifier = request.placeholderForCreatedAsset
            }) { finished, error in
                if let assetIdentifier = assetIdentifier, finished {
                    self.fetch(assetIdentifier)
                }
            }

        return self
    }
    
    fileprivate func fetch(_ assetIdentifier: PHObjectPlaceholder) {
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier.localIdentifier], options: nil)
        
        guard let asset = assets.firstObject as? PHAsset else {
            let error = errorWithKey("error.cant-fetch-photo", domain: errorDomain)
            DispatchQueue.main.async {
                self.failure?(error)
            }
            return
        }
        DispatchQueue.main.async {
            self.success?(asset)
        }
    }
}
