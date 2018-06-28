//
//  CommonConfig.swift
//  mibo
//
//  Created by TeamMac2 on 16/1/27.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
//import Haneke
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


public enum NavigationAnimatorType{
    case defaultAni,//默认动画
    peopleInfoAni//用户信息动画
}

public class CommonConfig:NSObject{
    //
    static let MainURL = "http://www.ymlypt.com"
    

    static var ImageHost = "https://ymlypt.b0.upaiyun.com"
    

    static var UploadURL = "http://v0.api.upyun.com/buy-d"
    //主蓝色
    static let MainBlueColor = UIColor(hexCode: "5a9ce6")
    //主黄色
    static let MainYellowColor = UIColor(hexCode: "ffa200")
    //主灰色
    static let MainGrayColor = UIColor(hexCode: "efefef")
    //主绿色
    static let MainGreenColor = UIColor(hexCode: "74c717")
    //深红色
    static let MainRedColor = UIColor(hexCode: "ff0000")
    //浅红色
    static let MainLightRedColor = UIColor(hexCode: "ff4a3a")
    //主文字灰色
    static let MainFontGrayColor = UIColor(hexCode: "8a8a8a")
    //主文字黑色
    static let MainFontBlackColor = UIColor(hexCode: "303030")
    //滑动条黑色 如果底色是白色用灰色efefef   底色是灰色用dfdfdf
    static let SliderBlackColor = UIColor(hexCode: "dfdfdf")
    //浅搜索边框颜色
    static let MainSearchColor = UIColor(hexCode: "5ca608")
    //  白色
    static let MainWhiteColor = UIColor(hexCode: "ffffff")
    //  灰色
    static let MainBackGrouneGrayColor = UIColor(hexCode: "898989")
    //主页导航高度
    static let NavigationBarHeight:CGFloat = 44
    static let TabBarHeight:CGFloat = 49
//    if 判断是否iphonex  设置高度
    static let StatusBar = UIApplication.shared.statusBarFrame.height
    //token，登录接口获取
    static var Token:String = ""
    
    //navigation动画
    static var CurrentNavigationAni:NavigationAnimatorType = NavigationAnimatorType.defaultAni
    //用户默认图片
    static let userDefaultIcon = "wode2"
    //封面默认图片
    static let imageDefaultName = "moren"
    
    static var isLogin:Bool = false     //用户是否登陆
    static var UserInfoCache:UserInfoModel!//获取用户信息
    static var isProduce:Bool = true     //是否是在审核状态 false - 在审核中  true － 审核完毕
    static var chatUserId:Int = 0       //当前私聊的用户id
    static var shopBadge:Int = 0        //购物车角标
    static var shopBadgeRead:Bool = false        //购物车角标
    static var isGoods:Bool = false     //
    static var sys = "" // 系统消息
    static var only = "" // 客服消息
    static var unpay = "" // 待付款
    static var delivery = "" // 待收货
    static var review = "" // 待评论
    static var cityData = NSArray() as [AnyObject]
    static var avatarImg :UIImage?
    
    
    //判断imageurl，如果不完整，自动补全 http://buy-d.b0.upaiyun.com/
    class func getImageUrl(_ imageUrl:String) -> String{
        var imgurl = imageUrl
        if !imageUrl.hasPrefix("http://") {
            if imageUrl.hasPrefix("/") {
                imgurl = CommonConfig.ImageHost + imageUrl
            }else{
                imgurl = CommonConfig.ImageHost + "/" + imageUrl
            }
        }
        return imgurl
    }
    //根据sex值获取性别图片,sex:1-男；2-女空
    class func getSexImageBySex(_ sex:String) -> UIImage{
        var sexImageName = "c9"
        if sex == "1"{
            sexImageName = "c8"
        }
        return UIImage(named: sexImageName)!
    }
    class func setLoginSuccessInfo(_ detail:JSON){
        let phonelist = UserDefaults.standard.dictionary(forKey: "ShopPhoneList")
        
        if phonelist == nil {
            let plist = [String:Any]()
            UserDefaults.standard.set(plist, forKey: "ShopPhoneList")
        }
        
