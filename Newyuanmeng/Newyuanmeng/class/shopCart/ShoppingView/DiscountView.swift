//
//  DiscountView.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/26.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

@objc protocol DiscountViewDelegate : NSObjectProtocol{
    
    @objc optional func  selectDiscountView(_ tag:NSInteger)
    @objc optional func  IntegralDetailView(_ tag:NSInteger)
}

class DiscountView: UIView {

    var delegate: DiscountViewDelegate? // delegate
    var titles:UILabel!
    var Price:UILabel!
    var oldPrice:UILabel!
    var refers:UILabel!
    var images:UIImageView!
    var emptyImage:UIImageView!
    var wid:CGFloat = 0.0
    var hei:CGFloat = 0.0
    var types = 0
    var isIntegral = false
    var ispointShop = false
    
    
    init(frame:CGRect,title: String, icon:String, price:String,oldprice:String, type:NSInteger,delegate: DiscountViewDelegate?,empty:Bool = false,isIntegral:Bool=false,ispointShop:Bool=false) {
        
        super.init(frame: frame)
        self.delegate = delegate
        self.backgroundColor = UIColor.white
        wid = frame.size.width
        hei = frame.size.height
        types = type
        self.isIntegral = isIntegral
        self.ispointShop = ispointShop
        setView(title, icon: icon,price: price,oldprice: oldprice,empty: empty,isIntegral:isIntegral,ispointShop:ispointShop)
    }
    
    fileprivate func setView(_ title: String, icon:String, price:String,oldprice:String ,empty:Bool = false,isIntegral:Bool = false,ispointShop:Bool=false){

        images = UIImageView.init(frame: CGRect(x: (wid - 180*newScale)/2, y: 20*newScale, width: 180*newScale, height: 180*newScale))
        emptyImage = UIImageView.init(frame: CGRect(x: (wid - 180*newScale)/2, y: 20*newScale, width: 180*newScale, height: 180*newScale))
        if types == 1 {
            images.frame = CGRect(x: 16*newScale, y: 16*newScale, width: 172*newScale, height: 172*newScale)
        }
        images.backgroundColor = UIColor.white
        images.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(icon))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        self.addSubview(images)
        titles = UILabel.init(frame: CGRect(x: (wid - 180*newScale)/2, y: 210*newScale, width: 180*newScale, height: 50*newScale))
        if types == 1 {
            titles.frame = CGRect(x: 16*newScale, y: 196*newScale, width: 172*newScale, height: 50*newScale)
        }
        titles.font = UIFont.systemFont(ofSize: 20*newScale)
        titles.textColor = CommonConfig.MainFontBlackColor
        titles.text = title
        titles.textAlignment = .left
        titles.numberOfLines = 2
        titles.backgroundColor = UIColor.clear
        self.addSubview(titles)
        var size = CommonConfig.getTextRectSize(price as NSString, font: UIFont.systemFont(ofSize: 20*newScale), size: CGSize(width: 50, height: 0))
        Price = UILabel.init(frame:CGRect(x: 24*newScale, y: hei - 30*newScale, width: wid - 44*newScale, height: 20*newScale))
        if types == 1 {
            Price.frame = CGRect(x: 24*newScale, y: 268*newScale, width: 135*newScale, height: 20*newScale)
        }
        Price.font = UIFont.systemFont(ofSize: 20*newScale)
        Price.attributedText = exchangeTextWithImage("¥" + price)
        Price.textColor = CommonConfig.MainRedColor
        Price.textAlignment = .left
        Price.backgroundColor = UIColor.clear
        self.addSubview(Price)
        size = CommonConfig.getTextRectSize(oldprice as NSString, font: UIFont.systemFont(ofSize: 16*newScale), size: CGSize(width: 50, height: 0))
        oldPrice = UILabel.init(frame:CGRect(x: 20*newScale, y: hei - 26*newScale, width: wid - 40*newScale, height: 16*newScale))

