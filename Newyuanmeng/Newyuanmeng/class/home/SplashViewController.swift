//
//  SplashViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/21.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashScroll: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //        splashScroll.backgroundColor = CommonConfig.MainRedColor
            splashScroll.backgroundColor = UIColor.red
            splashScroll.contentSize = CGSize(width: screenWidth*3, height: 0)
            splashScroll.isPagingEnabled = true
            splashScroll.bounces = false
            splashScroll.isUserInteractionEnabled = true
            splashScroll.showsVerticalScrollIndicator = false
            splashScroll.showsHorizontalScrollIndicator = false
            let img1 = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            img1.image = UIImage(named: "loding1")
            let img2 = UIImageView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
            img2.image = UIImage(named: "loding2")
            let img3 = UIImageView(frame: CGRect(x: screenWidth*2, y: 0, width: screenWidth, height: screenHeight))
            img3.image = UIImage(named: "loding3")
        
            let btn = UIButton.init(frame: CGRect(x: screenWidth*2+(screenWidth-200*newScale)/2, y: (screenHeight-80*newScale)/2+500*newScale, width: 200*newScale, height: 80*newScale))
            btn.setTitle("立即体验", for: UIControlState())
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.backgroundColor = CommonConfig.MainGreenColor
            btn.layer.cornerRadius = 5
            btn.clipsToBounds = true
            btn.addTarget(self, action: #selector(SplashViewController.btnShowMainPage(_:)), for: .touchUpInside)
            splashScroll.addSubview(img1)
            splashScroll.addSubview(img2)
            splashScroll.addSubview(img3)
            splashScroll.addSubview(btn)
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        splashScroll.backgroundColor = CommonConfig.MainRedColor
//        splashScroll.backgroundColor = UIColor.red
//        splashScroll.contentSize = CGSize(width: screenWidth*3, height: 0)
//        splashScroll.isPagingEnabled = true
//        splashScroll.bounces = false
//        splashScroll.isUserInteractionEnabled = true
//        splashScroll.showsVerticalScrollIndicator = false
//        splashScroll.showsHorizontalScrollIndicator = false
//        let img1 = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
//        img1.image = UIImage(named: "loding1")
//        let img2 = UIImageView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
//        img2.image = UIImage(named: "loding2")
//        let img3 = UIImageView(frame: CGRect(x: screenWidth*2, y: 0, width: screenWidth, height: screenHeight))
//        img3.image = UIImage(named: "loding3")
//        let btn = UIButton.init(frame: CGRect(x: screenWidth*2+(screenWidth-200*newScale)/2, y: (screenHeight-80*newScale)/2+500*newScale, width: 200*newScale, height: 80*newScale))
//        btn.setTitle("立即体验", for: UIControlState())
//        btn.setTitleColor(UIColor.white, for: UIControlState())
//        btn.backgroundColor = CommonConfig.MainGreenColor
//        btn.layer.cornerRadius = 5
//        btn.clipsToBounds = true
//        btn.addTarget(self, action: #selector(SplashViewController.btnShowMainPage(_:)), for: .touchUpInside)
//        splashScroll.addSubview(img1)
//        splashScroll.addSubview(img2)
//        splashScroll.addSubview(img3)
//        splashScroll.addSubview(btn)
//
//    }
    
    func btnShowMainPage(_ sender:UIButton){
        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
    }

}
