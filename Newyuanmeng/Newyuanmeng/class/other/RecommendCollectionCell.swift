//
//  RecommendCollectionCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/27.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class RecommendCollectionCell: UICollectionViewCell {

    var showImg: UIImageView!
    var titlelbl: UILabel!
    var pricelbl: UILabel!
    var buylbl: UILabel!
    var isSet:Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //self.imageView.
        //fatalError("init(coder:) has not been implemented")
    }
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    func setInfo(_ info:GoodsModel)
    {
        if isSet {
            setImageWithText(info)
        }else{
            self.showImg = UIImageView(frame: CGRect(x: 10, y: 10, width: (screenWidth - 2)/3 - 20, height: (screenWidth - 2)/3 - 20))
            self.titlelbl = UILabel(frame:  CGRect(x: 10, y: 20 + (screenWidth - 2)/3 - 20, width: (screenWidth - 2)/3 - 20, height: 34))
            self.pricelbl = UILabel(frame:  CGRect(x: 10, y: (382 - 60)*newScale + 2, width: 180*newScale, height: 15))
            self.buylbl = UILabel(frame:  CGRect(x: 170*newScale, y: (382 - 60)*newScale, width: 45*newScale, height: 45*newScale))
            self.showImg.backgroundColor = UIColor.white
            self.titlelbl.numberOfLines = 0
            self.titlelbl.textAlignment = .left
            self.titlelbl.textColor = CommonConfig.MainFontBlackColor
            self.titlelbl.font = UIFont.systemFont(ofSize: 13)
            self.pricelbl.textAlignment = .left
            self.pricelbl.textColor = CommonConfig.MainRedColor
            self.pricelbl.font = UIFont.systemFont(ofSize: 12)
            self.buylbl.textAlignment = .right
            self.buylbl.textColor = CommonConfig.MainRedColor
            self.buylbl.font = UIFont.init(name: "iconfont", size: 20)
            self.contentView.addSubview(self.showImg)
            self.contentView.addSubview(self.titlelbl)
            self.contentView.addSubview(self.pricelbl)
            self.contentView.addSubview(self.buylbl)
            setImageWithText(info)
            isSet = true
        }

    }
    
    func setImageWithText(_ info:GoodsModel){
        showImg.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(info.img))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        titlelbl.text = info.name
        pricelbl.text = "¥" + info.market_price
        buylbl.text = IconFontIconName.icon_cart_panicbuy.rawValue
    }
}
