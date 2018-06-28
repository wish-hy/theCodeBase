//
//  RequestUrl.swift
//  mibo
//
//  Created by TeamMac on 16/1/18.
//  Copyright © 2016年 heju. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


//构造请求url
struct RequestUrl {

    static let mainUrl = "http://www.ymlypt.com"
    static let appKey = "ajsO4jnlkIVjf2taQWEQWdfgfh=="
    //签名用到的randomKey
    static let randomKey = "123456"
//    static var session_id = ""
    static var session_id = MyManager.shared().sessionid
//    前缀URL：

//    请求方式：
//    code={参数名1:参数值1,参数名2:参数值2...}
//    sign=签名值
//    有session_id就需要传，初始化接口获得
//    session_id=
//    签名值运算方式为:md5(md5(替换上面的code)123456)
//    返回值为{code:0,content:响应数据,message:错误详情}，code为0时表示成功，其它均为失败

    enum Router: URLRequestConvertible {
        /// Returns a URL request or throws if an `Error` was encountered.
        ///
        /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
        ///
        /// - returns: A URL request.
        func asURLRequest() throws -> URLRequest {
            return self.URLRequest as URLRequest
        }

        case bootStrap(version:String) //初始化 获取session_id
        case register(validCode:NSInteger, password:String, mobile:String,zone:NSInteger)//手机注册接口
        case userLogin(account:String, password:String)//用户登陆
        case userThirdLogin(platform:String, openid:String)//第三方登陆
        case getBanner(bussType:String)//根据类型获取轮播图片
        case getScreen()  //获取闪屏
        case verifyPhone(openid:String, platform:String, mobile:String, code:NSInteger, password:String,zone:NSInteger,nickname:String,head:String) //绑定手机 /**0-手机注册；weixin-微信；qq-QQ；sina-微博；**/
        case logOut(userid:Int) //退出登录
        case appleNotify(payNum:String,bak:String,appleValidType:String)//苹果支付回调验证 appleValidType;1-测试环境；2-生产环境
        case saveNickName(new:String,user_id:NSInteger)     //修改昵称
        case getUserInfo(user_id:NSInteger,token:String)                //获取用户信息
        case resetLoginpwd(userid:NSInteger,oldpassword:String,newpassword1:String,newpassword2:String)  //修改密码
        case forgetLoginpwd(code:NSInteger,mobile:String,newpassword:String,zone:NSInteger)           //忘记密码
        case getHomePage()  //首页数据
        case getIntegral(page:NSInteger)  //!<积分购数据
        case getAdvert()
        case getReferGoods(page:NSInteger)
        case getProduct(id:String) //商品数据
        case getCategory()  //分类列表
        case getHotSearch() //热门搜索
        case search(cid:String,sort:NSInteger,p:NSInteger,price:String,keyword:String,brand:String,cat:String)       //搜索列表   page 页数 默认每页36条  sort 排序  cid  分类id  price  价格区间 0-100 keyword   关键词     sort 0.默认 1. 销量降序  2.评论降序   4.价格升序  3.价格降序  5.时间排序
        case getHuabi(user_id:NSInteger)     //华币积分
        case getHuabiBanner()           //华币积分轮播图
        case getHuabiLog(page:NSInteger,type:String,user_id:NSInteger) //type   in获得  out支出  all获得全部 page 页数
        case getGuess(num:NSInteger)    //购物车推荐  num 最多50
        case getCartNum()       //购物车列表
        case addGoods(id:String,num:NSInteger)    //添加商品
        case addGoodsTwo(id:String,num:NSInteger)    //添加商品 直接购买
        case changeGoodsNum(id:String,num:NSInteger,user_id:NSInteger)   //改变商品数量
        case deleteGoods(id:String) //删除商品
        case orderConfirm(selectids:NSArray,user_id:NSInteger,cart_type:String) //结算商品
        case getAddressList(id:NSInteger)  //地址列表
        case addressSave(accept_name:String,zip:String,mobile:String,user_id:NSInteger,addr:String,address:String,province:String,city:String,county:String,is_default:NSInteger,id:String)      //保存地址
        case deleteAddress(id:String,user_id:NSInteger)   //删除地址
        case addCollect(id:String,user_id:NSInteger)   //添加收藏
        case delCollect(id:String,user_id:NSInteger)    //删除收藏
        case orderCalculateFare(addrid:NSInteger,weight:CGFloat,product:[String:String] ,user_id:NSInteger)
        case orderSubmit(user_id:NSInteger,selectids:Array<String>,address_id:NSInteger,payment_id:NSInteger,prom_id:String,is_invoice:String,invoice_type:String,user_remark:String,voucher:String,cart_type:String)  //下订单
        case checkCollect(goods_id:String)  //是否收藏
        case getCollect(user_id:NSInteger,page:NSInteger)  //我的收藏
        case getCommentReview(id:String,score:String,page:NSInteger,pagetype:NSInteger)     //pagetype 默认1  score  a 好评 b 中评 c 差评 空 全部
        case getFlashLeft(page:NSInteger)  //立即抢购
        case getFlashRight(page:NSInteger)  //即将开始
        case wantFlash(id:String,user_id:NSInteger) //想要
        case flashDetail(id:String) //普通抢购详情
        case pointDetail(id:String) //积分抢购详情
        case getMyOrderList(status:String,page:NSInteger,user_id:NSInteger)   //status  all 所有订单  unpay  未支付订单  undelivery  未发货订单  unreceived  未收货订单
        case getOrderDetail(id:String,user_id:NSInteger)  //订单详情
        case orderSign(id:String,user_id:NSInteger)  //订单收货
        case dopay(order_id:String,payment_id:String,user_id:NSInteger)    //发起支付
        case paybalance(order_no:String,total_fee:String,user_id:NSInteger,pay_password:String)     //余额支付
        case checkVerifyPass(userid:NSInteger)      //查看是否设置了支付密码
        case getMyReview(status:String,page:NSInteger,userid:NSInteger)  //查看评论 status  unreview：未评论  reviewed：已评论  all：全部
        case postReview(id:String,good_id:String,point:NSInteger,content:String,userid:NSInteger)  //提交评价 id 传review的id goods_id  传商品id point 评分 content 评价内容
        case saleSupport(user_id:NSInteger,type:NSInteger,num:NSInteger,desc:String,proof:NSInteger,province:String,city:String,county:String,receiver:String,addr:String,mobile:String,id:String)  //申请售后
        case getUpYun(user_id:NSInteger,type:String)    //获取图片上传的签名许可   头像 avatar  售后 support
        case sendComplaint(user_id:NSInteger,type:NSInteger,content:String,mobile:String)  //在线投诉 参数 type   投诉类型 1：商品投诉 2：物流投诉 3：其他
        case getMessage(type:String,status:String,user_id:NSInteger,page:NSInteger) //参数type  类型 system系统群发消息only 系统单发消息 all 全部   status 状态  readed 已读 unread 未读  all         全部
        case getOrderBadge(user_id:NSInteger)       //订单角标
        case getPaytypeList(user_id:NSInteger,platform:String)  //获取支付列表
        case getHuaBiRecommend()//华币专区推荐
        case getHuaBiGoods(page:NSInteger)//华币专区超值
        case getOrderexpress(userid:NSInteger,type:NSString,orderNo:NSString)//物流
        case getexpressDetail(userid:NSInteger,orderid:NSString)//物流详情
        case chongzhi(order_id:String,payment_id:String,user_id:NSInteger,recharge:String)//充值
        case exchange(user_id:NSInteger,token:NSString,gold:NSString)//兑换
        case getvillageList(userid:NSInteger,token:String)//获取专区列表
        case getQRCode(userid:NSInteger,token:String,goodsID:String)//获取商品二维码地址
        case nojudgePromoter()//不是推广员
        case judgePromoter(userid:NSInteger,token:String)//判断是否是推广员
        case judgeCommission(userid:NSInteger,token:String)//判断是否显示我的佣金页面
        case getIntegralDetail(id:String) //积分购物详情
        case getVIPProduct(id:String) //VIP商品数据
        case loadWeiShang(page:NSInteger)     //加载微商专区的商品
        case settingpaypwd(code:NSInteger,mobile:String,newpassword:String,zone:NSInteger,user_id:NSInteger , token:String)      //设置支付密码
        case resettingpaypwd(code:NSInteger,mobile:String,newpassword:String,zone:NSInteger,user_id:NSInteger , token:String)      //设置支付密码
        
