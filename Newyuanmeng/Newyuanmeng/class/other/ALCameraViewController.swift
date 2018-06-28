//
//  ALCameraViewController.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2015/06/17.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import Photos

public typealias ALCameraViewCompletion = (UIImage? , _ value : Bool) -> Void

public extension ALCameraViewController {
    public class func imagePickerViewController(_ croppingEnabled: Bool, showRightBtn: Bool = true, completion: @escaping ALCameraViewCompletion) -> UINavigationController {
        let imagePicker = PhotoLibraryViewController()
        let navigationController = UINavigationController(rootViewController: imagePicker)
        
        imagePicker.onSelectionComplete = { asset , value in
            if asset != nil {
                let confirmController = ConfirmViewController(asset: asset!, allowsCropping: croppingEnabled)
                confirmController.onComplete = { image , value in
                    if let i = image {
                        completion(i ,false)
                    } else {
                        imagePicker.dismiss(animated: true, completion: nil)
                    }
                }
                confirmController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                imagePicker.present(confirmController, animated: true, completion: nil)
            } else {
                completion(nil,value)
            }
        }
        let backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backBtn.contentHorizontalAlignment = .left
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(2, -10, 0, 0)
        backBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 25)
        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
        backBtn.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
        backBtn.addTarget(imagePicker, action: #selector(PhotoLibraryViewController.dismissY), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: backBtn)
        imagePicker.navigationItem.leftBarButtonItem = item
//        imagePicker.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: UIBarButtonItemStyle.Plain, target: imagePicker, action: #selector(PhotoLibraryViewController.dismiss))
        if showRightBtn {
            imagePicker.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "拍照", style: .plain, target: imagePicker, action: #selector(PhotoLibraryViewController.handleCamera))
            imagePicker.navigationItem.rightBarButtonItem?.tintColor = CommonConfig.MainFontBlackColor
            
        }
        
        imagePicker.title = "相册"
        return navigationController
    }
}

func dismissClick(){
    
}

open class ALCameraViewController: UIViewController {
    
    let cameraView = MyCameraView()
    let cameraOverlay = CropOverlay()
    let cameraButton = UIButton()
    
    let closeButton = UIButton()
    let swapButton = UIButton()
    let libraryButton = UIButton()
    let flashButton = UIButton()
    
    var onCompletion: ALCameraViewCompletion?
    var allowCropping = false
    
    var verticalPadding: CGFloat = 30
    var horizontalPadding: CGFloat = 30
    
    lazy var volumeView: MPVolumeView = { [unowned self] in
        let view = MPVolumeView()
        view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        view.alpha = 0.01
        return view
    }()
    
    let volume = AVAudioSession.sharedInstance().outputVolume
    
