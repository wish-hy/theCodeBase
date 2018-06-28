//
//  ShoppingCartCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/1.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShoppingCartCell: UITableViewCell ,UITextFieldDelegate{

    @IBOutlet weak var borderlbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var counts: UITextField!
    @IBOutlet weak var reduce: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var bottomline: UILabel!
    @IBOutlet weak var topline: UILabel!
    
    @IBOutlet weak var countlbl: UILabel!
    
    @IBOutlet weak var borderH1: NSLayoutConstraint!
    
    @IBOutlet weak var borderTop2: NSLayoutConstraint!
    @IBOutlet weak var borderH2: NSLayoutConstraint!
    
    @IBOutlet weak var imgTop: NSLayoutConstraint!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    @IBOutlet weak var titleTop1: NSLayoutConstraint!
    @IBOutlet weak var titleTop2: NSLayoutConstraint!
    @IBOutlet weak var titleTop3: NSLayoutConstraint!
    @IBOutlet weak var countsH: NSLayoutConstraint!
    
    @IBOutlet weak var priceH: NSLayoutConstraint!
    
    @IBOutlet weak var reducelbl: UILabel!
    @IBOutlet weak var addlbl: UILabel!
    
    @IBOutlet weak var delBtnW: NSLayoutConstraint!

    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var addlblH: NSLayoutConstraint!
    
    @IBOutlet weak var left: NSLayoutConstraint!
    
    
    
    typealias viewClick = (String)->Void
    typealias imgClick = (NSInteger)->Void
    var delClick:viewClick?
    var addClick:viewClick?
    var reduceClick:viewClick?
    var selectClick:viewClick?
    var unSelectClick:viewClick?
    var imageClick:imgClick?
    
    var goodsinfo:JSON?
    
    func setInfo(_ info:JSON, tags:NSInteger){
        goodsinfo = info
        titlelbl.text = info["name"].stringValue
        pricelbl.text = info["sell_price"].stringValue
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(info["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        let tapGesturer = UITapGestureRecognizer(target: self, action: #selector(ShoppingCartCell.showProduct))
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(tapGesturer)
        countlbl.text = "1"
        self.tag = tags
        counts.delegate = self;
    }
    
    func showProduct(){
        imageClick?(self.tag)
    }
    
    @IBAction func selectClick(_ sender: UIButton) {
        setSelect()
    }
    
    func setSelect(){
        selectBtn.tag = -selectBtn.tag
        if selectBtn.tag < 0 {
            selectBtn.setTitle(IconFontIconName.icon_cart_seletallgoods.rawValue, for: UIControlState())
            let counts = (countlbl.text! as NSString).integerValue
            postnotice(counts, flag: false)
            selectClick?("\(self.tag)-"+countlbl.text!)
        }else{
            selectBtn.setTitle("", for: UIControlState())
            let counts = (countlbl.text! as NSString).integerValue
            postnotice(counts, flag: true)
            unSelectClick?("\(self.tag)-"+countlbl.text!)
        }

    }
    @IBAction func reduceClick(_ sender: UIButton) {
        if countlbl.text != "" {
            if CommonConfig.checkPrice(countlbl.text!) {
                if countlbl.text! == "1" {
//                    delClick?(self.tag)
                    return
                }else {
                    countlbl.text = "\(Int(countlbl.text!)! - 1)"
                    if selectBtn.tag < 0 {
                        postnotice(1, flag: true)
                    }
                    reduceClick?("\(self.tag)-"+countlbl.text!)
                }
            }else{
                return
            }
        }else{
            return
        }
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        if countlbl.text != "" {
            if CommonConfig.checkPrice(countlbl.text!) {
                countlbl.text = "\(Int(countlbl.text!)! + 1)"
                if selectBtn.tag < 0 {
                    postnotice(1, flag: false)
                }
                addClick?("\(self.tag)-"+countlbl.text!)
            }else{
                return
            }
        }else{
            return
        }
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        if selectBtn.tag < 0 {
            let counts = (countlbl.text! as NSString).integerValue
            postnotice(counts, flag: true)
        }
        delClick?("\(self.tag)-"+countlbl.text!)
    }
    
    func postnotice(_ counts:NSInteger,flag:Bool = false){
        let sellp = CGFloat(goodsinfo!["price"].floatValue)
        var price:CGFloat = CGFloat(counts)*sellp
        var num = counts
        if flag {
            price = -price
            num = -num
        }
        let notice = Notification.init(name: Notification.Name(rawValue: "deleteGoods"), object: ["price":price])
        NotificationCenter.default.post(notice)
        let notice2 = Notification.init(name: Notification.Name(rawValue: "GoodsNum"), object: ["num":num])
        NotificationCenter.default.post(notice2)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        counts.resignFirstResponder()
    }
    
    func noteSelect(_ notification:Notification){
        let info = notification.object as! NSDictionary
        let sel = info.value(forKey: "shopping") as! NSInteger
        if sel < 0 {
            if selectBtn.tag > 0 {
                setSelect()
            }
        }else{
            if selectBtn.tag < 0 {
                setSelect()
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        counts.text = ""
         NotificationCenter.default.addObserver(self, selector: #selector(self.noteSelect(_:)), name: NSNotification.Name(rawValue: "selectBtn"), object: nil)   //刷新通知
        borderlbl.layer.borderWidth = 1
        borderlbl.layer.borderColor = CommonConfig.MainFontBlackColor.cgColor
        counts.layer.borderWidth = 1
        counts.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        reducelbl.layer.borderWidth = 1
        reducelbl.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        addlbl.layer.borderWidth = 1
        addlbl.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        borderTop2.constant = 60*newScale
        borderH1.constant = 40*newScale
        borderH2.constant = 44*newScale
        imgTop.constant = 36*newScale
        imgH.constant = 100*newScale
        titleTop1.constant = 40*newScale
        titleTop2.constant = 126*newScale
        titleTop3.constant = 54*newScale
        delBtnW.constant = 62*newScale
        delBtn.titleLabel?.font = UIFont.systemFont(ofSize: 24*newScale)
        countsH.constant = 64*newScale
        addlblH.constant = 32*newScale
        titlelbl.font = UIFont.systemFont(ofSize: 24*newScale)
        pricelbl.font = UIFont.systemFont(ofSize: 22*newScale)
            priceH.constant = 22*newScale
            left.constant = 80*newScale
        selectBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 42*newScale)
        addlbl.font = UIFont.systemFont(ofSize: 24*newScale)
        reducelbl.font = UIFont.systemFont(ofSize: 24*newScale)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
