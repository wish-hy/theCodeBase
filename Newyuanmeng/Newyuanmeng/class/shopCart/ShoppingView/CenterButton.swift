//
//  CenterButton.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/26.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

@objc protocol CenterButtonDelegate : NSObjectProtocol{
    
    @objc optional func  selectCenterButton(_ tag:NSInteger)
    
}

class CenterButton: UIView {
    
    var delegate: CenterButtonDelegate? // delegate
    var img:UILabel!
    var image:UIImageView!
    var text:UILabel!
    var wid:CGFloat = 0.0
    var hei:CGFloat = 0.0
    var badge:UILabel!
    var types = 0
    var backColor = CommonConfig.MainYellowColor
    
    init(frame:CGRect,title: String, icon:String, type:NSInteger,delegate: CenterButtonDelegate?) {
        
        super.init(frame: frame)
        self.delegate = delegate
        self.backgroundColor = UIColor.clear
        wid = frame.size.width
        hei = frame.size.height
        types = type
        setView(title, icon: icon)
    }
    
    func setView(_ title: String, icon:String){
        
        if types == 0 {
            img = UILabel.init(frame: CGRect(x: (wid - 25)/2, y: 5, width: 25, height: 25))
            img.font = UIFont.init(name: "iconfont", size: 25)
            img.text = icon
            img.textColor = CommonConfig.MainFontBlackColor
            
//            image = UIImageView.init(frame: CGRect(x: (wid - 25)/2, y: 5, width: 25, height: 25))
//            image.image = UIImage(named:icon)
            
        }else if types == 1{
            img = UILabel.init(frame: CGRect(x: 0, y: 10, width: wid, height: 15))
            img.font = UIFont.systemFont(ofSize: 15)
            img.attributedText = exchangeTextWithImage(icon)
            img.textColor = CommonConfig.MainFontGrayColor
        }else if types == 2{
            img = UILabel.init(frame: CGRect(x: (wid - 45)/2, y: 10, width: 45, height: 45))
            img.font = UIFont.init(name: "iconfont", size: 30)
            img.text = icon
            img.textColor = UIColor.clear
            
            image = UIImageView.init(frame: CGRect(x: (wid - 45)/2, y: 10, width: 45, height: 45))
            image.image = UIImage(named:icon)
            
            self.addSubview(image)
            
        }else if types == 3 {
            img = UILabel.init(frame: CGRect(x: (wid - 70*newScale)/2, y: 10*newScale, width: 70*newScale, height: 70*newScale))
            img.font = UIFont.init(name: "iconfont", size: 66*newScale)
            img.text = icon
            img.textColor = UIColor.white
        }else if types == 4{
            img = UILabel.init(frame: CGRect(x: 0, y: (hei - 34)/2, width: wid, height: 14))
            img.font = UIFont.systemFont(ofSize: 14)
            img.text = icon
            img.textColor = UIColor.white
        }
        img.textAlignment = .center
        img.backgroundColor = UIColor.clear
        self.addSubview(img)
        
        text = UILabel.init(frame: CGRect(x: 0, y: 35, width: wid, height: 15))
        if types == 0 {
            text.font = UIFont.systemFont(ofSize: 12)
            text.textColor = CommonConfig.MainFontBlackColor
        }else if types == 1{
            text.frame = CGRect(x: 0, y: 30, width: wid, height: 13)
            text.font = UIFont.systemFont(ofSize: 13)
            text.textColor = CommonConfig.MainFontGrayColor
        }else if types == 2{
            text = UILabel.init(frame: CGRect(x: 0, y: 60, width: wid, height: 15))
            text.font = UIFont.systemFont(ofSize: 12)
//            text.textColor = CommonConfig.MainFontBlackColor
        }else if types == 3 {
            text = UILabel.init(frame: CGRect(x: 0, y: 90*newScale, width: wid, height: 20*newScale))
            text.font = UIFont.systemFont(ofSize: 20*newScale)
            text.textColor = UIColor.white
        }else if types == 4{
            text = UILabel.init(frame: CGRect(x: 0, y: (hei - 34)/2 + 24, width: wid, height: 10))
            text.font = UIFont.systemFont(ofSize: 10)
            text.textColor = UIColor.white
            self.backgroundColor = CommonConfig.MainRedColor
        }
        text.text = title
        text.textAlignment = .center
        text.backgroundColor = UIColor.clear
        self.addSubview(text)
        badge =  UILabel(frame: CGRect(x: wid*0.7, y: 5, width: 12, height: 12))
        badge.font = UIFont.systemFont(ofSize: 10)
        badge.backgroundColor = CommonConfig.MainRedColor
        badge.text = ""
        badge.textAlignment = .center
        badge.textColor = UIColor.white
        badge.layer.cornerRadius = 6
        badge.clipsToBounds = true
        badge.isHidden = true
        self.addSubview(badge)
    }
    