    public init(croppingEnabled: Bool, allowsLibraryAccess: Bool = true, completion: @escaping ALCameraViewCompletion) {
        super.init(nibName: nil, bundle: nil)
        onCompletion = completion
        allowCropping = croppingEnabled
        libraryButton.isEnabled = allowsLibraryAccess
        libraryButton.isHidden = !allowsLibraryAccess
        commonInit()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        try! AVAudioSession.sharedInstance().setActive(false)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    open override var prefersStatusBarHidden : Bool {
        return true
    }
    
    open override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(volumeView)
        view.sendSubview(toBack: volumeView)
        view.addSubview(cameraView)
        
        try! AVAudioSession.sharedInstance().setActive(true)
        
        cameraView.frame = view.bounds
        
        rotate()
        NotificationCenter.default.addObserver(self, selector: #selector(ALCameraViewController.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ALCameraViewController.volumeChanged), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPermissions()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cameraView.frame = view.bounds
        layoutCamera()
    }
    
    internal func rotate() {
        let rotation = currentRotation()
        let rads = CGFloat(radians(rotation))
        
        UIView.animate(withDuration: 0.3, animations: {
            self.cameraButton.transform = CGAffineTransform(rotationAngle: rads)
            self.closeButton.transform = CGAffineTransform(rotationAngle: rads)
            self.swapButton.transform = CGAffineTransform(rotationAngle: rads)
            self.libraryButton.transform = CGAffineTransform(rotationAngle: rads)
        }) 
    }
    
    func volumeChanged() {
        guard let slider = volumeView.subviews.filter({ $0 is UISlider }).first as? UISlider else { return }
        slider.setValue(volume, animated: false)
        capturePhoto()
    }
    
    fileprivate func commonInit() {
        if UIScreen.main.bounds.size.width <= 320 {
            verticalPadding = 15
            horizontalPadding = 15
        }
    }

    fileprivate func checkPermissions() {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
            startCamera()
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                DispatchQueue.main.async {
                    if granted == true {
                        self.startCamera()
                    } else {
                        self.showNoPermissionsView()
                    }
                }
            }
        }
    }
    
    fileprivate func showNoPermissionsView() {
        let permissionsView = PermissionsView(frame: view.bounds)
        view.addSubview(permissionsView)
        view.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(ALCameraViewController.close), for: UIControlEvents.touchUpInside)
        closeButton.setImage(UIImage(named: "ic_back"), for: UIControlState())
        closeButton.sizeToFit()
        
        let size = view.frame.size
        let closeSize = closeButton.frame.size
        let closeX = horizontalPadding
        let closeY = size.height - (closeSize.height + verticalPadding)
        
        closeButton.frame.origin = CGPoint(x: closeX, y: closeY)
    }
    
    fileprivate func startCamera() {
        cameraView.startSession()
        
        view.addSubview(cameraButton)
        view.addSubview(libraryButton)
        view.addSubview(closeButton)
        view.addSubview(swapButton)
        view.addSubview(flashButton)
        
        cameraButton.addTarget(self, action: #selector(ALCameraViewController.capturePhoto), for: .touchUpInside)
        swapButton.addTarget(self, action: #selector(ALCameraViewController.swapCamera), for: .touchUpInside)
        libraryButton.addTarget(self, action: #selector(ALCameraViewController.showLibrary), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(ALCameraViewController.close), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(ALCameraViewController.toggleFlash), for: .touchUpInside)
        layoutCamera()
    }
    
    fileprivate func layoutCamera() {
        
        if #available(iOS 8.0, *) {
            cameraButton.setImage(UIImage(named: "cameraButton", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: UIControlState())
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 8.0, *) {
            cameraButton.setImage(UIImage(named: "cameraButtonHighlighted", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: .highlighted)
        } else {
            // Fallback on earlier versions
        }

        if #available(iOS 8.0, *) {
            closeButton.setImage(UIImage(named: "closeButton", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: UIControlState())
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 8.0, *) {
            swapButton.setImage(UIImage(named: "swapButton", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: UIControlState())
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 8.0, *) {
            libraryButton.setImage(UIImage(named: "libraryButton", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: UIControlState())
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 8.0, *) {
            flashButton.setImage(UIImage(named: "flashAutoIcon", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: UIControlState())
        } else {
            // Fallback on earlier versions
        }
        
        cameraButton.sizeToFit()
        closeButton.sizeToFit()
        swapButton.sizeToFit()
        libraryButton.sizeToFit()
        flashButton.sizeToFit()
        
        if allowCropping {
            layoutCropView()
        } else {
            cameraView.configureFocus()
        }
        
        cameraButton.isEnabled = true

        let size = view.frame.size
        
        let cameraSize = cameraButton.frame.size
        let cameraX = size.width/2 - cameraSize.width/2
        let cameraY = size.height - (cameraSize.height + verticalPadding)
        
        cameraButton.frame.origin = CGPoint(x: cameraX, y: cameraY)
        cameraButton.alpha = 1
        
        let closeSize = closeButton.frame.size
        let closeX = horizontalPadding
        let closeY = cameraY + (cameraSize.height - closeSize.height)/2
        
        closeButton.frame.origin = CGPoint(x: closeX, y: closeY)
        closeButton.alpha = 1
        
        let librarySize = libraryButton.frame.size
        let libraryX = size.width - (librarySize.width + horizontalPadding)
        let libraryY = closeY
        
        libraryButton.frame.origin = CGPoint(x: libraryX, y: libraryY)
        libraryButton.alpha = 1
        
        let swapSize = swapButton.frame.size
        let swapSpace = libraryX - (cameraX + cameraSize.width)
        var swapX = (cameraX + cameraSize.width) + (swapSpace/2 - swapSize.width/2)
        let swapY = closeY
        
        if libraryButton.isHidden {
            swapX = libraryX
        }
        
        swapButton.frame.origin = CGPoint(x: swapX, y: swapY)
        swapButton.alpha = 1
        
        let flashX = libraryX
        let flashY = verticalPadding
        
        flashButton.frame.origin = CGPoint(x: flashX, y: flashY)
    }
    
    fileprivate func layoutCropView() {
        
        let size = view.frame.size
        let minDimension = size.width < size.height ? size.width : size.height
        let maxDimension = size.width > size.height ? size.width : size.height
        let width = minDimension - horizontalPadding
        let height = width
        let x = horizontalPadding/2
        
        let cameraButtonY = maxDimension - (verticalPadding + 80)
        let y = cameraButtonY/2 - height/2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        view.addSubview(cameraOverlay)
        cameraOverlay.frame = frame
    }
    
    internal func capturePhoto() {
        
        guard let output = cameraView.imageOutput, let connection = output.connection(withMediaType: AVMediaTypeVideo) else {
            return
        }
        
        if connection.isEnabled {
            cameraButton.isEnabled = false
            cameraView.capturePhoto { image in
                self.saveImage(image)
            }
        }
    }
    
    internal func saveImage(_ image: UIImage) {
        
        SingleImageSaver()
            .setImage(image)
            .onSuccess { asset in
                if #available(iOS 8.0, *) {
                    self.layoutCameraResult(asset)
                } else {
                    // Fallback on earlier versions
                }
            }
            .onFailure { error in
//                print(error)
            }
            .save()
    }
    
    internal func close() {
        onCompletion?(nil , false)
    }
    
    internal func showLibrary() {
        let imagePicker = ALCameraViewController.imagePickerViewController(allowCropping) { image ,value in
            self.dismiss(animated: true, completion: nil)
            if image != nil {
                DispatchQueue.main.async {
                    self.onCompletion?(image!, false)
                }
            }
        }
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        present(imagePicker, animated: true) {
            self.cameraView.stopSession()
        }
    }
    
    internal func onConfirmComplete(_ image: UIImage?) {
        dismiss(animated: true, completion: nil)
        onCompletion?(image, false)
    }
    
    internal func toggleFlash() {
        if let device = cameraView.device, device.hasFlash {
            do {
                try device.lockForConfiguration()
                if device.flashMode == .on {
                    device.flashMode = .off
                    toggleFlashButton(.off)
                } else if device.flashMode == .off {
                    device.flashMode = .auto
                    toggleFlashButton(.auto)
                } else {
                    device.flashMode = .on
                    toggleFlashButton(.on)
                }
                device.unlockForConfiguration()
            } catch _ { }
        }
    }
    
    internal func toggleFlashButton(_ mode: AVCaptureFlashMode) {
        
        let image: String
        switch mode {
        case .auto:
            image = "flashAutoIcon"
        case .on:
            image = "flashOnIcon"
        case .off:
            image = "flashOffIcon"
        }
        
        if #available(iOS 8.0, *) {
            flashButton.setImage(UIImage(named: image, in: Bundle(for: ALCameraViewController.self), compatibleWith: nil), for: UIControlState())
        } else {
            // Fallback on earlier versions
        }
    }
    
    internal func swapCamera() {
        cameraView.swapCameraInput()
        flashButton.isHidden = cameraView.currentPosition == AVCaptureDevicePosition.front
    }
    
    @available(iOS 8.0, *)
    internal func layoutCameraResult(_ asset: PHAsset) {
        cameraView.stopSession()
        
        let confirmViewController = ConfirmViewController(asset: asset, allowsCropping: allowCropping)
        
        confirmViewController.onComplete = { image , value in
            if image == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.onCompletion?(image, false)
            }
        }
        confirmViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        present(confirmViewController, animated: true, completion: nil)
    }
}
