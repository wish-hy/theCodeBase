//
//  VIPGoodsView.swift
//  huabi
//
//  Created by teammac3 on 2017/6/3.
//  Copyright © 2017年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class VIPGoodsView: UIView ,CirCleViewDelegate{
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var contentlbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var icons: UILabel!
    
    @IBOutlet weak var pheight: NSLayoutConstraint!

    var delegate: GoodsDetailViewDelegate? // delegate
    var wid:CGFloat = 0.0
    var hei:CGFloat = 0.0
    
    
    init(frame:CGRect,Info:JSON, delegate: GoodsDetailViewDelegate?) {
        
        super.init(frame: frame)
        self.delegate = delegate
        self.backgroundColor = UIColor.white
        wid = frame.size.width
        hei = frame.size.height
        setInfo(Info)
    }
    
    
    func addDelegate(_ delegate: GoodsDetailViewDelegate?){
        self.delegate = delegate
        wid = self.frame.size.width
        hei = self.frame.size.height
    }
    
    func setInfo(_ Info:JSON,istime:Bool = false){
        
        var w = screenHeight-50-200
        pheight.constant = w
        var imageArray: [String] = []
        let circleView = CirCleView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: w),resouceType: 2)
        circleView.delegate = self
//        print(screenWidth+60)
        let count = Info["goods"]["imgs"].count
        for index in 0..<count {
            imageArray.append(CommonConfig.getImageUrl(Info["goods"]["imgs"][index].stringValue))
        }
        circleView.urlImageArray = imageArray
        self.addSubview(circleView)
        self.titlelbl.text = ""
//        print(Info)
        self.titlelbl.text = Info["goods"]["name"].stringValue
        self.contentlbl.text = Info["goods"]["subtitle"].stringValue
        self.pricelbl.text = "¥" + Info["goods"]["sell_price"].stringValue

        self.icons.text = IconFontIconName.icon_goods_showmore.rawValue

    }
    
    func clickCurrentImage(_ currentIndxe: Int) {
        if delegate?.responds(to: #selector(GoodsDetailViewDelegate.selectGoodsDetailImage(_:))) == true {
            print("selectCenterButton")
            delegate?.selectGoodsDetailImage!(currentIndxe)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}