        var URLRequest: NSMutableURLRequest  {
            var path:String
            let imei = UIDevice.current.identifierForVendor?.uuidString
            let device = UIDevice.current.name
            let timestamp = CommonConfig.getNowTime("yyyy-MM-dd HH:mm:ss.SSS", isNeed: true)
            var parameters: [String:AnyObject] = [:]
            var fullParameters: [String:Any] = [:]
            var needSign:Bool = true
            var needToken:Bool = true
            //签名
            func sign(_ parameters: inout [String: AnyObject]) -> String {
                var signData:String = ""
                for key in parameters.keys.sorted(by: <) {
                    let value = parameters[key]!
                    if String(describing: value).isEmpty{
                        parameters.removeValue(forKey: key)
                    }else{
                  
                        let newValue = String(describing: value).replacingOccurrences(of: " ", with: "")
                        let cleanSpaceValue = Alamofire.URLEncoding.default.escape(newValue)
                        signData += "\(key)=\(cleanSpaceValue)"
                    }
                }
                signData += RequestUrl.appKey
                signData = signData + RequestUrl.randomKey
                signData = signData.MD5()
                return signData
            }
            
            switch self {
                
            case .bootStrap(let version):
                path = "/v1/bootstrap"
                parameters["version"] = version as AnyObject
                needToken = false
            case .register(let validCode, let password, let mobile, let zone):
                path = "/v1/signup"
                parameters["mobile_code"] = validCode as AnyObject
                parameters["password"] = password as AnyObject
                parameters["mobile"] = mobile as AnyObject
                parameters["zone"] = zone as AnyObject
                needToken = false
            case .userLogin(let account, let password):
                path = "/v1/login"
                parameters["password"] = password as AnyObject
                parameters["account"] = account as AnyObject
                needToken = false
            case .userThirdLogin(let platform, let openid):
                path = "/v1/thirdlogin"
                parameters["platform"] = platform as AnyObject
                parameters["openid"] = openid as AnyObject
                needToken = false
            case .getBanner(let bussType):
                path = "/v1/banner"
                parameters["bussType"] = bussType as AnyObject
            case .getScreen():
                path = "/v1/getscreen"
                needToken = false
            case .verifyPhone(let openid,let platform,let mobile,let code,let password,let zone,let nickname,let head):
                path = "/v1/thirdbind"
                parameters["openid"] = openid as AnyObject
                parameters["platform"] = platform as AnyObject
                parameters["mobile"] = mobile as AnyObject
                parameters["code"] = code as AnyObject
                parameters["password"] = password as AnyObject
                parameters["zone"] = zone as AnyObject
                parameters["nickname"] = nickname as AnyObject
                parameters["head"] = head as AnyObject
                needToken = true
            case .logOut(let userid):
                path = "/v1/andorid_logout"
                parameters["user_id"] = userid as AnyObject
                needToken = true
            case .appleNotify(let payNum, let bak, let appleValidType):
                path = "/v1/apple_notify"
                parameters["orderNum"] = payNum as AnyObject
                parameters["appleValidType"] = appleValidType as AnyObject
                parameters["bak"] = bak as AnyObject
                needToken = true
            case .saveNickName(let new,let user_id):
                path = "/v1/set_nickname"
                parameters["new"] = new as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .getUserInfo(let user_id,let token):
                path = "/v1/userinfo"
                parameters["user_id"] = user_id as AnyObject
                parameters["token"] = token as AnyObject
                needToken = true
            case .resetLoginpwd(let userid,let oldpassword,let newpassword1,let newpassword2):
                path = "/v1/reset_loginpwd"
                parameters["user_id"] = userid as AnyObject
                parameters["oldpassword"] = oldpassword as AnyObject
                parameters["newpassword1"] = newpassword1 as AnyObject
                parameters["newpassword2"] = newpassword2 as AnyObject
                needToken = true
            case .forgetLoginpwd(let code,let mobile,let newpassword, let zone):
                path = "/v1/forget_loginpwd"
                parameters["code"] = code as AnyObject
                parameters["mobile"] = mobile as AnyObject
                parameters["newpassword"] = newpassword as AnyObject
                parameters["zone"] = zone as AnyObject
                needToken = true
            case .getHomePage():
                path = "/v1/index"
                needToken = false
            case .getIntegral(let page):
                path = "/v1/point_sale"
                needToken = false
                parameters["page"] = page as AnyObject
            case .getAdvert():
                path = "/v1/get_index_ad"
                needToken = false
            case .getReferGoods(let page):
                path = "/v1/index_goods"
                parameters["page"] = page as AnyObject
                needToken = true
            case .getProduct(let id):
                path = "/v1/product"
                parameters["id"] = id as AnyObject
                needToken = false
            case .getCategory():
                path = "/v1/get_category"
                needToken = false
            case .search(let cid,let sort,let p, let price, let keyword, let brand , let cat):
                path = "/v1/search"
                parameters["cid"] = cid as AnyObject
                parameters["sort"] = sort as AnyObject
                parameters["p"] = p as AnyObject
                parameters["price"] = price as AnyObject
                parameters["brand"] = brand as AnyObject
                parameters["keyword"] = keyword as AnyObject
                parameters["act"] = cat as AnyObject
                needToken = false
            case .getHotSearch():
                path = "/v1/get_hot"
                needToken = false
            case .getHuabi(let user_id):
                path = "/v1/huabi"
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .getHuabiBanner():
                path = "/v1/bp_banner"
                needToken = false
            case .getHuabiLog(let page,let type,let user_id):
                path = "/v1/huabi_log"
                parameters["user_id"] = user_id as AnyObject
                parameters["page"] = page as AnyObject
                parameters["type"] = type as AnyObject
                needToken = true
            case .getGuess(let num):
                path = "/v1/guess"
                parameters["num"] = num as AnyObject
                needToken = true
            case .getCartNum():
                path = "/v1/cart_num"
                if CommonConfig.isLogin {
                    parameters["user_id"] = CommonConfig.UserInfoCache.userId as AnyObject
                }
                needToken = true
            case .addGoods(let id, let num):
                path = "/v1/cart_add"
                parameters["id"] = id as AnyObject
                parameters["num"] = num as AnyObject
                if CommonConfig.isLogin {
                    parameters["user_id"] = CommonConfig.UserInfoCache.userId as AnyObject
                }
                needToken = true
            case .addGoodsTwo(let id, let num):
                path = "/v1/goods_add"
                parameters["id"] = id as AnyObject
                parameters["num"] = num as AnyObject
                if CommonConfig.isLogin {
                    parameters["user_id"] = CommonConfig.UserInfoCache.userId as AnyObject
                }
                needToken = true
                
            case .changeGoodsNum(let id, let num,let user_id):
                path = "/v1/cart_num"
                parameters["id"] = id as AnyObject
                parameters["num"] = num as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .deleteGoods(let id):
                path = "/v1/cart_del"
                parameters["id"] = id as AnyObject
                if CommonConfig.isLogin {
                    parameters["user_id"] = CommonConfig.UserInfoCache.userId as AnyObject
                }
                needToken = true
            case .orderConfirm(let selectids,let user_id,let cart_type):
                path = "/v1/order_confirm"
                if cart_type != "goods" {
                    parameters["selectids"] = selectids
                }else{
                    parameters["cart_type"] = cart_type as AnyObject
                }
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .getAddressList(let id):
                path = "/v1/address_list"
                parameters["user_id"] = id as AnyObject
                needToken = true
            case .addressSave(let accept_name,let zip,let mobile,let user_id,let addr,let address,let province,let city,let county,let is_default, let id):
                path = "/v1/address_save"
                parameters["accept_name"] = accept_name as AnyObject
                parameters["zip"] = zip as AnyObject
                parameters["mobile"] = mobile as AnyObject
                parameters["user_id"] = user_id as AnyObject
                parameters["addr"] = addr as AnyObject
                parameters["address"] = address as AnyObject
                parameters["province"] = province as AnyObject
                parameters["city"] = city as AnyObject
                parameters["county"] = county as AnyObject
                parameters["is_default"] = is_default as AnyObject
                parameters["id"] = id as AnyObject
                needToken = true
            case .deleteAddress(let id,let user_id):
                path = "/v1/address_del"
                parameters["id"] = id as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .addCollect(let id,let user_id):
                path = "/v1/add_collect"
                parameters["goods_id"] = id as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .delCollect(let id,let user_id):
                path = "/v1/del_collect"
                parameters["goods_id"] = id as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .checkCollect(let id):
                path = "/v1/is_collected"
                parameters["goods_id"] = id as AnyObject
                if CommonConfig.isLogin {
                    parameters["user_id"] = CommonConfig.UserInfoCache.userId as AnyObject
                }
                needToken = true
            case .getCollect(let user_id,let page):
                path = "/v1/get_collect"
                parameters["user_id"] = user_id as AnyObject
                parameters["page"] = page as AnyObject
                needToken = true
            case .orderCalculateFare(let addrid,let weight,let product,let user_id):
                path = "/v1/order_calculate_fare"
                parameters["id"] = addrid as AnyObject
                parameters["weight"] = weight as AnyObject
                parameters["product"] = product as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .orderSubmit(let user_id,let selectids ,let address_id ,let payment_id ,let prom_id,let is_invoice,let invoice_type,let user_remark,let voucher,let cart_type):
                path = "/v1/order_submit"
                parameters["user_id"] = user_id as AnyObject
                if cart_type != "goods" {
                    parameters["selectids"] = selectids as AnyObject
                }
                parameters["address_id"] = address_id as AnyObject
                if is_invoice != "" {
                    parameters["is_invoice"] = is_invoice as AnyObject
                }
                if voucher != "" {
                    parameters["voucher"] = voucher as AnyObject
                }
                if prom_id != "" {
                    parameters["prom_id"] = prom_id as AnyObject
                }
                parameters["payment_id"] = payment_id as AnyObject
                if user_remark != "" {
                    parameters["user_remark"] = user_remark as AnyObject
                }
                if invoice_type != "" {
                    parameters["invoice_type"] = invoice_type as AnyObject
                }
                if cart_type != "" {
                  parameters["cart_type"] = cart_type as AnyObject
                }
                needToken = true
            case .getCommentReview(let id,let score,let page,let pagetype):
                path = "/v1/get_review"
                parameters["id"] = id as AnyObject
                parameters["score"] = score as AnyObject
                parameters["page"] = page as AnyObject
                parameters["pagetype"] = pagetype as AnyObject
                needToken = true
            case .getFlashLeft(let page):
                path = "/v1/flash"
                parameters["page"] = page as AnyObject
                needToken = false
            case .getFlashRight(let page):
                path = "/v1/next_flash"
                parameters["page"] = page as AnyObject
                needToken = false
            case .wantFlash(let id,let user_id):
                path = "/v1/want"
                parameters["id"] = id as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .flashDetail(let id):
                path = "/v1/flashbuy"
                parameters["id"] = id as AnyObject
                needToken = true
            case .pointDetail(let id):
                path = "/v1/pointflash"
                parameters["id"] = id as AnyObject
                needToken = true
            case .getMyOrderList(let status,let page,let user_id):
                path = "/v1/order"
                parameters["status"] = status as AnyObject
                parameters["page"] = page as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .getOrderDetail(let id,let user_id):
                path = "/v1/order_detail"
                parameters["id"] = id as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .orderSign(let id,let user_id):
                path = "/v1/order_sign"
                parameters["id"] = id as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .dopay(let order_id,let payment_id,let user_id):
                path = "/v1/dopay"
                parameters["order_id"] = order_id as AnyObject
                parameters["payment_id"] = payment_id as AnyObject
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .paybalance(let order_no,let total_fee,let user_id,let pay_password):
                path = "/v1/pay_balance"
                parameters["order_no"] = order_no as AnyObject
                parameters["total_fee"] = total_fee as AnyObject
                parameters["user_id"] = user_id as AnyObject
                parameters["pay_password"] = pay_password as AnyObject
                needToken = true
            case .checkVerifyPass(let userid):
                path = "/v1/check_verify"
                parameters["user_id"] = userid as AnyObject
                needToken = true
            case .getMyReview(let status,let page,let userid):
                path = "/v1/my_review"
                parameters["status"] = status as AnyObject
                parameters["page"] = page as AnyObject
                parameters["user_id"] = userid as AnyObject
                needToken = true
            case .postReview(let id,let good_id,let point,let content,let userid):
                path = "/v1/post_review"
                parameters["id"] = id as AnyObject
                parameters["good_id"] = good_id as AnyObject
                parameters["point"] = point as AnyObject
                parameters["content"] = content as AnyObject
                parameters["user_id"] = userid as AnyObject
                needToken = true
            case .saleSupport(let user_id,let type,let num,let desc,let proof,let province,let city,let county,let receiver,let addr,let mobile,let id):
                path = "/v1/sale_support"
                parameters["user_id"] = user_id as AnyObject
                parameters["type"] = type as AnyObject
                parameters["num"] = num as AnyObject
                parameters["desc"] = desc as AnyObject
                parameters["proof"] = proof as AnyObject
                parameters["province"] = province as AnyObject
                parameters["city"] = city as AnyObject
                parameters["county"] = county as AnyObject
                parameters["receiver"] = receiver as AnyObject
                parameters["addr"] = addr as AnyObject
                parameters["mobile"] = mobile as AnyObject
                parameters["id"] = id as AnyObject
                needToken = true
            case .getUpYun(let user_id,let type):
                path = "/v1/get_upyun"
                parameters["user_id"] = user_id as AnyObject
                parameters["type"] = type as AnyObject
                needToken = true
            case .sendComplaint(let user_id,let type,let content,let mobile):
                path = "/v1/complaint"
                parameters["user_id"] = user_id as AnyObject
                parameters["type"] = type as AnyObject
                parameters["content"] = content as AnyObject
                parameters["mobile"] = mobile as AnyObject
                needToken = true
            case .getMessage(let type,let status,let user_id,let page):
                path = "/v1/get_message"
                parameters["type"] = type as AnyObject
                parameters["status"] = status as AnyObject
                parameters["user_id"] = user_id as AnyObject
                parameters["page"] = page as AnyObject
                needToken = true
            case .getOrderBadge(let user_id):
                path = "/v1/badge"
                parameters["user_id"] = user_id as AnyObject
                needToken = true
            case .getPaytypeList(let user_id,let platform):
                path = "/v1/paytype_list"
                parameters["user_id"] = user_id as AnyObject
                parameters["platform"] = platform as AnyObject
                needToken = true
            case .getHuaBiRecommend():
                path = "/v1/huabipage_recommend"
                needToken = false
            case .getHuaBiGoods(let page):
                path = "/v1/huabipage_goods"
                parameters["page"] = page as AnyObject
                needToken = false
            case .getOrderexpress(let userid,let type,let orderNo):
                path = "/v1/order_express"
                parameters["user_id"] = userid as AnyObject
                parameters["type"] = type
                parameters["no"] = orderNo
                needToken = true
            case .getexpressDetail(let userid,let orderid):
                path = "/v1/order_express_detail"
                parameters["user_id"] = userid as AnyObject
                parameters["id"] = orderid
                needToken = true
            case .chongzhi(let order_id,let payment_id,let user_id,let recharge):
                path = "/v1/dopay"
                parameters["order_id"] = order_id as AnyObject
                parameters["payment_id"] = payment_id as AnyObject
                parameters["user_id"] = user_id as AnyObject
                parameters["recharge"] = recharge as AnyObject
                needToken = true
            case .exchange(let user_id,let token,let gold):
                path = "/v1/gold_to_silver"
                parameters["user_id"] = user_id as AnyObject
                parameters["token"] = token
                parameters["gold"] = gold
            case .getvillageList(let user_id,let tokenS):
                path = "/v1/get_district_list"
                parameters["user_id"] = user_id as AnyObject
                parameters["token"] = tokenS as AnyObject
            case .getQRCode(let user_id,let tokenS,let goods_id):
                path = "/v1/get_qrcode_flag_by_goods_id"
                parameters["user_id"] = user_id as AnyObject
                parameters["token"] = tokenS as AnyObject
                parameters["goods_id"] = goods_id as AnyObject
            case.nojudgePromoter():
                path = "/v1/isDistrictPromoter"
            case .judgePromoter(let user_id,let tokenS):
                path = "/v1/isDistrictPromoter"
                parameters["user_id"] = user_id as AnyObject
                parameters["token"] = tokenS as AnyObject
            case .judgeCommission(let user_id,let tokenS):
                path = "/v1/my_commission"
                parameters["user_id"] = user_id as AnyObject
                parameters["token"] = tokenS as AnyObject
            case .getIntegralDetail(let id):
                path = "/v1/pointbuy"
                parameters["id"] = id as AnyObject
            case .getVIPProduct(let goodsID):
                path = "/v1/package_info"
                parameters["pid"] = goodsID as AnyObject
                
            case .loadWeiShang(let page):
                path = "/v1/weishang"
                parameters["page"] = page as AnyObject
            case .settingpaypwd(let code, let mobile, let newpassword, let zone , let user_id , let token):
                path = "/v1/reset_paypwd"
                parameters["user_id"] = user_id as AnyObject
                parameters["token"] = token as AnyObject
                parameters["pay_pwd"] = newpassword as AnyObject
                parameters["code"] = code as AnyObject
                parameters["zone"] = zone as AnyObject
            case .resettingpaypwd(let code, let mobile, let newpassword, let zone, let user_id, let token):
                path = "/v1/reset_paypwd"
                parameters["user_id"] = user_id as AnyObject
                parameters["token"] = token as AnyObject
                parameters["pay_pwd"] = newpassword as AnyObject
                parameters["code"] = code as AnyObject
                parameters["zone"] = zone as AnyObject
            }
            
         
            if RequestUrl.session_id != "" {
                needToken = true
                fullParameters["session_id"] = RequestUrl.session_id as AnyObject
            }else{
                needToken = false
            }
            if needToken{
                parameters["token"] = CommonConfig.Token as AnyObject
            }
            if needSign{
                if parameters.count > 0 {
                    fullParameters["code"] = String.init(MySDKHelper.toJSONData(parameters)) as AnyObject
                    fullParameters["sign"] = sign(&parameters) as AnyObject
                }
            }
//            print(fullParameters)
            let URL = Foundation.URL(string: RequestUrl.mainUrl)
  
            let URLRequest = Foundation.URLRequest(url: URL!.appendingPathComponent(path))
            let encoding = Alamofire.URLEncoding.default
            do{
                let result = try encoding.encode(URLRequest, with: fullParameters)
                return result as! NSMutableURLRequest
            }catch{
                return NSMutableURLRequest()
            }
//            return encoding.encode(URLRequest, with: fullParameters)
//            print(encoding.encode(URLRequest, parameters: fullParameters).0.URLString)
//            let parmetersDic:NSDictionary = fullParameters as NSDictionary
            
//            return encoding.encode(URLRequest, with:fullParameters).0
        }
    }
    
}