        let dicdata = UserDefaults.standard.object(forKey: "ShopPhoneList") as! NSDictionary
        if detail["otherType"].stringValue == "0"{
            let value = detail["password"].stringValue
            let key = detail["account"].stringValue
            var dic:NSMutableDictionary = [:]
                dic = NSMutableDictionary.init(dictionary: dicdata)
            dic.setObject(value, forKey: key as NSCopying)
            let listInfo:NSDictionary = NSDictionary.init(dictionary: dic)
             UserDefaults.standard.set(listInfo, forKey: "ShopPhoneList")
        }
        try! UserDefaults.standard.set(detail.rawData(), forKey: "UserInfo")
        CommonConfig.Token = detail["token"].stringValue
        CommonConfig.UserInfoCache = UserInfoModel(userInfo: detail)
        
        if !(CommonConfig.UserInfoCache.photo == nil) {
            CommonConfig.avatarImg = UIImage.init(named: "wode2")
        }
        else
        {
             CommonConfig.avatarImg = UIImage.init(data: try! Data.init(contentsOf: CommonConfig.UserInfoCache.photo))
        }
       
        UserDefaults.standard.set(true, forKey: "IsLogin")
        
        //  将user_id   Token 保存到本地
        let userDefaults = UserDefaults.standard
        /**
         存储数据
         */
        userDefaults.set(CommonConfig.Token, forKey: "token")
        userDefaults.set(detail["user_id"].stringValue, forKey: "user_id")
        /**
         同步数据
         */
        userDefaults.synchronize()
        
        CommonConfig.isLogin = true
        let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
        NotificationCenter.default.post(name: notificationName, object: self)

        RCIM.shared().connect(withToken: CommonConfig.UserInfoCache.rongyun_token, success: { (string) in
            let userInfo = RCUserInfo.init();
            userInfo.name = CommonConfig.UserInfoCache.nickName
            userInfo.userId = String.init(stringInterpolationSegment: CommonConfig.UserInfoCache.userId)
            print(userInfo.userId)
            userInfo.portraitUri = CommonConfig.UserInfoCache.photoUrl
            RCIM.shared().currentUserInfo = userInfo
            print("融云登录结果",string!)
            print("photo",userInfo.portraitUri)
            }, error: { (errorCode) in
            
        }) {
            
        }
        
//        RCIM.shared().connect(withToken: CommonConfig.UserInfoCache.rongyun_token, success: { (result) in
//
//
//            }
//
//        }, error: { (errorCode) in
//
//        }) {
//
//        }
//        [[RCIM sharedRCIM] connectWithToken:CommonConfig.UserInfoCache.rongyun_token success:^(NSString *userId) {
//            NSLog(@"注册成功");
//            } error:^(RCConnectErrorCode status) {
//            NSLog(@"融云注册失败%ld",(long)status);
//            } tokenIncorrect:^{
//
//            }];
    }
    
    //获取视频标示，直播中，回放，小视频
    class func getLiveStateImageName(_ catId:Int, status:Int) -> String{
        if catId == 1{
            if status == 1{//直播中
                return "new_live"
            }else{//回放
                return "new_backplay"
            }
        }else if(catId == 99){//小视频
            return "new_shortVedio"
        }
        return ""
    }
    //设置性别
    class func setSexColor(_ sexLabel:UILabel, sex: String){
        
        if sex == "1" {
            sexLabel.setIconFont(IconFontIconName.icon_goods_cart_dismiss)
            sexLabel.textColor = UIColor.init(hexCode: "32b5e5")
            sexLabel.font = UIFont.init(name: "iconfont", size: 22)
        }else if sex == "2"{
            sexLabel.setIconFont(IconFontIconName.icon_goods_cart_dismiss)
            sexLabel.textColor = UIColor.init(hexCode: "ff99cc")
            sexLabel.font = UIFont.init(name: "iconfont", size: 20)
        }else{
            sexLabel.text = ""
        }
    }
    //设置等级
    class func setLevelTitleAndImage(_ levelBtn:UIButton, level:Int){
        let title = "\(level)"
        var levelcolor = "color1"
        if level <= 5 {
            levelcolor = "color1"
        }else if level <= 10 {
            levelcolor = "color2"
        }else if level <= 15 {
            levelcolor = "color3"
        }else if level <= 20 {
            levelcolor = "color4"
        }else if level <= 25 {
            levelcolor = "color5"
        }else{
            levelcolor = "color6"
        }
        levelBtn.setTitle(title, for: UIControlState())
        levelBtn.setTitleColor(UIColor.white, for: UIControlState())
        levelBtn.setBackgroundImage(UIImage(named: levelcolor), for: UIControlState())
        
        levelBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 11)
        
    }
    //设置列表关注按钮状态
    class func setAttentionStateWithButton(_ btn:UIButton, isAttention:Int){
        if isAttention > 0{
            btn.setIconFont(IconFontIconName.icon_goods_cart_dismiss)
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.isEnabled = false
        }else{
            btn.setIconFont(IconFontIconName.icon_goods_cart_dismiss)
            btn.setTitleColor(UIColor.init(hexCode: "63d6ca"), for: UIControlState())
            btn.isEnabled = true
        }
    }
    class func setAttentionStateWithLabel(_ lbl:UILabel, isAttention:Int){
        if isAttention > 0{
            lbl.setIconFont(IconFontIconName.icon_goods_cart_dismiss)
            lbl.textColor = UIColor.white
        }else{
            lbl.setIconFont(IconFontIconName.icon_goods_cart_dismiss)
            lbl.textColor = UIColor.init(hexCode: "63d6ca")
        }
    }
    //设置点赞icon
    class func setCollectIconWithButton(_ praiseBtn:UIButton, isCollect:Int){
        if isCollect > 0{
            praiseBtn.setIconFont(IconFontIconName.icon_collected)
            praiseBtn.setTitleColor(UIColor(hexCode: "ec5877"), for: UIControlState.disabled)
            praiseBtn.isEnabled = false
        }else{
            praiseBtn.setIconFont(IconFontIconName.icon_collect)
            praiseBtn.isEnabled = true
        }
    }
    
    //设置关注按钮状态
    class func setAttentionBtnState(_ btn:UIButton, isAttention:Int ,type:Int = 0){
        if isAttention <= 0 {
            btn.backgroundColor = UIColor.init(hexCode: "63daca")
            btn.setTitle("＋关注", for: UIControlState())
            if type == 1 {
                btn.setTitle("\(IconFontIconName.icon_collect.rawValue)关注", for: UIControlState())
            }
            btn.isEnabled = true
            btn.setTitleColor(UIColor.white, for: UIControlState())
        }else{
            btn.backgroundColor = UIColor.init(hexCode: "898989")
            btn.setTitle("已关注", for: UIControlState())
            if type == 1 {
                btn.setTitle("\(IconFontIconName.icon_collected.rawValue)已关注", for: UIControlState()) //只有在他人主页的时候使用
            }
            btn.isEnabled = false
            btn.setTitleColor(UIColor.white, for: UIControlState())
        }
    }
    
    class func getShareType(_ tag:Int) -> String{
        var share = UMSPlatformNameQQ
        switch tag {
        case 0:
            share = UMSPlatformNameWechatTimeline
        case 1:
            share = UMSPlatformNameWechatSession
        case 2:
            share = UMSPlatformNameSina
        case 3:
            share = UMSPlatformNameQzone
        case 4:
            share = UMSPlatformNameQQ
            
        default:
            print("none")
        }
        return share
    }
    
    
    /**
     *  获取字符串的宽度和高度
     *
     *  @param text:NSString
     *  @param font:UIFont
     *
     *  @return CGRect
     */
    class func getTextRectSize(_ text:NSString,font:UIFont,size:CGSize) -> CGRect {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        //        print("rect:\(rect)")
        return rect;
    }
    
    class func getNowTime(_ dateFormat:String = "yyyy-MM-dd HH:mm:ss.SSS",isNeed:Bool = false ,type:Int = 0) -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        var dateString = formatter.string(from: date)
        if type == 0 {
            dateString = String(stringToTimeStamp(dateString, dateFormat: dateFormat, isNeed: isNeed))
        }
        return dateString
    }
    
    /**
     时间转化为时间戳
     
     :param: stringTime 时间为stirng
     
     :returns: 返回时间戳为stirng
     */
    static func stringToTimeStamp(_ stringTime:String ,dateFormat:String = "yyyy年MM月dd日",isNeed:Bool = false)->Int64 {
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = dateFormat
        let date = dfmatter.date(from: stringTime)
        
        var dateStamp:Foundation.TimeInterval = date!.timeIntervalSince1970
        if isNeed {//true 是表示时间戳需要转成毫秒
            dateStamp = date!.timeIntervalSince1970 * 1000
        }
        let dateSt:Int64 = Int64(dateStamp)
        
//        print(dateSt)
        return dateSt
        
    }
    
    /**
     时间戳转时间
     
     :param: timeStamp
     
     :returns: return time
     */
    static func timeStampToString(_ timeStamp:String ,dateFormat:String = "yyyy年MM月dd日" ,isNeed:Bool = false)->String {
        
        let string = NSString(string: timeStamp)
        
        var timeSta:Foundation.TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = dateFormat
        if isNeed { //true 是表示时间戳是毫秒
            timeSta = timeSta / 1000
        }
        let date = Date(timeIntervalSince1970: timeSta)
        
//        print(dfmatter.string(from: date))
        return dfmatter.string(from: date)
        
    }
    
    //时间比较
    class func getNowDate(_ mess:Int64 ,dateFormat:String = "yyyy-MM-dd HH:mm:ss" ,backDateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String{
        var isNeed:Bool = false
        let messstr = "\(mess)"
        if messstr.characters.count == 13 {
            isNeed = true
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let dateString = formatter.string(from: date)
        let str1 = NSString.init(format: "%@",stringToTimeStamp(dateString, dateFormat: dateFormat, isNeed: isNeed))
        var timeValue = ""
        let nowdate:Int64 = Int64.init(String.init(str1))!
        var time = nowdate - mess
        if isNeed {
            time = time / 1000
        }
        if time < 3600 * 24{
            if time == 0{
                timeValue = "刚刚"
            }else if time < 60 {
                timeValue = "\(time)秒前"
            }else if time < 3600{
                timeValue = "\(time/60)分钟前"
            }else {
                timeValue = "\(time/3600)小时前"
            }
        }else {
            timeValue = timeStampToString(messstr ,dateFormat: backDateFormat,isNeed: isNeed)
        }
        return timeValue
    }

    //字符串替换
    class func replacingOfString(_ str:String, replaceStr: String, withString:String) -> String{
        let comment = str.replacingOccurrences(of: replaceStr, with: withString)
        return comment
    }
    //添加下划线
    class func setLineForText(_ text:NSString, color:UIColor, font:UIFont, type:NSInteger = 0) -> NSMutableAttributedString
    {
        let attri = NSMutableAttributedString(string: text as String)
        attri.addAttribute(kCTForegroundColorAttributeName as String, value: color.cgColor, range: NSMakeRange(0,text.length))
        attri.addAttribute(kCTFontAttributeName as String, value: font, range: NSMakeRange(0,text.length))
        if type == 0 {
            attri.addAttributes([NSUnderlineStyleAttributeName: 1], range: NSMakeRange(0,text.length))
        }else if type == 1 {
            attri.addAttributes([NSStrikethroughStyleAttributeName: 1], range: NSMakeRange(0,text.length))
        }
        
            return attri
    }
    
    //设置分段颜色
    class func setNSMutableAttributedTextColor(_ text:String,target:Array<String>,textColor:Array<UIColor>,size:Array<CGFloat>, firstSize:CGFloat) -> NSMutableAttributedString{
        let contentstr = NSString.init(string: text)
        let nsText = NSMutableAttributedString(string: text)
        nsText.addAttribute(kCTForegroundColorAttributeName as String, value: CommonConfig.MainRedColor.cgColor, range: NSMakeRange(0,contentstr.length))
        nsText.addAttribute(kCTFontAttributeName as String, value: UIFont.systemFont(ofSize: firstSize), range: NSMakeRange(0,contentstr.length))
        if target.count != 0 {
            for i in 0..<target.count {
                let ranges = contentstr.range(of: target[i])
                if ranges.location != NSNotFound {
                    if i >= textColor.count || i >= size.count{
                        break
                    }
                    nsText.addAttribute(kCTForegroundColorAttributeName as String, value: textColor[i].cgColor, range: ranges)
                    nsText.addAttribute(kCTFontAttributeName as String, value: UIFont.systemFont(ofSize: size[i]), range: ranges)
                }
            }
        }
        return nsText
    }
    
    //评论内容
    class func exchangeTextWithImage(_ text:NSString, color:UIColor, font:UIFont) -> NSMutableAttributedString{
        var attText = NSMutableAttributedString()
        let range1 = text.range(of: "[")
        let range2 = text.range(of: "]")
        if range1.length > 0 && range2.length > 0 {
            let text1 = text.substring(to: range1.location) as NSString
            let text2 = text.substring(with: NSMakeRange(range1.location , range2.location + 1 - range1.location))
            let text3 = text.substring(from: range2.location + 1) as NSString
            attText = NSMutableAttributedString.init(string: text1 as String)
            attText = getNSMutableAttributedImage(attText, text: text1, emjText: text2,color: color,font: font)
            attText.append(exchangeTextWithImage(text3,color: color,font: font))
        }else{
            attText = NSMutableAttributedString.init(string: text as String)
            attText = getNSMutableAttributedImage(attText, text: text, emjText: "",color: color,font: font)
        }
        return attText
    }
    // 获取表情名字
    class func getImageName(_ str:String) -> Bool{
        let emoji = EmojiCustom()
        for emj in emoji.emojiArray {
            if emj.key == str {
                return true
            }
        }
        return false
    }
    
    class func getChatImage(_ str:String) -> UIImage{
        let emoji = EmojiCustom()
        var img = UIImage()
        for emj in emoji.emojiArray {
            if emj.key == str {
                img = emj.image
                return img
            }
        }
        return img
    }
    
    class func getNSMutableAttributedImage(_ attri:NSMutableAttributedString,text:NSString ,emjText:String, color:UIColor, font:UIFont) -> NSMutableAttributedString
    {
        attri.addAttribute(kCTForegroundColorAttributeName as String, value: color.cgColor, range: NSMakeRange(0,text.length))
        attri.addAttribute(kCTFontAttributeName as String, value: font, range: NSMakeRange(0,text.length))
        if getImageName(emjText) {
            let attch = NSTextAttachment()
            attch.image = getChatImage(emjText);
            attch.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
            let string = NSAttributedString.init(attachment: attch)
            attri.append(string)
        }
        return attri
    }

    class func getMobCode(_ phone:String, zone:String, showLoading:Bool = true,successCallBack: @escaping ()->Void, failCallBack: @escaping (NSError)->Void)
    {
        if showLoading{
            SwiftNotice.wait()
        }
        MOBHelper.getVerificationCode(by: .SMS, phoneNumber: phone, zone: zone, customIdentifier: "huabi") { (error) in
            if error == nil{
                if showLoading{
                    SwiftNotice.clear()
                }
                print("获取验证码成功")
                successCallBack()
            }else{
                if showLoading{
                    SwiftNotice.clear()
                }
                failCallBack(error! as NSError)
                print("获取验证码失败(\(String(describing: error))")
            }
        }
    }
    
    class func checkPassword(_ pass:String) -> NSInteger{
        let arr = ["~","@","#","%","&","*","-","_","=","+","/","\\"]
        var type = 0;
        for i in 0..<10 {
            if pass.components(separatedBy: "\(i)").count > 1 {
                type += 1
                break;
            }
        }
        for j in arr {
            if pass.components(separatedBy: j).count > 1 {
                type += 1
                break;
            }
        }
        for char in pass.utf8  {
            if (char > 64 && char < 91) || (char > 96 && char < 123) {
                type += 1
                break;
            }
        }
        return type
    }
    
    class func checkPrice(_ pri:String) -> Bool{
        var counts = 0
        for i in 0..<10 {
            counts +=  pri.components(separatedBy: "\(i)").count - 1
        }
        if counts !=  pri.characters.count{
            
            return false
        }else{
            if Int(pri) <= 0 {
                return false
            }
            return true
        }
    }

    //获取分类cell的高度
    class func getCellHeight(_ info:Array<String>) -> CGFloat{
        var lastX:CGFloat = 0
        var lastY:CGFloat = 8
        var maxY:CGFloat = 0
        for i in 0..<info.count {
            let size = CommonConfig.getTextRectSize(info[i] as NSString, font: UIFont.systemFont(ofSize: 12), size: CGSize(width: screenWidth - 16*(UIScreen.main.bounds.size.width / 750.0) - 20 - lastX, height: 0))
            if size.height > maxY {
                maxY = size.height
            }
            if i%3 == 0 && i > 0{
                lastX = 0
                lastY = lastY + maxY + 38
                maxY = 0
            }else if i == info.count - 1{
                lastY = lastY + maxY
            }
            lastX = lastX + (screenWidth - 16*(UIScreen.main.bounds.size.width / 750.0) - 20  - 30)/3
        }
        return lastY
    }
    
     //改变图片颜色
    class func changeImageWithColor(_ img:UIImage,color:UIColor) ->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: img.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        context?.clip(to: rect, mask: img.cgImage!)
        color.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
   public class func setCartBadge(_ badge:String){
        try! UserDefaults.standard.set(badge, forKey: "shopbadge")
        let badgeinfo = NSDictionary.init(dictionary: ["badge":badge])
        let notice = Notification.init(name: Notification.Name(rawValue: "setbadge"), object: badgeinfo)
        NotificationCenter.default.post(notice)
    }
    
    class func selectTabbar(_ tag:NSInteger){
        let taginfo = NSDictionary.init(dictionary: ["tag":tag])
        let notice = Notification.init(name: Notification.Name(rawValue: "selecttag"), object: taginfo)
        NotificationCenter.default.post(notice)
    }
    //清楚头像缓存
    class func deleteAvatar(){
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 打印路径,需要测试的可以往这个路径下放东西
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        // 用于统计文件夹内所有文件大小
        _ = Int();
        
        // 快速枚举取出所有文件名
        for p in files!{
            // 把文件名拼接到路径中
            var str = CommonConfig.UserInfoCache.photoUrl
            str = str?.replacingOccurrences(of: "/", with: "%2F")
            str = str?.replacingOccurrences(of: ":", with: "%3A")
            let path = cachePath! + "/\(p)"
            let range = (path as NSString).range(of: str!)
            if range.length > 0 {
//                print("filePath",path)
                // 判断是否可以删除
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: path) {
                    try! fileManager.removeItem(atPath: path)
//                    print("remove path")

                }
            }
        }
        
    }
    
    class func getProductDetail(_ controller:UIViewController,goodsID:String){
        RequestManager.RequestData(RequestUrl.Router.getProduct(id: goodsID),showLoading: true, successCallBack: { (result) in
            
            let goods = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "GoodsDetailViewController") as! GoodsDetailViewController
//            print(result["content"])
            goods.goodsInfo = result["content"]
            goods.goodsID = goodsID

//            if CommonConfig.isLogin == false{
                goods.showQRcodeBtn = false
                controller.navigationController?.pushViewController(goods, animated: true)

//            }else {
//                RequestManager.RequestData(RequestUrl.Router.judgePromoter(userid: CommonConfig.UserInfoCache.userId, token: CommonConfig.Token), successCallBack: { (result) in
////                    print(result)
//
//                    if result["content"]["is_promoter"].boolValue {
//
//                        goods.showQRcodeBtn = false
//                        controller.navigationController?.pushViewController(goods, animated: true)
//                    }else{
//                        goods.showQRcodeBtn = false
//                        controller.navigationController?.pushViewController(goods, animated: true)
//                    }
//
//                }, failCallBack: { (falseStr) in
//                    print("判断是否推广员\(falseStr)")
//
//                })
//            }
    }) { (fail) in
        print("商品信息请求错误\(fail)")
        }
    }
    
    class func getDetailData(_ controller:UIViewController,orderID:String){
        RequestManager.RequestData(RequestUrl.Router.getOrderDetail(id: orderID, user_id: CommonConfig.UserInfoCache.userId), successCallBack: { (result) in
//            print(result)
            let login = UIStoryboard(name: "ShopCart", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailController") as! OrderDetailController
            login.detailInfo = result["content"]
            controller.navigationController?.pushViewController(login, animated: true)
        }) { (fail) in
//            print(fail)
        }
    }

    class func getDoPay(_ controller:UIViewController,order_id:String,order_amount:String,isGoods:Bool = false){
//        if !isGoods {
//            let pay = UPAPayViewController()
//            pay.price = order_amount
//            pay.orderID = order_id
//            pay.userID = String(CommonConfig.UserInfoCache.userId)
//            pay.token = CommonConfig.Token
//            pay.chongzhi = false
//            controller.navigationController?.pushViewController(pay, animated: true)
//        }else{
//            let pay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
//            pay.isPay = true
//            pay.isConfirm = false
//            pay.isSuccess = false
//            pay.isGoods = isGoods
//            pay.order_id = order_id
//            pay.price = order_amount
//            controller.navigationController?.pushViewController(pay, animated: true)
//        }
    }
    
    class func getPolicy(_ userid:NSInteger,type:String,successCallBack: @escaping (JSON)->Void){
        RequestManager.RequestData(RequestUrl.Router.getUpYun(user_id: userid, type: type), successCallBack: { (result
            ) in
//            print(result)
            successCallBack(result)
            }) { (fail) in
//                print(fail)
        }
    }
    //重绘图片
    class func OriginImage(_ image:UIImage, size:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 20)
        image.draw(in: CGRect(x: 0,y: 0, width: size.width, height: size.height))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

//拓展color的初始化方式，添加int型值和16进制初始化
extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int , newAlpha:CGFloat = 1.0)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }
    
    convenience init(hexCode:String, alpha:CGFloat = 1.0){
        let scanner = Scanner(string:hexCode)
        var color:UInt32 = 0;
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

