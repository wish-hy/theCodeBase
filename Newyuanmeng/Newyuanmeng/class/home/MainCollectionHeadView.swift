//
//  MainCollectionHeadView.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/27.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainCollectionHeadView: UICollectionReusableView ,CenterButtonDelegate,CirCleViewDelegate,DiscountViewDelegate{
    
    @IBOutlet weak var bannerImg: UIView!
    @IBOutlet weak var advertImg1: UIImageView!
    @IBOutlet weak var advertImg2: UIImageView!
    
    // 推荐品牌
    @IBOutlet weak var collectImg1: UIImageView!
    @IBOutlet weak var collectImg2: UIImageView!
    @IBOutlet weak var collectImg3: UIImageView!
    @IBOutlet weak var collectImg4: UIImageView!
    @IBOutlet weak var collectImg5: UIImageView!
    @IBOutlet weak var collectImg6: UIImageView!
    @IBOutlet weak var collectImg7: UIImageView!
    @IBOutlet weak var collectImg8: UIImageView!
    
    // 全部商品 。。。
    @IBOutlet weak var scrollview1: UIScrollView!
    
    //新品专区
    @IBOutlet weak var scrollview2: UIScrollView!
    
    @IBOutlet weak var scrollview3: UIScrollView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var jifenView: UIView!
    
