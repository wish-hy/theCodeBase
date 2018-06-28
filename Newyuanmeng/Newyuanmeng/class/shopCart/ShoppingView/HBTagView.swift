//
//  HBTagView.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/29.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol HBTagViewwDelegate : NSObjectProtocol{
    
    @objc optional func  selectHBTagView(_ tag:NSInteger)
    
}

class HBTagView: UIView {

    var delegate: HBTagViewwDelegate? // delegate
    var wid:CGFloat = 0.0
    var hei:CGFloat = 0.0
    var types = 0
    var lastX:CGFloat = 0
    var lastY:CGFloat = 8
    var maxY:CGFloat = 0
    var btnArr:Array<UIButton> = []
    
    init(frame:CGRect,tagInfo:Array<String>, type:NSInteger,delegate: HBTagViewwDelegate?) {
        
        super.init(frame: frame)
        self.delegate = delegate
        self.backgroundColor = UIColor.white
        wid = frame.size.width
        hei = frame.size.height
        types = type
        setTags(tagInfo)
    }
    
    func setTags(_ tagInfo:Array<String>){
        for i in 0..<tagInfo.count{
            let size = CommonConfig.getTextRectSize(tagInfo[i] as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: wid - lastX, height: 0))
            if size.height > maxY {
                maxY = size.height
            }
            if types == 0 || types == 2 || types == 3{
                if lastX + size.width > wid {
                    lastX = 0
                    lastY = lastY + maxY + 8 + 8
                    maxY = 0
                }
            }else if types == 1{
                if i%3 == 0 && i > 0{
                    lastX = 0
                    lastY = lastY + maxY + 38
                    maxY = 0
                }
            }
            
            let btn = UIButton.init(frame: CGRect(x: lastX, y: lastY, width: 12 + size.width, height: 8 + size.height))
            btn.backgroundColor = CommonConfig.MainGrayColor
            btn.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
            btn.setTitle(tagInfo[i], for: UIControlState())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.contentHorizontalAlignment = .center
            btn.tag = i
            btn.layer.cornerRadius = 5
            btn.clipsToBounds = true
            if types == 2 {
                if i < 2{
                    btn.backgroundColor = CommonConfig.MainRedColor
                }
            }
            if types == 1 {
                btn.frame = CGRect(x: lastX, y: lastY, width: (wid - 10)/3, height: size.height)
                btn.backgroundColor = UIColor.white
                btn.contentHorizontalAlignment = .left
                lastX = lastX + (wid - 10)/3
            }else if types == 0 || types == 2 || types == 3{
                lastX = lastX + size.width + 12 + 12
            }
            if i == tagInfo.count - 1{
                lastY = lastY + maxY
            }
            if types == 3 {
                btn.layer.cornerRadius = (8 + size.height)/2
                btn.layer.borderColor = CommonConfig.MainGrayColor.cgColor
                btn.layer.borderWidth = 1
                btn.clipsToBounds = true
            }
            btn.addTarget(self, action: #selector(HBTagView.tagClick(_:)), for: .touchUpInside)
            self.addSubview(btn)
            btnArr.append(btn)
        }
    }
    var lastTag = -1
    func tagClick(_ sender:UIButton){
        if sender.tag == lastTag {
            return
        }
        if lastTag >= 0 {
            let btn = btnArr[lastTag]
            if types == 1 {
                btn.backgroundColor = UIColor.white
            }else if types == 2{
                btn.backgroundColor = CommonConfig.MainRedColor
            }else if types == 0{
                btn.backgroundColor = CommonConfig.MainGrayColor
            }else if types == 3{
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
                sender.backgroundColor = CommonConfig.MainLightRedColor
                sender.setTitleColor(UIColor.white, for: UIControlState())
            }
        }else{
            if types == 3 {
                sender.backgroundColor = CommonConfig.MainLightRedColor
                sender.setTitleColor(UIColor.white, for: UIControlState())
            }
        }
        lastTag = sender.tag
        if delegate?.responds(to: #selector(HBTagViewwDelegate.selectHBTagView(_:))) == true {
            delegate?.selectHBTagView!(sender.tag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