class RequestManager {
    
    //请求数据主接口，主要过滤token和错误信息
    class func RequestData(_ url:URLRequestConvertible, showLoading:Bool = false, successCallBack: @escaping (JSON)->Void, failCallBack: @escaping (String)->Void){
    
        if showLoading{
            SwiftNotice.wait()
        }
        print(url)
        Alamofire.request(url).responseJSON {
            response in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let resultJson = JSON(value)
                    //                    print(resultJson)
                    if resultJson["code"].intValue != 0{
                        if showLoading{
                            SwiftNotice.clear()
                        }
                        print(resultJson)
                        if resultJson["code"].stringValue == "545" {//token失效，请重新登录！
                            AutoLogin({loginResult in
                                if loginResult {
                                    print("autoLoginSuccess")
                                    RequestData(url, successCallBack: successCallBack, failCallBack:  failCallBack)
                                }
                            })
                        }else{
                            failCallBack(resultJson["message"].stringValue)
                        }
                    }else{
                        successCallBack(resultJson)
                        if showLoading{
                            SwiftNotice.clear()
                        }
                    }
                }else{
                    if showLoading{
                        SwiftNotice.clear()
                    }
                    print("value error")
                    failCallBack("数据为空")
                }
            }else{
                if showLoading{
                    SwiftNotice.clear()
                }
//                print(response.result.error)
                failCallBack("1000")
                
            }
        }
            .responseString(encoding: String.Encoding.utf8){
                str in
//                print("responseString")
//                print(str)
                
                
        }
    }
    
    //自动登录
    class func AutoLogin(_ loginCallBack: @escaping (Bool)->Void) {
        let raw:Data = UserDefaults.standard.object(forKey: "UserInfo") as! Data
        let userInfo = try! JSON(data: raw)
        
        CommonConfig.UserInfoCache = UserInfoModel(userInfo: userInfo)
        Alamofire.request(RequestUrl.Router.userLogin(account: CommonConfig.UserInfoCache.account, password: CommonConfig.UserInfoCache.password)).responseJSON{
            response in
            if response.result.isSuccess {
                guard let resultData = response.result.value else { return }
                let resultJson:JSON = JSON(resultData)
            
                if resultJson["code"].intValue == 0 {
                    var detail = resultJson["content"]
                    CommonConfig.Token = detail["token"].stringValue
                    RequestManager.RequestData(RequestUrl.Router.getUserInfo(user_id: CommonConfig.UserInfoCache.userId,token: CommonConfig.Token), successCallBack: { (result) in
                    
                        detail = result["content"]["userinfo"]
                        detail["password"].stringValue = CommonConfig.UserInfoCache.password
                        detail["otherType"].stringValue = CommonConfig.UserInfoCache.otherType
                        detail["account"].stringValue = CommonConfig.UserInfoCache.account
//                        let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
//                        NotificationCenter.default.post(name: notificationName, object: self)
                        
                         JPUSHService.setAlias(detail["user_id"].stringValue, callbackSelector: nil, object: self)
                        CommonConfig.setLoginSuccessInfo(detail)
                        loginCallBack(true)
                        }, failCallBack: { (fail) in
                        UserDefaults.standard.set(false, forKey: "IsLogin")
                        loginCallBack(false)
                    })
                    
                }else{
                    UserDefaults.standard.set(false, forKey: "IsLogin")
                    loginCallBack(false)
                }
            }else{
                UserDefaults.standard.set(false, forKey: "IsLogin")
                loginCallBack(false)
            }
        }
    }
    
    //上传文件
    class func UploadFile(_ imageData:Data, name:String, policy:String = "", signature:String = "",successCallBack: @escaping (JSON)->Void, failCallBack: @escaping (String)->Void){
//        let URL = NSURL(string: RequestUrl.mainUrl)
//        let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent("/v1/set_avatar"))
//        let URLRequest = Foundation.URLRequest(url: URL(string: CommonConfig.UploadURL)!)
        
        Alamofire.upload(
            
            multipartFormData: { multipartFormData in
                multipartFormData.append( imageData, withName: "file", fileName: name, mimeType: "image/png")
                multipartFormData.append( policy.data(using: String.Encoding.utf8)!, withName: "policy")
                multipartFormData.append( signature.data(using: String.Encoding.utf8)!, withName: "signature")
                let dataStr = "\(CommonConfig.UserInfoCache.userId)"
                multipartFormData.append( dataStr.data(using: String.Encoding.utf8)!, withName: "user_id")
                multipartFormData.append( CommonConfig.Token.data(using: String.Encoding.utf8)!, withName: "token")
        },
            to:CommonConfig.UploadURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        if let value = response.result.value {
                            let resultJson = JSON(value)
                            successCallBack(resultJson)
                        }else{
                            print("value error")
                            failCallBack("valueError")
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    failCallBack("resultError")
                }
        }
        )
    
}

}