//    @IBOutlet weak var hlbl: UILabel!
//    @IBOutlet weak var mlbl: UILabel!
//    @IBOutlet weak var slbl: UILabel!
//
//    @IBOutlet weak var textlbl: UILabel!
    
    
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var discountHeight: NSLayoutConstraint!
    @IBOutlet weak var advertHeight1: NSLayoutConstraint!
    @IBOutlet weak var advertHeight2: NSLayoutConstraint!
    @IBOutlet weak var collectHeight: NSLayoutConstraint!
    
    
    
    var timer: Timer!
    var nowtime:Int64 = 34000
    var btnArr:Array<CenterButton> = []
    var bannerList:JSON!
    var flashlist:Array<GoodsModel> = []
    var integralArr:Array<integralModel> = []
    var advertList:JSON!
    var recommendList:JSON!
    var isload:Bool = true
    
    
    typealias viewClick = (JSON)->Void
    typealias btnClick = (NSInteger)->Void
    typealias goodsClick = (String)->Void
    typealias discountClick = ()->Void
    typealias integralListClick = ()->Void
    typealias jumpIntegralDetailClick = (String)->Void
    
    var bannerClick:viewClick?
    var selectClick:btnClick?
    var DiscounClick:goodsClick?
    var disClick:discountClick?
    var inteClick:integralListClick?
    var jumpIClick:jumpIntegralDetailClick?
    
    override func awakeFromNib() {
         super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshmain), name: NSNotification.Name(rawValue: "refreshmain"), object: nil)   //刷新通知
    }
    
    func refreshmain(){
        if !isload {
            flashlist = []
            integralArr = []
            if circleView != nil{
                circleView.removeFromSuperview()
            }
            getDiscountData()
            getAdvertData()
        }
    }
    
    func initSet(){
//        hlbl.layer.cornerRadius = 5
//        hlbl.clipsToBounds = true
//        mlbl.layer.cornerRadius = 5
//        mlbl.clipsToBounds = true
//        slbl.layer.cornerRadius = 5
//        slbl.clipsToBounds = true
//        textlbl.layer.cornerRadius = 5
//        textlbl.clipsToBounds = true
        let tapLabelGesture = UITapGestureRecognizer(target: self,action: #selector(self.integralClick))
//        integralLabel.layer.cornerRadius = 5
//        integralLabel.clipsToBounds = true
//        integralLabel.isUserInteractionEnabled = true
//        integralLabel.addGestureRecognizer(tapLabelGesture)
        jifenView.isUserInteractionEnabled = true
        jifenView.addGestureRecognizer(tapLabelGesture)
        
//        bannerHeight.constant = 300*newScale
        discountHeight.constant = 330*newScale
//        advertHeight1.constant = 124*newScale
//        advertHeight2.constant = 124*newScale
//        advertHeight1.constant = 0
//        advertHeight2.constant = 0
//        collectHeight.constant = 290*newScale
        let tapGesturer = UITapGestureRecognizer(target: self, action: #selector(self.disViewClick))
        timeView.isUserInteractionEnabled = true
        timeView.addGestureRecognizer(tapGesturer)
        self.layoutIfNeeded()
        if isload {
            getDiscountData()
            getAdvertData()
            setBtnWithScrollView()
            
            isload = false
        }
        
    }
    //积分购点击事件
    func integralClick(){
//        print("积分购跳转详情")
        inteClick?()
        
    }
    func disViewClick(){
        disClick?()
    }
    
    func setBtnWithScrollView(){
        self.scrollview1.contentSize = CGSize(width: screenWidth, height: 120)
//        self.scrollview1.backgroundColor = UIColor.white
        let imageView = UIImageView(image:UIImage(named:"fenleidi"))
        imageView.frame = CGRect(x:0, y:0, width:screenWidth, height:120)
//        imageView.frame = self.scrollview1.frame
        self.scrollview1.addSubview(imageView)
        self.scrollview1.isPagingEnabled = false
//        let colorArr:Array<UIColor> = [UIColor.init(hexCode: "763582"),UIColor.init(hexCode: "3d49e9"),UIColor.init(hexCode: "abcc24"),UIColor.init(hexCode: "f6901e"),UIColor.init(hexCode: "bb2d2e")]
////        let colorImg:Array = ["quanbu","miaosha","weishang","jifen","dianpu"]
//        let iconArr:Array<String> = [IconFontIconName.icon_health_life.rawValue,IconFontIconName.icon_import_food.rawValue,IconFontIconName.icon_home_life.rawValue,IconFontIconName.icon_sale_price.rawValue,IconFontIconName.icon_points_recharge.rawValue]
        let iconArr:Array<String> = ["weishang","zhubao","nvxing","yangsheng","dianpu"]
        
        let titleArr:Array<String> = ["微商专区","珠宝专区","旅游专区","养生保健","店铺专区"]
        for i in 0..<5 {
            let btn = CenterButton.init(frame: CGRect(x: CGFloat(i)*screenWidth/5, y: 30, width: screenWidth/5, height: 60), title: titleArr[i], icon: iconArr[i], type: 2, delegate: self)
            btn.tag = 10001 + i
//            btn.setBackcolorForIcon(colorArr[i])
            
            if i == 4 {
                btn.setFontForIcon(UIFont.init(name: "iconfont", size: 30)!)
            }else if i == 3{
                btn.setFontForIcon(UIFont.init(name: "iconfont", size: 30)!)
            }
            self.scrollview1.addSubview(btn)
            btnArr.append(btn)
        }
    }
    
    func selectCenterButton(_ tag: NSInteger) {
        selectClick!(tag)
    }
    var circleView: CirCleView!
    
    func setBanner(){
        var imageArray: [String] = []
        circleView = CirCleView(frame: self.bannerImg.frame,resouceType: 2)
        circleView.delegate = self
        let count = self.bannerList["content"].count
        for index in 0..<count {
            imageArray.append(CommonConfig.getImageUrl(self.bannerList["content"][index]["path"].stringValue))
        }
//        print("urlImageArray",imageArray)
        circleView.urlImageArray = imageArray
        self.bannerImg.addSubview(circleView)
    }
    
    func clickCurrentImage(_ currentIndxe: Int) {
        let bannerInfo = self.bannerList["content"][currentIndxe]
        bannerClick!(bannerInfo)

    }


    
    fileprivate func setDiscountInfo(_ end_time:String,now_time:String){
        let endtime = CommonConfig.stringToTimeStamp(end_time, dateFormat: "yyyy-MM-dd HH:mm:ss", isNeed: false)
        let now = CommonConfig.stringToTimeStamp(now_time, dateFormat: "yyyy-MM-dd HH:mm:ss", isNeed: false)
        nowtime = endtime - now
        self.nowtime = 12306
//        normalState()
//        getTime()
        self.scrollview2.contentSize = CGSize(width: 210 * newScale * CGFloat(self.flashlist.count), height: 0)
        self.scrollview2.isPagingEnabled = false
        let count = self.scrollview2.subviews.count
        if count != 0 {
            for _ in 0..<count {
                let views = self.scrollview2.subviews[0]
                views.removeFromSuperview()
            }
        }
        for i in 0..<self.flashlist.count {
            var empty = false
            if self.flashlist[i].is_end == "1" {
                empty = true
            }  //  抢购专区
            
            var pointShop = false
            var price = ""
            if self.flashlist[i].flash_type == "point"
            {
                pointShop = true
                price = self.flashlist[i].price + "+" + self.flashlist[i].cost_point + "积分"
            }else{
                pointShop = false
              price = self.flashlist[i].price
            }
//            let priceDic = self.integralArr[i].price_set[0]
//            let priceStr = priceDic["cash"].stringValue+"+"+priceDic["point"].stringValue+"积分"
            
            let discount = DiscountView.init(frame: CGRect(x: CGFloat(i) * 210 * newScale + CGFloat(i), y: 0, width: 210 * newScale, height: 330*newScale), title: self.flashlist[i].name, icon: self.flashlist[i].img, price: price, oldprice: self.flashlist[i].market_price, type: 0, delegate: self, empty: empty,ispointShop: pointShop)
            discount.tag = 1001 + i
            discount.delegate = self
            
            self.scrollview2.addSubview(discount)
            let lbl = UILabel.init(frame: CGRect(x: discount.frame.origin.x + discount.frame.size.width, y: 0, width: 1, height: 314*newScale))
            lbl.text = ""
            lbl.backgroundColor = CommonConfig.MainGrayColor
            if i < self.flashlist.count - 1 {
                self.scrollview2.addSubview(lbl)
            }
        }
        self.scrollview3.contentSize = CGSize(width:210 * newScale * CGFloat(self.integralArr.count),height:0)
        self.scrollview3.isPagingEnabled = false
        let integralCount = self.scrollview3.subviews.count
        if integralCount != 0 {
            for _ in 0..<integralCount {
                let views = self.scrollview3.subviews[0]
                views.removeFromSuperview()
            }
        }

        for i in 0..<self.integralArr.count {  // 积分专区
            let integralEmpty = false
            let priceDic = self.integralArr[i].price_set[0]
            let priceStr = priceDic["cash"].stringValue+"+"+priceDic["point"].stringValue+"积分"
            let discount = DiscountView.init(frame: CGRect(x:CGFloat(i) * 210 * newScale + CGFloat(i), y:0, width:210 * newScale, height:330*newScale), title: self.integralArr[i].name, icon: self.integralArr[i].img, price: priceStr, oldprice: "", type: 0, delegate: self, empty: integralEmpty,isIntegral: true)
            
            discount.tag = 2000 + i
            self.scrollview3.addSubview(discount)
            let lbl = UILabel.init(frame: CGRect(x:discount.frame.origin.x + discount.frame.size.width,y: 0,width: 1,height: 314*newScale))
            lbl.text = ""
            lbl.backgroundColor = CommonConfig.MainGrayColor
            if i < self.integralArr.count - 1 {
                self.scrollview3.addSubview(lbl)
            }
        }
    }
    
    func getDiscountData(){
        RequestManager.RequestData(RequestUrl.Router.getHomePage(), showLoading: false, successCallBack: { (result) in
            for arr in result["content"]["flashlist"].arrayValue{
                self.flashlist.append(GoodsModel(goodsInfo: arr))
            }
            let result2 = result
            RequestManager.RequestData(RequestUrl.Router.getIntegral(page: 1), showLoading: false, successCallBack: { (result) in
//                print("result:%@",result)
                //需要的字段: cash  point  img  name  goods_id
                for dict in result["content"]["data"].arrayValue{
                    self.integralArr.append(integralModel(integralInfo:dict))
                }
            self.setDiscountInfo(result2["content"]["end_time"].stringValue, now_time: result2["content"]["now"].stringValue)
            }) { (failstr) in
//                print("failstr:%@",failstr)
            }
        }) { (failstr) in
//            print(failstr)
        }
    }
    
    func selectDiscountView(_ tag: NSInteger) {
//        print(self.flashlist[tag-1001].id)
//        if self.flashlist[tag-1001].is_end == "1" {
//            return
//        }
//        if self.flashlist[tag-1001].flash_type == "point"
//        {
//            print("积分商品")
//            DiscounClick!(self.flashlist[tag-1001].goods_id)
//        }else{
//            print("普通商品")
            DiscounClick!(self.flashlist[tag-1001].id)
//        }
        
//        if pointShop {
//            print("积分商品\(pointShop)")
//        }
//        else
//        {
//            print("普通商品\(pointShop)")
////            DiscounClick!(self.flashlist[tag-1001].id)
//        }
    }
    //跳转积分详情页面
    func IntegralDetailView(_ tag: NSInteger) {
        jumpIClick!(self.integralArr[tag-2000].goods_id)
    }
    
    func setAdvertInfo(){
//        let imgArr:Array<UIImageView> = [self.advertImg1,self.advertImg2]
//        for i in 0..<self.advertList["imgs"].count {
////            imgArr[i].hnk_setImageFromURL(URL: NSURL(string: CommonConfig.getImageUrl(self.advertList["imgs"][i]["path"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
//
//        }
    }
    
    func getAdvertData(){
        RequestManager.RequestData(RequestUrl.Router.getAdvert(), showLoading: false, successCallBack: { (result) in
            self.bannerList = result["content"]["banner"]
            self.advertList = result["content"]["ad"]
            self.recommendList = result["content"]["recommend"]
            self.setBanner()
            self.setAdvertInfo()
            self.setRecommendInfo()
        }) { (failstr) in
//            print(failstr)
        }
        
    }

    
    func setRecommendInfo(){
        let imgArr:Array<UIImageView> = [self.collectImg1,self.collectImg2,self.collectImg3,self.collectImg4,self.collectImg5,self.collectImg6,self.collectImg7,self.collectImg8]
//        for i in 0..<self.recommendList["imgs"].count {
//            imgArr[i].hnk_setImageFromURL(URL: NSURL(string: CommonConfig.getImageUrl(self.recommendList["imgs"][i]["path"].stringValue))!, placeholder: UIImage(named: CommonConfig.imageDefaultName))
//            
//        }
        
    }
    
    @IBAction func advertClick(_ sender: UIButton) {
        let advertInfo = self.advertList["imgs"][sender.tag - 101]
        bannerClick!(advertInfo)
    }
    
    
    @IBAction func collectClick(_ sender: UIButton) {
        let recommendInfo = self.recommendList["imgs"][sender.tag - 1001]
        bannerClick!(recommendInfo)
    }
    
    //    func getTime(){
    //        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainCollectionHeadView.heartbeat), userInfo: nil, repeats: false)
    //    }
    
    //    func heartbeat() {
    //        nowtime -= 1
    //        if self.nowtime <= 0{
    //            hlbl.text = "00"
    //            mlbl.text = "00"
    //            slbl.text = "00"
    //            self.normalState()
    //            return
    //        }
    //        exchangeTime()
    //    }
    
    //    func exchangeTime(){
    //        var a = nowtime/3600
    //        var b = nowtime - nowtime/3600 * 3600
    //        hlbl.text = "\(a)"
    //        if a < 10 {
    //            hlbl.text = "0\(a)"
    //        }
    //
    //        a = b/60
    //        b = b - a * 60
    //        mlbl.text = "\(a)"
    //        if a < 10 {
    //            mlbl.text = "0\(a)"
    //        }
    //
    //        a = b % 60
    //        slbl.text = "\(a)"
    //        if a < 10 {
    //            slbl.text = "0\(a)"
    //        }
    
    //        self.normalState()
    //        getTime()
    //    }
    
    //    func normalState() {
    ////        if self.timer == nil {
    ////            return
    ////        }
    ////        self.timer.invalidate()
    ////        self.timer = nil
    //    }
    
}