    func setbadge(_ text:String){
        let size = CommonConfig.getTextRectSize(text as NSString, font: UIFont.systemFont(ofSize: 10), size: CGSize(width: wid, height: 12))
        badge.text = text
        badge.frame = CGRect(x: wid * 0.7 - size.width/2 - 6 , y: 5, width: size.width + 12, height: 12)
        if text == "0" {
            badge.isHidden = true
        }else{
            badge.isHidden = false
        }
    }
    
    func setFontForIcon(_ font:UIFont){
        img.font = font
    }
    
    func setBackcolorForIcon(_ color:UIColor){
        img.backgroundColor = color
        img.layer.cornerRadius = 45/2
        img.clipsToBounds = true
//        backColor = color
    }
    
    func setTitleIcon(_ title: String, icon:String){
        text.text = title
        if types == 0 {
            img.text = icon
        }else if types == 1{
            img.attributedText = exchangeTextWithImage(icon)
        }else if types == 2{
            img.text = icon
            img.text = ""
            image.image = UIImage(named:icon)
        }else if types == 4{
            img.text = icon
        }
    }
    
    func exchangeTextWithImage(_ text:String) -> NSMutableAttributedString{
        var attText = NSMutableAttributedString.init(string:text)
        let range = (text as NSString).range(of: ".")
        if range.length > 0 {
            let range1 = NSMakeRange(0, range.location)
            let range2 = NSMakeRange(range.location + 1, (text as NSString).length - range.location - 1)
            attText.addAttribute(kCTFontAttributeName as String, value: UIFont.systemFont(ofSize: 15), range: range1)
            attText.addAttribute(kCTFontAttributeName as String, value: UIFont.systemFont(ofSize: 12), range: range2)
        }else{
            attText = exchangeTextWithImage(text + ".00")
        }
        return attText
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if types == 2 {
//            img.backgroundColor = CommonConfig.MainYellowColor
//            text.textColor = CommonConfig.MainYellowColor
        }else if types != 3{
            img.textColor = CommonConfig.MainYellowColor
            text.textColor = CommonConfig.MainYellowColor
        }else if types == 4{
            self.backgroundColor = CommonConfig.MainYellowColor
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if types == 0 {
            img.textColor = CommonConfig.MainFontBlackColor
            text.textColor = CommonConfig.MainFontBlackColor
        }else if types == 1 {
            img.textColor = CommonConfig.MainFontGrayColor
            text.textColor = CommonConfig.MainFontGrayColor
        }else if types == 2{
//            img.backgroundColor = backColor
//            text.textColor = CommonConfig.MainFontBlackColor
        }else if types == 4{
            self.backgroundColor = CommonConfig.MainRedColor
        }
        if delegate?.responds(to: #selector(CenterButtonDelegate.selectCenterButton(_:))) == true {
            print("selectCenterButton")
            delegate?.selectCenterButton!(self.tag)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if types == 0 {
            img.textColor = CommonConfig.MainFontBlackColor
            text.textColor = CommonConfig.MainFontBlackColor
        }else if types == 1 {
            img.textColor = CommonConfig.MainFontGrayColor
            text.textColor = CommonConfig.MainFontGrayColor
        }else if types == 2{
//            img.backgroundColor = backColor
//            text.textColor = CommonConfig.MainFontBlackColor
        }else if types == 4{
             self.backgroundColor = CommonConfig.MainRedColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
