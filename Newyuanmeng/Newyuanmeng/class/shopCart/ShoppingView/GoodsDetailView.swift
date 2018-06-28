//
//  GoodsDetailView.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/5.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol GoodsDetailViewDelegate : NSObjectProtocol{
    
    @objc optional func  selectGoodsDetailButton(_ tag:NSInteger)
    @objc optional func  selectGoodsDetailImage(_ tag:NSInteger)
    @objc optional func  selectGoodsDetailAddress(_ tag:NSInteger)
    @objc optional func  selectGoodsDetailcolor(_ tag:NSInteger)
}
class GoodsDetailView: UIView ,CirCleViewDelegate{

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var contentlbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var jifenlbl: UILabel!
    @IBOutlet weak var colorlbl: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var selllbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var evaluationlbl: UILabel!
    @IBOutlet weak var goodevalbl: UILabel!
    @IBOutlet weak var star1: UILabel!
    @IBOutlet weak var star2: UILabel!
    @IBOutlet weak var star3: UILabel!
    @IBOutlet weak var star4: UILabel!
    @IBOutlet weak var star5: UILabel!
    @IBOutlet weak var commentlbl: UILabel!

    @IBOutlet weak var icons: UILabel!
    @IBOutlet weak var timeend: UILabel!

    @IBOutlet weak var timecount: TTTAttributedLabel!
    @IBOutlet weak var timeicon: UILabel!
    
    
    
    var delegate: GoodsDetailViewDelegate? // delegate
    var wid:CGFloat = 0.0
    var hei:CGFloat = 0.0
    var starArr:Array<UILabel> = []
    var timer: Timer!
    var nowtime:Int64 = 34000
    
    
    init(frame:CGRect,Info:JSON, delegate: GoodsDetailViewDelegate?) {
        
        super.init(frame: frame)
        self.delegate = delegate
        wid = frame.size.width
        hei = frame.size.height
        setInfo(Info)
    }
    
    func addDelegate(_ delegate: GoodsDetailViewDelegate?){
        self.delegate = delegate
        wid = self.frame.size.width
        hei = self.frame.size.height
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAddress(_:)), name: NSNotification.Name(rawValue: "refreshAddress"), object: nil)   //刷新通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.chooseSize(_:)), name: NSNotification.Name(rawValue: "chooseSize"), object: nil)   //刷新通知
    }
    
    func setInfo(_ Info:JSON,istime:Bool = false,isIntegral:Bool = false){
        var imageArray: [String] = []
        print("商品详情信息",Info)
        let circleView = CirCleView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth),resouceType: 2)
        circleView.delegate = self
        let count = Info["goods"]["imgs"].count
        for index in 0..<count {
            imageArray.append(CommonConfig.getImageUrl(Info["goods"]["imgs"][index].stringValue))
        }
        circleView.urlImageArray = imageArray
        self.addSubview(circleView)
        self.titlelbl.text = ""
//        print(Info)
        self.titlelbl.text = Info["goods"]["name"].stringValue
//        self.contentlbl.text = Info["goods"]["subtitle"].stringValue
//        self.pricelbl.text = "¥" + Info["goods"]["sell_price"].stringValue
        if isIntegral {// 积分商品走这里
            let arr = Info["skumap"][0]
            self.pricelbl.text = "积分购价 ¥"+arr["cash"].stringValue+"+"+arr["point"].stringValue+"积分"
            self.contentlbl.text = ""
            timecount.text = "原价 ¥"+Info["goods"]["sell_price"].stringValue
            timecount.isHidden = false
            self.jifenlbl.isHidden = true
        }else{
            
            
            if let number = Info["cost_point"].string {
                self.pricelbl.text = "¥" + Info["skumap"][0]["sell_price"].stringValue
                print("info%@",Info)
                print("积分商品价格",self.pricelbl.text)
            }else{
                 self.pricelbl.text = "¥" + Info["goods"]["sell_price"].stringValue
            }
            
            if let numbers = Info["goods"]["start_time"].string {
                print("抢购商品")
                self.jifenlbl.isHidden = true
            }
            else{
                self.jifenlbl.isHidden = false
                self.jifenlbl.text = "已销售" + Info["goods"]["sales_volume"].stringValue + "件"
            }
            
            self.contentlbl.text = Info["goods"]["subtitle"].stringValue
//            getTime()
            timecount.text = "限购\(Info["goods"]["quota_num"].intValue)件"
            timecount.isHidden = !istime
            
        }
        self.colorlbl.text = "请选择规格"
        self.addresslbl.text = Info["address"].stringValue