        oldPrice.font = UIFont.systemFont(ofSize: 16*newScale)
        oldPrice.text = "¥" + oldprice
        oldPrice.textColor = CommonConfig.MainFontGrayColor
        oldPrice.textAlignment = .right
        if types == 1 {
            oldPrice.frame = CGRect(x: (214-48)*newScale, y: 262*newScale, width: 32*newScale, height: 32*newScale)
            oldPrice.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            oldPrice.font = UIFont.init(name: "iconfont", size: 20)
            oldPrice.text = IconFontIconName.icon_cart_normal.rawValue
            oldPrice.textColor = CommonConfig.MainRedColor
        }
        oldPrice.backgroundColor = UIColor.clear
        self.addSubview(oldPrice)
        size = CommonConfig.getTextRectSize("参考价", font: UIFont.systemFont(ofSize: 18*newScale), size: CGSize(width: 50, height: 0))
        refers = UILabel.init(frame:CGRect(x: wid - 20*newScale - size.size.width - 1, y: hei - 34*newScale - size.size.height, width: size.size.width + 1, height: size.size.height+1))
        if types == 1 {
            refers.isHidden = true
        }
        refers.font = UIFont.systemFont(ofSize: 18*newScale)
        refers.text = "参考价"
        refers.textColor = CommonConfig.MainFontGrayColor
        refers.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        refers.layer.borderWidth = 1
        refers.backgroundColor = UIColor.clear
        refers.textAlignment = .right
        self.addSubview(refers)
//        self.refers.isHidden = true  // 界面更改  参考价label不显示
        if isIntegral { // 判断是否积分商品  积分商品隐藏原价和参考价
            self.oldPrice.isHidden = true
            self.refers.isHidden = true
        }
        if ispointShop {
            self.oldPrice.isHidden = true
            self.refers.isHidden = true
            
//            let priceDic = self.integralArr[i].price_set[0]
//            let priceStr = priceDic["cash"].stringValue+"+"+priceDic["point"].stringValue+"积分"
        }
        emptyImage.image = UIImage.init(named: "sellout")
//        emptyImage.isUserInteractionEnabled = true
        self.addSubview(emptyImage)
        emptyImage.isHidden = !empty
    }
    
    func setTitleIcon(_ title: String, icon:String, price:String,oldprice:String,empty:Bool = false){
        images.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(icon))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        titles.text = title
        Price.attributedText = exchangeTextWithImage("¥" + price)
        oldPrice.text = "¥" + oldprice
        emptyImage.isHidden = !empty
    }
    
    func exchangeTextWithImage(_ text:String) -> NSMutableAttributedString{
        let attText = NSMutableAttributedString.init(string:text)
        let range = (text as NSString).range(of: ".")
        if range.length > 0 {
            let range1 = NSMakeRange(0, range.location)
            let range2 = NSMakeRange(range.location + 1, (text as NSString).length - range.location - 1)
            attText.addAttribute(kCTFontAttributeName as String, value: UIFont.systemFont(ofSize: 20*newScale), range: range1)
            attText.addAttribute(kCTFontAttributeName as String, value: UIFont.systemFont(ofSize: 16*newScale), range: NSMakeRange(0, 1))
            attText.addAttribute(kCTFontAttributeName as String, value: UIFont.systemFont(ofSize: 16*newScale), range: range2)
        }
        return attText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !emptyImage.isHidden {
//            return
//        }
        self.backgroundColor = CommonConfig.MainGrayColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !emptyImage.isHidden {
//            return
//        }
        self.backgroundColor = UIColor.white
        //积分购详情跳转
        if self.isIntegral {
            
            print("点击积分购商品")
            if delegate?.responds(to: #selector(DiscountViewDelegate.IntegralDetailView(_:))) == true {
                print(self.tag)
                delegate?.IntegralDetailView!(self.tag)
            }
        }else {
        if delegate?.responds(to: #selector(DiscountViewDelegate.selectDiscountView(_:))) == true {
            print("selectCenterButton")
            delegate?.selectDiscountView!(self.tag)
        }
      }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !emptyImage.isHidden {
//            return
//        }
        self.backgroundColor = UIColor.white
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
