//
//  SearchButton.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/30.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
@objc protocol SearchButtonDelegate : NSObjectProtocol{
    
    @objc optional func  selectSearchButton(_ tag:NSInteger,clickType:NSInteger)
    
}

class SearchButton: UIView {

        
    var delegate: SearchButtonDelegate? // delegate
    var wid:CGFloat = 0.0
    var hei:CGFloat = 0.0
    var types = 0
    var clickType = 0
    var titlelbl:UILabel!
    var topImg:UIImageView!
    var botImg:UIImageView!
    
    init(frame:CGRect,titles:String, type:NSInteger,delegate: SearchButtonDelegate?) {
        
        super.init(frame: frame)
        self.delegate = delegate
        self.backgroundColor = UIColor.white
        wid = frame.size.width
        hei = frame.size.height
        types = type
        setTitle(titles)
    }
    
    func setTitle(_ titles:String){
        let size = CommonConfig.getTextRectSize(titles as NSString, font: UIFont.systemFont(ofSize: 24*newScale), size: CGSize(width: wid, height: 0))
        titlelbl = UILabel.init(frame: CGRect(x: (wid - size.width - 9)/2, y: (hei - size.height)/2, width: size.width, height: size.height))
        titlelbl.font = UIFont.systemFont(ofSize: 24*newScale)
        titlelbl.text = titles
        titlelbl.textColor = CommonConfig.MainFontBlackColor
        self.addSubview(titlelbl)
        topImg = UIImageView.init(frame: CGRect(x: (wid - size.width - 9)/2 + size.width + 2, y: (hei - 10)/2, width: 7, height: 4))
        topImg.image = UIImage.init(named: setImageColor(2))
        self.addSubview(topImg)
        botImg = UIImageView.init(frame: CGRect(x: (wid - size.width - 9)/2 + size.width + 2, y: (hei - 10)/2 + 6, width: 7, height: 4))
        botImg.image = UIImage.init(named: setImageColor(0))
        self.addSubview(botImg)
    }
    
    func setDefultImageTitle(){
        titlelbl.textColor = CommonConfig.MainFontBlackColor
        if types == 1{
            topImg.isHidden = true
            botImg.isHidden = false
        }else if types == 0 || types == 3{
            topImg.isHidden = false
            botImg.isHidden = false
        }else if types == 2{
            topImg.isHidden = false
            botImg.isHidden = true
        }
        topImg.image = UIImage.init(named: setImageColor(2))
        botImg.image = UIImage.init(named: setImageColor(0))
        clickType = 0
    }
    
    func setImageColor(_ color:NSInteger) -> String{
        var imgName = "jiangxu"
        if color == 0 {
            imgName = "jiangxu"
        }else if color == 1{
            imgName = "jiangxu2"
        }else if color == 2{
            imgName = "shengxu"
        }else if color == 3{
            imgName = "shengxu2"
        }
        return imgName
    }
    
    func setImageWithClick(){
        titlelbl.textColor = CommonConfig.MainRedColor
        if types == 0 {
            if !topImg.isHidden && !botImg.isHidden {
                topImg.isHidden = true
                botImg.isHidden = false
                botImg.image = UIImage.init(named: setImageColor(1))
                clickType = 1
            }else{
                topImg.isHidden = !topImg.isHidden
                botImg.isHidden = !botImg.isHidden
                if botImg.isHidden {
                    topImg.image = UIImage.init(named: setImageColor(3))
                    clickType = 2
                }else{
                    botImg.image = UIImage.init(named: setImageColor(1))
                    clickType = 1
                }
            }
        }else if types == 1 {
            topImg.isHidden = true
            botImg.isHidden = false
            botImg.image = UIImage.init(named: setImageColor(1))
            clickType = 1
        }else if types == 2 {
            topImg.isHidden = false
            botImg.isHidden = true
            topImg.image = UIImage.init(named: setImageColor(3))
            clickType = 2
        }else if types == 3 {
            topImg.image = UIImage.init(named: setImageColor(3))
            botImg.image = UIImage.init(named: setImageColor(1))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setImageWithClick()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate?.responds(to: #selector(SearchButtonDelegate.selectSearchButton(_:clickType:))) == true {
            print("SearchButtonDelegate")
            delegate?.selectSearchButton!(self.tag,clickType:clickType)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setDefultImageTitle()
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