//        self.selllbl.text = "近期销量：512件"
        self.selllbl.isHidden = true
        self.editBtn.setTitle(IconFontIconName.icon_goods_edit.rawValue, for: .normal)
        self.evaluationlbl.text = "商品评价(\(Info["comment"]["total"].intValue))"
        self.goodevalbl.text = "\(Info["comment"]["a"]["percent"].intValue)%"
        self.starArr = [self.star1,self.star2,self.star3,self.star4,self.star5]
        setStar(Info["comment"]["last"]["point"].intValue)
        self.commentlbl.text = Info["comment"]["last"]["content"].stringValue
        timeend.isHidden = !istime
        timeicon.isHidden = !istime
        timeicon.text = IconFontIconName.icon_time_start.rawValue
        self.icons.text = IconFontIconName.icon_goods_showmore.rawValue
        if istime {
            let starTime = CommonConfig.stringToTimeStamp(Info["goods"]["start_time"].stringValue, dateFormat: "yyyy-MM-dd HH:mm:ss", isNeed: false)
            let now = CommonConfig.stringToTimeStamp(Info["goods"]["now"].stringValue, dateFormat: "yyyy-MM-dd HH:mm:ss", isNeed: false)
            let endtime = CommonConfig.stringToTimeStamp(Info["goods"]["end_time"].stringValue, dateFormat: "yyyy-MM-dd HH:mm:ss", isNeed: false)
            print("开始时间  现在时间   结束时间",starTime,now,endtime)
            if starTime > now
            {
                timeend.text = "活动未开始"
            }
            else
            {
                if endtime > now
                {
                    nowtime = endtime - now
                    print("剩余倒计时  \(endtime) + \(now)")
                    normalState()
                    getTime()
                }else if endtime <= now
                {
                    timeend.text = "活动已结束";
                }
            }
           
        }else{
            
        }
    }
    
    func getTime(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.heartbeat), userInfo: nil, repeats: false)
    }
    
    func heartbeat() {
        nowtime -= 1
        if self.nowtime <= 0{
            timeend.text = "已结束"
            self.normalState()
            return
        }
        exchangeTime()
    }
    
    func exchangeTime(){
        var a = nowtime/3600
        var b = nowtime - nowtime / 3600 * 3600
        
        
        var day = nowtime / 3600 / 24
        var h = nowtime / 3600 % 24
        var m = nowtime / 60 % 60
        var s = nowtime % 60
        
        var text = "\(day)天"
        
        if h < 10 {
            text = text + "0\(h)时"
        }else{
            text = text + "\(h)时"
        }
//        a = b/60
//        b = b - a * 60
        if m < 10 {
            text = text + "0\(m)分"
        }else{
            text = text + "\(m)分"
        }
//        a = b % 60
        if s < 10 {
            text = text + "0\(s)秒后结束"
        }else{
            text = text + "\(s)秒后结束"
        }
        timeend.text = text
        self.normalState()
        getTime()
    }
    
    func normalState() {
        if self.timer == nil {
            return
        }
        self.timer.invalidate()
        self.timer = nil
    }
    
    func clickCurrentImage(_ currentIndxe: Int) {
        if delegate?.responds(to: #selector(GoodsDetailViewDelegate.selectGoodsDetailImage(_:))) == true {
            print("selectCenterButton")
            delegate?.selectGoodsDetailImage!(currentIndxe)
        }
    }
    
    func setStar(_ numb:NSInteger){
        for i in 0..<5 {
            let star = self.starArr[i]
            if i < numb {
                star.text = IconFontIconName.icon_star_yes.rawValue
                star.textColor = CommonConfig.MainYellowColor
            }else{
                star.text = IconFontIconName.icon_star_no.rawValue
                star.textColor = CommonConfig.MainFontBlackColor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
    }
    
    @IBAction func editClick(_ sender: UIButton) {
        if delegate?.responds(to: #selector(GoodsDetailViewDelegate.selectGoodsDetailAddress(_:))) == true {
            delegate?.selectGoodsDetailAddress!(sender.tag)
        }
    }
    
    @IBAction func chooseClick(_ sender: UIButton) {
        if delegate?.responds(to: #selector(GoodsDetailViewDelegate.selectGoodsDetailcolor(_:))) == true {
            delegate?.selectGoodsDetailcolor!(sender.tag)
        }
    }
    
    @IBAction func toComment(_ sender: UIButton) {
        if delegate?.responds(to: #selector(GoodsDetailViewDelegate.selectGoodsDetailButton(_:))) == true {
            print("selectCenterButton")
            delegate?.selectGoodsDetailButton!(sender.tag)
        }
    }
    
    func refreshAddress(_ notification:Notification){
        let info = notification.object as! NSDictionary
        let address = info.value(forKey: "address") as! String
        self.addresslbl.text = address
    }
    
    func chooseSize(_ notification:Notification){
        let info = notification.object as! NSDictionary
        let address = info.value(forKey: "chooseSize") as! String
        self.colorlbl.text = address
    }

}
