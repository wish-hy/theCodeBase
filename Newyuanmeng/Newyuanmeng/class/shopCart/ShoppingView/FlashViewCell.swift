//
//  FlashViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/9.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class FlashViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titles: UILabel!
    @IBOutlet weak var scale: UILabel!
    @IBOutlet weak var sell: UILabel!
    @IBOutlet weak var prices: UILabel!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var oldPrices: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var people: UILabel!
    @IBOutlet weak var want: UILabel!
    
    @IBOutlet weak var wid: NSLayoutConstraint!
    
    @IBOutlet weak var inventory: UIImageView!  // 库存为0显示
    typealias viewClick = (NSInteger)->Void
    
    var imgChoose:viewClick?
    var buyChoose:viewClick?
    var wantChoose:viewClick?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buyView.layer.borderColor = CommonConfig.MainBlueColor.cgColor
        buyView.layer.borderWidth = 1
        buyView.layer.cornerRadius = 5
        buyView.clipsToBounds = true
        people.textColor = CommonConfig.MainBlueColor
        want.backgroundColor = CommonConfig.MainBlueColor
        want.layer.borderWidth = 1
        want.layer.cornerRadius = 5
        want.clipsToBounds = true
        lbl.layer.borderWidth = 1
        lbl.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        lbl.layer.cornerRadius = 1
        lbl.clipsToBounds = true
        sell.layer.borderColor = CommonConfig.MainFontGrayColor.cgColor
        sell.layer.borderWidth = 1
        let tapGesturer = UITapGestureRecognizer(target: self, action: #selector(self.imgClick))
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(tapGesturer)
        buyBtn.setTitle(IconFontIconName.icon_cart_panicbuy.rawValue, for: UIControlState())
        // Initialization code
    }
    
    func setInfo(_ info:JSON,type:Bool,gone:Bool){
        print("info---",info)
        titles.text = info["name"].stringValue
        if info["flash_type"] == "point" {
            prices.text = "¥" + info["price"].stringValue + "+" + info["cost_point"].stringValue + "积分"
        }else{
            prices.text = "¥" + info["price"].stringValue
        }
        oldPrices.text = "¥" + info["sell_price"].stringValue
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(info["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        let num = CGFloat(info["order_num"].floatValue/info["max_num"].floatValue)
        sell.text = String.init(format: "已售:%.2f%%", num*100)
        wid.constant = num*83
        self.contentView.layoutIfNeeded()
        people.text = info["wants_num"].stringValue + "人想要"
        if num == 1 {
            buyBtn.setTitleColor(CommonConfig.MainFontGrayColor, for: UIControlState())
            buyBtn.isEnabled = false
            scale.backgroundColor = CommonConfig.SliderBlackColor
            sell.textColor = CommonConfig.MainFontGrayColor
        }
        scale.isHidden = type
        sell.isHidden = type
        buyBtn.isHidden = type
        buyView.isHidden = !type
        inventory.isHidden = gone
        if gone == true {
            print("已卖完")
        }
    }
    
    func imgClick(){
        imgChoose?(self.tag)
    }
    
    
    
    
    @IBAction func buyClick(_ sender: UIButton) {
        buyChoose?(self.tag)
    }
    
    @IBAction func wantClick(_ sender: UIButton) {
        wantChoose?(self.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
