//
//  ALImagePickerViewController.swift
//  ALImagePickerViewController
//
//  Created by Alex Littlejohn on 2015/06/09.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import Photos

internal let ImageCellIdentifier = "ImageCell"

internal let defaultItemSpacing: CGFloat = 1

typealias PhotoLibraryViewSelectionComplete = (_ asset: PHAsset? , _ value : Bool) -> Void

internal class PhotoLibraryViewController: UIViewController {
    
    internal var onSelectionComplete: PhotoLibraryViewSelectionComplete?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CameraGlobals.shared.photoLibraryThumbnailSize
        layout.minimumInteritemSpacing = defaultItemSpacing
        layout.minimumLineSpacing = defaultItemSpacing
        layout.sectionInset = UIEdgeInsets.zero
        
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()
    
//    fileprivate var assets: PHFetchResult!
    fileprivate var assets: PHFetchResult<AnyObject>!
    
    internal override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = UIColor(white: 0.2, alpha: 1)
        view.addSubview(collectionView)

        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.backgroundColor = UIColor.clear
        
        ImageFetcher()
            .onFailure(onFailure)
            .onSuccess(onSuccess)
            .fetch()
    }
    
    //拍照
    func handleCamera() {
//         onSelectionComplete?(asset: nil , value: true)
        onSelectionComplete?(nil,true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }

    internal override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func dismissY() {
//        onSelectionComplete?(asset: nil, value: false)
        onSelectionComplete?(nil,false)
    }
    
//    fileprivate func onSuccess(_ photos: PHFetchResult) {
    fileprivate func onSuccess(_photos:PHFetchResult<AnyObject>){
        assets = _photos
        configureCollectionView()
    }
    
    fileprivate func onFailure(_ error: NSError) {
        let permissionsView = PermissionsView(frame: view.bounds)
        permissionsView.titleLabel.text = LocalizedString("permissions.library.title")
        permissionsView.descriptionLabel.text = LocalizedString("permissions.library.description")
        
        view.addSubview(permissionsView)
    }
    
    fileprivate func configureCollectionView() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> PHAsset {
        return assets[indexPath.row] as! PHAsset
    }
}

// MARK: - UICollectionViewDataSource -
extension PhotoLibraryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = itemAtIndexPath(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellIdentifier, for: indexPath) as! ImageCell
        
        cell.configureWithModel(model)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate -
extension PhotoLibraryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = itemAtIndexPath(indexPath)
        onSelectionComplete?(asset, false)
    }
}
