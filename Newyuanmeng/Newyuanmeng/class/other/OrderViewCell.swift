//
//  OrderViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/10.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderViewCell: UITableViewCell {

    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var goodscount: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var imgScroll: UIScrollView!
    
    @IBOutlet weak var sumprice: UILabel!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    var status = ""
    
    typealias viewClick = (NSInteger)->Void
    
    var imgClick:viewClick?
    var confirmClick:viewClick?
    var cancelClick:viewClick?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgH.constant = 140*newScale
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 2
        cancelBtn.clipsToBounds = true
        confirmBtn.layer.borderWidth = 1
        confirmBtn.layer.cornerRadius = 2
        confirmBtn.clipsToBounds = true
        btnColorChange(true)
        // Initialization code
    }

    func imgProductClick(_ sender:UIButton){
        imgClick?(self.tag)
    }
    
    func setInfo(_ info:JSON){
        status = info["status"].stringValue
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(info["imglist"][0]["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        titlelbl.text = info["imglist"][0]["name"].stringValue
        if info["imglist"].count > 1 {
            imgScroll.isHidden = false
            var wids:CGFloat = 10
            for j in 0..<info["imglist"].count{
                let imgview = UIButton.init(type: .custom)
                imgview.frame = CGRect(x:wids,y: 10,width: 140*newScale,height: 140*newScale)
                imgview.hnk_setImageFromURL(URL:URL(string: CommonConfig.getImageUrl(info["imglist"][j]["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
                imgview.tag = j
                imgview.addTarget(self, action: "imgProductClick:", for: .touchUpInside)
                imgScroll.addSubview(imgview)
                wids += 140*newScale + 10
            }
            imgScroll.bounces = false
            imgScroll.isPagingEnabled = false
            imgScroll.contentSize = CGSize(width: wids, height: 0)
            
        }else{
            imgScroll.isHidden = true
        }
        var num = 0
        for i in 0..<info["imglist"].count{
            num += info["imglist"][i]["goods_nums"].intValue

        }
        goodscount.text = "共\(num)件商品"
        pricelbl.text = "¥ " + info["order_amount"].stringValue
        cancelBtn.isHidden = false
        if info["status"].stringValue == "3" && info["pay_status"].stringValue == "1" && info["delivery_status"].stringValue == "1"{
            pricelbl.textColor = CommonConfig.MainFontBlackColor
            pricelbl.font = UIFont.systemFont(ofSize: 15)
            cancelBtn.setTitle("查看物流", for: UIControlState())
            confirmBtn.setTitle("确认收货", for: UIControlState())
            sumprice.text = "实付款: "
        }else if info["status"].stringValue == "2" && info["pay_status"].stringValue == "0" && info["delivery_status"].stringValue == "0" {
            pricelbl.textColor = CommonConfig.MainRedColor
            pricelbl.font = UIFont.systemFont(ofSize: 12)
            cancelBtn.setTitle("取消订单", for: UIControlState())
//            confirmBtn.setTitle("确认付款", for: UIControlState())
            confirmBtn.setTitle("确认付款", for: UIControlState())
            sumprice.text = "总和: "
        }else if info["status"].stringValue == "3" && info["pay_status"].stringValue == "1" && info["delivery_status"].stringValue == "1" {
            pricelbl.textColor = CommonConfig.MainRedColor
            pricelbl.font = UIFont.systemFont(ofSize: 12)
            cancelBtn.isHidden = true
            confirmBtn.setTitle("提醒发货", for: UIControlState())
            sumprice.text = "总和: "
        }else if info["status"].stringValue == "5" {
            pricelbl.textColor = CommonConfig.MainRedColor
            pricelbl.font = UIFont.systemFont(ofSize: 12)
            cancelBtn.setTitle("售后服务", for: UIControlState())
            confirmBtn.setTitle("再次购买", for: UIControlState())
            sumprice.text = "总和: "
        }else if info["status"].stringValue == "6" {
            pricelbl.textColor = CommonConfig.MainRedColor
            pricelbl.font = UIFont.systemFont(ofSize: 12)
            cancelBtn.isHidden = true
            confirmBtn.setTitle("查看商品", for: UIControlState())
            sumprice.text = "总和: "
        }
        
    }
    
    func btnColorChange(_ type:Bool = false){
        if type {
            cancelBtn.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
            cancelBtn.layer.borderColor = CommonConfig.MainFontBlackColor.cgColor
            confirmBtn.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
            confirmBtn.layer.borderColor = CommonConfig.MainRedColor.cgColor
        }else{
            cancelBtn.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
            cancelBtn.layer.borderColor = CommonConfig.MainRedColor.cgColor
            confirmBtn.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
            confirmBtn.layer.borderColor = CommonConfig.MainFontBlackColor.cgColor
        }
    }
    
    @IBAction func goodsClick(_ sender: UIButton) {
      imgClick?(self.tag)
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        btnColorChange(false)
        cancelClick?(self.tag)
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        btnColorChange(true)
        confirmClick?(self.tag)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
