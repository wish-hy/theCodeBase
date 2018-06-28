//
//  PayViewController.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/1.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

//class PayViewController: UIViewController,UPAPayPluginDelegate{
//
//    @IBOutlet weak var view1: UIView!
//    @IBOutlet weak var view2: UIView!
//    @IBOutlet weak var titlelbl: UILabel!
//    @IBOutlet weak var backBtn: UIButton!
//    @IBOutlet weak var cardlbl: UILabel!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var onlinePay: UIButton!
//    @IBOutlet weak var PAGPay: UIButton!
//    @IBOutlet weak var confirmBtn: UIButton!
//    @IBOutlet weak var pricelbl: UILabel!
//    @IBOutlet weak var wx: UILabel!
//    @IBOutlet weak var ali: UILabel!
//    @IBOutlet weak var card: UILabel!
//
//    @IBOutlet weak var view3: UIView!
//
//    @IBOutlet weak var backOrd: UIButton!
//
//    @IBOutlet weak var goShop: UIButton!
//
//    @IBOutlet weak var view4: UIView!
//    @IBOutlet weak var ordname: UILabel!
//    @IBOutlet weak var ordphone: UILabel!
//    @IBOutlet weak var ordaddr: UILabel!
//    @IBOutlet weak var ordaddress: UILabel!
//    @IBOutlet weak var ordscrollview: UIScrollView!
//    @IBOutlet weak var ordprice1: UILabel!
//    @IBOutlet weak var ordcount: UILabel!
//    @IBOutlet weak var ordfreight: UILabel!
//    @IBOutlet weak var ordinvoice: UILabel!
//    @IBOutlet weak var ordpayway: UILabel!
//    @IBOutlet weak var ordallprice: UILabel!
//
//
//    @IBOutlet weak var top1: NSLayoutConstraint!
//    @IBOutlet weak var imgH: NSLayoutConstraint!
//    @IBOutlet weak var top2: NSLayoutConstraint!
//    @IBOutlet weak var top3: NSLayoutConstraint!
//    @IBOutlet weak var top4: NSLayoutConstraint!
//    @IBOutlet weak var top5: NSLayoutConstraint!
//    @IBOutlet weak var wid: NSLayoutConstraint!
//    @IBOutlet weak var payWid: NSLayoutConstraint!
//    @IBOutlet weak var payHei: NSLayoutConstraint!
//    @IBOutlet weak var ordHei: NSLayoutConstraint!
//
//    var isConfirm:Bool = true
//    var isSuccess:Bool = false
//    var isPay:Bool = false
//    var lastBtn:UIButton!
//    var price = ""
//    var orderInfo:JSON!
//    var orderIds:Array<String> = []
//    var orderIdsNew:[String:String] = [:]
//    var orderType:Dictionary = ["wxpay":"0","alipay":"0","balance":"0","unionpayapp":"0"]
//
//    var isGoods:Bool = false
//    var paymentid = 15   //支付方式id
//    var promid = ""     //订单优惠
//    var isinvoice = ""    //是否需要发票 0不需要 1需要
//    var invoicetype = "" //发票类型
//    var userremark = "" //用户留言
//    var voucher = ""    //优惠券id
//    var carttype = "" //如果是立即购买就传goods，如果是先加入购物车再买就不需要这个
//    var invoicetitle = ""    //抬头
//    var productID = ""
//    var orderno = ""
//    var totalfee = ""
//    var order_id = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.orderAddress(_:)), name: NSNotification.Name(rawValue: "orderAddress"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.orderInvoice(_:)), name: NSNotification.Name(rawValue: "orderInvoice"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.orderPayment(_:)), name: NSNotification.Name(rawValue: "orderPayment"), object: nil)
//
//        setInfo()
//        // Do any additional setup after loading the view.
//    }
//
//    func getDoPay(_ order_id:String,payment_id:String,isApplePay:Bool = false,successCallBack: @escaping()->Void){
//        RequestManager.RequestData(RequestUrl.Router.dopay(order_id: order_id, payment_id: payment_id, user_id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//            print(result)
//            if isApplePay{
//                self.orderno = result["content"]["tn"].stringValue
//            }else{
//                self.totalfee = result["content"]["senddata"]["total_fee"].stringValue
//                self.orderno = result["content"]["senddata"]["order_no"].stringValue
//                self.productID = result["content"]["order_id"].stringValue
//            }
//            successCallBack()
//        }) { (fail) in
//            print(fail)
//        }
//    }
//
//    func setInfo(){
//        getPayType()
//        top1.constant = 148*newScale
//        top2.constant = 20*newScale
//        top3.constant = 20*newScale
//        top4.constant = 86*newScale
//        top5.constant = 28*newScale
//        imgH.constant = 200*newScale
//        wid.constant = 340*newScale
//        payWid.constant = 270*newScale
//        payHei.constant = 55
//        ordfreight.text = "¥0.0"
//        ordinvoice.text = "不需要"
//        ordpayway.text = "在线支付"
//        pricelbl.text = price + "元"
//        if isConfirm {
//            getOrdInfo()
//        }
//        backBtn.setTitle(IconFontIconName.icon_back.rawValue, for: UIControlState())
//        cardlbl.text = IconFontIconName.icon_pay_way.rawValue
//        wx.text = IconFontIconName.icon_wechat_pay.rawValue
//        ali.text = IconFontIconName.icon_alipay.rawValue
//        card.text = IconFontIconName.icon_unipay.rawValue
//        wx.textColor = CommonConfig.MainGreenColor
//        ali.textColor = CommonConfig.MainBlueColor
//        card.textColor = CommonConfig.MainYellowColor
//        onlinePay.layer.borderColor = CommonConfig.MainRedColor.cgColor
//        onlinePay.layer.borderWidth = 1
//        onlinePay.layer.cornerRadius = 5
//        onlinePay.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
//        onlinePay.clipsToBounds = true
//        lastBtn = onlinePay
//        PAGPay.layer.borderColor = CommonConfig.MainFontBlackColor.cgColor
//        PAGPay.layer.borderWidth = 1
//        PAGPay.layer.cornerRadius = 5
//        PAGPay.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
//        PAGPay.clipsToBounds = true
//        confirmBtn.layer.cornerRadius = 5
//        confirmBtn.clipsToBounds = true
//        backOrd.layer.cornerRadius = 90*newScale/2
//        backOrd.clipsToBounds = true
//        goShop.layer.cornerRadius = 90*newScale/2
//        goShop.clipsToBounds = true
//        view2.isHidden = false
//        view3.isHidden = false
//        view4.isHidden = false
//        if isPay {
//            view3.isHidden = true
//            view4.isHidden = true
//            titlelbl.text = "在线支付"
//            checkpay_password()
//        }else if !isSuccess && !isConfirm{
//            view2.isHidden = true
//            view3.isHidden = true
//            view4.isHidden = true
//            titlelbl.text = "选择支付配送方式"
//            setScrollView()
//        }
//        if isSuccess {
//            view2.isHidden = true
//            view4.isHidden = true
//            titlelbl.text = "付款成功"
//        }
//        if isConfirm {
//            view2.isHidden = true
//            view3.isHidden = true
//            titlelbl.text = "确认订单"
//        }
//    }
//
//    func setOrderInfo(){
//        let size = CommonConfig.getTextRectSize(self.orderInfo["addresslist"][0]["addr"].stringValue as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth-61, height: 0))
//        ordHei.constant = 40+40+58+84+61+18+13+size.height
//        setOrderAddress()
//        self.ordname.text = self.orderInfo["addresslist"][addressid]["accept_name"].stringValue
//        self.ordaddr.text = self.orderInfo["addresslist"][addressid]["address"].stringValue
//        self.ordaddress.text = self.orderInfo["addresslist"][addressid]["addr"].stringValue
//        self.ordphone.text = self.orderInfo["addresslist"][addressid]["mobile"].stringValue
//        let mobile = self.orderInfo["addresslist"][addressid]["mobile"].stringValue
//        if MySDKHelper.isMobile(mobile) {
//            self.ordphone.text = (mobile as NSString).substring(to: 3) + "******" + (mobile as NSString).substring(from: 9)
//        }else{
//            if mobile != "" {
//                self.ordphone.text = (mobile as NSString).substring(to: mobile.characters.count-4) + "****"
//            }
//
//        }
//        var num = 0
//        var prices:CGFloat = 0
//        if isGoods {
//            num = self.orderInfo["cartlist"][productID]["num"].intValue
//            prices = CGFloat(self.orderInfo["cartlist"][productID]["real_price"].floatValue)*CGFloat(num)
//            goodsWeight += CGFloat(self.orderInfo["cartlist"][productID]["weight"].floatValue)*CGFloat(num)
//            orderIdsNew[self.orderInfo["cartlist"][productID]["id"].stringValue] = "\(num)"
//            orderIds.append(self.orderInfo["cartlist"][productID]["id"].stringValue)
//        }else{
//            for i in 0..<self.orderInfo["cartlist"].count{
//                num += self.orderInfo["cartlist"][i]["num"].intValue
//                prices += CGFloat(self.orderInfo["cartlist"][i]["real_price"].floatValue)*CGFloat(num)
//                goodsWeight += CGFloat(self.orderInfo["cartlist"][i]["weight"].floatValue)*CGFloat(num)
//                orderIdsNew[self.orderInfo["cartlist"][productID]["id"].stringValue] = "\(num)"
//                orderIds.append(self.orderInfo["cartlist"][productID]["id"].stringValue)
//            }
//        }
//        self.ordcount.text = "共\(num)件"
//        self.ordprice1.text = "¥\(prices)"
//        self.ordallprice.text = "¥\(prices)"
//        getFreightPrice()
//    }
//    var addressid = 0
//    func setOrderAddress(){
//        for i in 0..<self.orderInfo["addresslist"].count {
//            if self.orderInfo["addresslist"][i]["is_default"].intValue == 1 {
//                addressid = i
//                return
//            }
//        }
//
//    }
//    var goodsWeight:CGFloat = 0
//    func getFreightPrice(){
//        RequestManager.RequestData(RequestUrl.Router.orderCalculateFare(addrid: self.orderInfo["addresslist"][addressid]["id"].intValue, weight: goodsWeight, product: orderIdsNew, user_id: CommonConfig.UserInfoCache.userId), showLoading: false, successCallBack: { (result) in
//            print(result)
//            self.ordfreight.text = "¥" + result["content"]["fee"].stringValue
//            }) { (fail) in
//                print(fail)
//        }
//    }
//
//    func setScrollView(){
//        self.scrollView.contentSize = CGSize(width: screenWidth, height: 0)
//        self.scrollView.isPagingEnabled = false
//        var count = self.orderInfo["cartlist"].count
//        if isGoods {
//            count = 1
//        }
//        for i in 0..<count{
//            let img = UIImageView.init(frame: CGRect(x:CGFloat(i)*56 + CGFloat(i+1)*10,y: 0,width: 56,height: 56))
//            if isGoods {
//                img.hnk_setImageFromURL(URL: NSURL(string: CommonConfig.getImageUrl(self.orderInfo["cartlist"][productID]["img"].stringValue))!, placeholder: UIImage(named: CommonConfig.imageDefaultName))
//            }else{
//                img.hnk_setImageFromURL(URL: NSURL(string: CommonConfig.getImageUrl(self.orderInfo["cartlist"][i]["img"].stringValue))!, placeholder: UIImage(named: CommonConfig.imageDefaultName))
//            }
//            img.layer.cornerRadius = 2
//            img.layer.borderWidth = 1
//            img.layer.borderColor = CommonConfig.MainGrayColor.cgColor
//            self.scrollView.addSubview(img)
//        }
//    }
//
//    func setOrderScrollView(){
//        self.ordscrollview.contentSize = CGSize(width: screenWidth, height: 0)
//        self.ordscrollview.isPagingEnabled = false
//        var x:CGFloat = 15
//        var count = self.orderInfo["cartlist"].count
//        if isGoods {
//            count = 1
//        }
//        for i in 0..<count{
//            let btn = UIButton.init(frame: CGRect(x:x,y: 17,width: 50,height: 50))
//            btn.setTitle("", for: .normal)
//            if isGoods {
//                 btn.hnk_setImageFromURL(URL: NSURL(string: CommonConfig.getImageUrl(self.orderInfo["cartlist"][productID]["img"].stringValue))!, placeholder: UIImage(named: CommonConfig.imageDefaultName))
//            }else{
//                btn.hnk_setImageFromURL(URL: NSURL(string: CommonConfig.getImageUrl(self.orderInfo["cartlist"][i]["img"].stringValue))!, placeholder: UIImage(named: CommonConfig.imageDefaultName))
//            }
//            btn.layer.borderWidth = 1
//            btn.layer.borderColor = CommonConfig.MainGrayColor.cgColor
//            btn.addTarget(self, action: #selector(PayViewController.imgClick(_:)), for: .touchUpInside)
//            btn.tag = i
//            self.ordscrollview.addSubview(btn)
//            x += CGFloat(i)*60
//
//        }
//    }
//
//    func imgClick(_ sender:UIButton){
//        CommonConfig.getProductDetail(self, goodsID: self.orderInfo["cartlist"][sender.tag]["goods_id"].stringValue)
//    }
//
//    func getOrdInfo(){
//        var type = "1"
//        if isGoods {
//            type = "goods"
//        }
//        RequestManager.RequestData(RequestUrl.Router.orderConfirm(selectids: orderIds as NSArray,user_id: CommonConfig.UserInfoCache.userId,cart_type: type), successCallBack: { (result) in
//            print(result)
//            self.orderInfo = result["content"]
//            self.setOrderInfo()
//            self.setOrderScrollView()
//
//            }) { (fail) in
//                print(fail)
//        }
//    }
//    var pay_password = ""
//    var openPass:Bool = false
//    func checkpay_password(){
//        RequestManager.RequestData(RequestUrl.Router.checkVerifyPass(userid: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//            print(result)
//            if result["content"]["pay_password_open"].intValue == 0{
//                self.openPass = false
//            }else{
//                self.openPass = true
//            }
//            }) { (fail) in
//                print(fail)
//        }
//    }
//    //金点支付
//    func payorder(){
//        RequestManager.RequestData(RequestUrl.Router.paybalance(order_no: orderno, total_fee: totalfee, user_id: CommonConfig.UserInfoCache.userId, pay_password: pay_password), showLoading: true, successCallBack: { (result) in
//            print(result)
//            }) { (fail) in
//                print(fail)
//        }
//    }
//
//    func getPayType(){
//        RequestManager.RequestData(RequestUrl.Router.getPaytypeList(user_id: CommonConfig.UserInfoCache.userId, platform: "ios"), showLoading: false, successCallBack: { (result) in
//            print(result)
//            for i in 0..<result["content"]["paytypelist"].count{
//                if result["content"]["paytypelist"][i]["id"].intValue == 23{
//                    self.orderType["balance"] = result["content"]["paytypelist"][i]["id"].stringValue
//                }else if result["content"]["paytypelist"][i]["id"].intValue == 22{
//                    self.orderType["unionpayapp"] = result["content"]["paytypelist"][i]["id"].stringValue
//                }else if result["content"]["paytypelist"][i]["id"].intValue == 16{
//                    self.orderType["wxpay"] = result["content"]["paytypelist"][i]["id"].stringValue
//                }else if result["content"]["paytypelist"][i]["id"].intValue == 14{
//                    self.orderType["alipay"] = result["content"]["paytypelist"][i]["id"].stringValue
//                }
//            }
//
//            }) { (fail) in
//                print(fail)
//        }
//    }
//
//    @IBAction func jindianPay(_ sender: UIButton) {
////        if self.orderType["balance"] != "23" {
////            self.noticeOnlyText("暂不支持金点支付")
////            return
////        }
////        getDoPay(order_id, payment_id: self.orderType["balance"]!) { () in
////            self.payorder()
////        }
//        let pay = UPAPayViewController()
//        pay.price = self.price
//        pay.orderID = self.order_id
//        pay.userID = String(CommonConfig.UserInfoCache.userId)
//        pay.token = CommonConfig.Token
//        pay.chongzhi = false
//        self.navigationController?.pushViewController(pay, animated: true)
//    }
//
//
//    @IBAction func WXPay(_ sender: UIButton) {
//        if self.orderType["wxpay"] != "16" {
//            self.noticeOnlyText("暂不支持微信支付")
//            return
//        }
//        getDoPay(order_id, payment_id: self.orderType["wxpay"]!) { () in
////        WXPayHelper.payForWXPayWithViewController(self, withAppid: "wx5039d46ebb6580ad", withPartnerid: "1289671201", withPrepayid: orderno, withPrivateKey: "McFk71bCr9H30ybTop4vCWlC9gWOyebo", withTimeStamp: UInt32(CommonConfig.getNowTime())!, withNonceStr: "测试", withSeller: "")
//        // 关于微信请求参数https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2
//
//        let order = CGYPayWxOrder(partnerId: "商家id", prepayid: "预支付订单id", nonceStr: "随机字符串", timeStamp: 111111111, package: "扩展字段", sign: "签名")
//
//        CGYPay.createPayment(.weixin(order: order)) { status in
//            switch status {
//            case .paySuccess(let wxPayResult, _, _):
//                print("微信支付成功: \(String(describing: wxPayResult))")
//
//            default:
//                print("微信支付失败")
//                self.noticeOnlyText("微信支付失败")
//            }
//        }
//        }
//    }
//
//    @IBAction func AliPay(_ sender: UIButton) {
//        if self.orderType["alipay"] != "14" {
//            self.noticeOnlyText("暂不支持支付宝支付")
//            return
//        }
//        getDoPay(order_id, payment_id: self.orderType["alipay"]!) { () in
//        // 关于orderStr参数 https://doc.open.alipay.com/doc2/detail?treeId=59&articleId=103663&docType=1
//
//        let order = CGYPayAliPayOrder(partner: "商家id", seller_id: "商家支付宝账号", out_trade_no: "订单id", subject: "商品标题", body: "商品描述", total_fee: "总价格", notify_url: "url回调", sign: "签名", appScheme: "com.ccggyy.cgypay")
//
//        CGYPay.createPayment(.aliPay(order: order)) { status in
//            switch status {
//            case .paySuccess(_, let aliPayResult, _):
//                print("支付宝支付成功: \(String(describing: aliPayResult))")
//            default:
//                print("支付宝支付失败")
//                self.noticeOnlyText("支付宝支付失败")
//            }
//        }
//        }
//    }
//
//    @IBAction func CardPay(_ sender: UIButton) {
//        print("12132131")
//
//        if self.orderType["unionpayapp"] != "22" {
//            self.noticeOnlyText("暂不支持银联支付")
//            return
//        }
//
//        getDoPay(order_id, payment_id: self.orderType["unionpayapp"]!,isApplePay:  true) { () in
//
//        //    *  支付接口
//        //    *
//        //    *  @param tn             订单信息
//        //    *  @param mode           接入模式,标识商户以何种方式调用支付控件,00生产环境，01测试环境
//        //    *  @param viewController 启动支付控件的viewController
//        //    *  @param delegate       实现 UPAPayPluginDelegate 方法的 UIViewController
//        //    *  @param mID            苹果公司分配的商户号,表示调用Apple Pay所需要的MerchantID;
//        //    *  @return 返回函数调用结果，成功或失败 com.ccggyy.cgypay 802440353110663
//            if (UIDevice.current.systemVersion as NSString).floatValue >= 9.2 {
//                print(self.orderno)
//                UPAPayPlugin.startPay(self.orderno, mode: "01", viewController: self, delegate: self, andAPMechantID: "merchant.wending.BuyDShopMID")
////
//            }else{
//
//
//                    self.upPayHandler()
//            }
//
////            let pay = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ApplePayController") as! ApplePayController
////            pay.pricecurrency = "¥"
////            pay.isShow = true
////            pay.orderNo = self.orderno
////            pay.oldPrice = self.price
////            pay.newPrice = self.price
////            pay.priceShow = "0.00"
////            pay.orderTime = CommonConfig.timeStampToString(CommonConfig.getNowTime())
////            self.navigationController?.pushViewController(pay, animated: true)
//        }
//
//    }
//
//    func upaPayPluginResult(_ payResult: UPPayResult!) {
//        if payResult.paymentResultStatus == .success {
//
//            print("支付成功")
//            let pay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ApplePayController") as! ApplePayController
//            if payResult.otherInfo == nil ||  payResult.otherInfo == ""{
//                pay.isShow = false
//                pay.newPrice = ""
//                pay.oldPrice = ""
//            }else{
//                pay.isShow = true
//                print("payResult.otherInfo",payResult.otherInfo)
//                let arr1 = payResult.otherInfo.components(separatedBy: "&")
//                for i in 0..<arr1.count {
//                    let arr2 = arr1[i].components(separatedBy: "=")
//                    if arr2[0] == "order_amt" {
//                         pay.oldPrice = arr2[1]
//                    }else if arr2[0] == "pay_amt" {
//                        pay.newPrice = arr2[1]
//                    }else if arr2[0] == "currency" {
//                        if arr2[1] == "元" {
//                            pay.pricecurrency = "¥"
//                        }else{
//                            pay.pricecurrency = "$"
//                        }
//                    }
//                }
//            }
//            let price = (pay.oldPrice as NSString).floatValue - (pay.newPrice as NSString).floatValue
//            pay.priceShow = String.init(format: ".2f", price)
//            pay.orderNo = self.orderno
//            pay.orderTime = self.orderno
//            pay.orderName = self.orderno
//            self.navigationController?.pushViewController(pay, animated: true)
//        }else if payResult.paymentResultStatus == .failure {
//            print("支付失败")
//            self.noticeOnlyText("ApplePay支付失败")
//        }else if payResult.paymentResultStatus == .cancel {
//            print("用户取消")
//            self.noticeOnlyText("用户取消")
//        }
//    }
//
//    func upPayHandler() {
//        /*
//         测试用例
//
//         获取测试订单号  http://101.231.204.84:8091/sim/getacptn
//
//         招商银行借记卡：6226090000000048
//             手机号：18100000000
//             密码：111101
//             短信验证码：123456（先点获取验证码之后再输入）
//             证件类型：01身份证
//             证件号：510265790128303
//             姓名：张三
//
//         华夏银行贷记卡：6226388000000095
//             手机号：18100000000
//             CVN2：248
//             有效期：1219
//             短信验证码：123456（先点获取验证码之后再输入）
//             证件类型：01身份证
//             证件号：510265790128303
//             姓名：张三
//         */
//
//        UPPaymentControl.default().startPay(self.orderno, fromScheme: "merchant.wending.BuyDShopMID", mode: "01", viewController: self)
//
////        let order = CGYPayUpOrder(tn: "201609301433141924328", appScheme: "com.ccggyy.cgypay", mode: "01", viewController: self)
////
////        CGYPay.createPayment(.upPay(order: order)) { status in
////            switch status {
////            case .PaySuccess(_, _, let upPayResult):
////                print("银联支付成功: \(upPayResult)")
////            default:
////                print("银联支付失败")
////                self.noticeOnlyText("银联支付失败")
////            }
////        }
//    }
//
//
//
//    @IBAction func onlineClick(_ sender: UIButton) {
//        if onlinePay == lastBtn {
//            return
//        }
//        lastBtn = onlinePay
//        onlinePay.layer.borderColor = CommonConfig.MainRedColor.cgColor
//        onlinePay.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
//        PAGPay.layer.borderColor = CommonConfig.MainFontBlackColor.cgColor
//        PAGPay.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
//    }
//
//    @IBAction func PAGClick(_ sender: UIButton) {
//        if PAGPay == lastBtn {
//            return
//        }
//        lastBtn = PAGPay
//        PAGPay.layer.borderColor = CommonConfig.MainRedColor.cgColor
//        PAGPay.setTitleColor(CommonConfig.MainRedColor, for: UIControlState())
//        onlinePay.layer.borderColor = CommonConfig.MainFontBlackColor.cgColor
//        onlinePay.setTitleColor(CommonConfig.MainFontBlackColor, for: UIControlState())
//    }
//
//    @IBAction func confirmClick(_ sender: UIButton) {
//        if onlinePay == lastBtn {
////            let pay = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
////            pay.isPay = true
////            pay.price = self.price
////            self.navigationController?.pushViewController(pay, animated: true)
//            let pay = UPAPayViewController()
//            pay.price = self.price
//            pay.orderID = self.order_id
//            pay.userID = String(CommonConfig.UserInfoCache.userId)
//            pay.chongzhi = false
//            self.navigationController?.pushViewController(pay, animated: true)
//        }
//    }
//
//    @IBAction func backClick(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func backOrder(_ sender: UIButton) {
//
//    }
//
//    @IBAction func goShopping(_ sender: UIButton) {
//        (UIApplication.shared.delegate as! AppDelegate).showMainPage()
//    }
//
//    @IBAction func orderAddressClick(_ sender: UIButton) {
//
//    }
//
//    @IBAction func orderClick1(_ sender: UIButton) {
//
//    }
//
//    @IBAction func orderClick2(_ sender: UIButton) {
//
//    }
//
//    @IBAction func orderClick3(_ sender: UIButton) {
//        let invoice = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InvoiceViewController") as! InvoiceViewController
//
//        self.navigationController?.pushViewController(invoice, animated: true)
//    }
//
//    @IBAction func orderClick4(_ sender: UIButton) {
//        let pay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
//        pay.isConfirm = false
//        pay.isPay = false
//        pay.isSuccess = false
//        pay.isGoods = self.isGoods
//        pay.orderInfo = self.orderInfo
//        pay.productID = self.productID
//        self.navigationController?.pushViewController(pay, animated: true)
//    }
//
//    @IBAction func orderPayConfirm(_ sender: UIButton) {
//        if isGoods {
//            carttype = "goods"
//        }
//        RequestManager.RequestData(RequestUrl.Router.orderSubmit(user_id: CommonConfig.UserInfoCache.userId, selectids: orderIds, address_id: self.orderInfo["addresslist"][addressid]["id"].intValue, payment_id: paymentid, prom_id: promid, is_invoice: isinvoice, invoice_type: invoicetype, user_remark: userremark, voucher: voucher, cart_type: carttype), successCallBack: { (result) in
//                print(result)
////            CommonConfig.getDoPay(self, order_id: result["content"].stringValue, order_amount: (self.ordallprice.text?.stringByReplacingOccurrencesOfString("¥", withString: ""))!,isGoods:self.isGoods)
//            let pay = UPAPayViewController()
//            pay.price = (self.ordallprice.text?.replacingOccurrences(of:"¥",with: ""))!
//            pay.orderID = result["content"].stringValue
//            pay.userID = String(CommonConfig.UserInfoCache.userId)
//            pay.token = CommonConfig.Token
//            pay.chongzhi = false
//            self.navigationController?.pushViewController(pay, animated: true)
//            }) { (fail) in
//                print(fail)
//        }
//    }
//
//    func orderAddress(_ notification:Notification){
//        let info = notification.object as! NSDictionary
//        let address = info.value(forKey: "address") as! String
//        let id = info.value(forKey: "id") as! String
//        let accept_name = info.value(forKey: "accept_name") as! String
//        let mobile = info.value(forKey: "mobile") as! String
//        let addr = info.value(forKey: "addr") as! String
//        self.ordaddress.text = addr
//        self.ordaddr.text = address
//        if MySDKHelper.isMobile(mobile) {
//            self.ordphone.text = (mobile as NSString).substring(to: 3) + "******" + (mobile as NSString).substring(from: 9)
//        }else{
//            self.ordphone.text = (mobile as NSString).substring(to: mobile.characters.count-4) + "****"
//        }
//        self.ordname.text = accept_name
//        self.addressid = (id as NSString).integerValue
//    }
//
//    func orderInvoice(_ notification:Notification){
//        let info = notification.object as! NSDictionary
//        invoicetype = info.value(forKey: "invoicetype") as! String
//        isinvoice = info.value(forKey: "isinvoice") as! String
//        invoicetitle = info.value(forKey: "invoicetitle") as! String
//        if isinvoice == "1" {
//            ordinvoice.text = "需要"
//        }else{
//            ordinvoice.text = "不需要"
//        }
//        if invoicetype == "0" {
//            invoicetitle = self.ordname.text!
//        }
//    }
//
//    func orderPayment(_ notification:Notification){
//        let info = notification.object as! NSDictionary
//        _ = info.value(forKey: "payment") as! String
//    }
//
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

