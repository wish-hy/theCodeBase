//
//  IconFontManager.swift
//  mibo  图片字体管理类
//
//  Created by TeamMac2 on 16/4/18.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//

import Foundation

public enum IconFontIconName:String{
    //主页
    case icon_home_normal = "\u{e624}"
    case icon_home_select = "\u{e625}"
    //分类
    case icon_classify_normal = "\u{e61a}"
    case icon_classify_select = "\u{e62b}"
    //虚拟币   钱袋
    case icon_coin_normal = "\u{e72d}"
    case icon_coin_select = "\u{e6ad}"
    //购物车
    case icon_cart_normal = "\u{e61b}"
    case icon_cart_select = "\u{e73c}"
    case icon_cart_collect = "\u{e631}" //收藏
    case icon_cart_panicbuy = "\u{e63e}" //抢购
    case icon_cart_seletallgoods = "\u{e64c}" //勾
    //我的
    case icon_user_normal = "\u{e628}"
    case icon_user_select = "\u{e629}"
    //搜索
    case icon_search = "\u{e626}"
    //消息
    case icon_msg = "\u{e62a}"
    //圆底
    case icon_circle = "\u{e602}"
    //圆角框
    case icon_square = "\u{e600}"
    //积分专区
    case icon_sale_price = "\u{e72c}"
    //店铺专区
    case icon_points_recharge = "\u{e667}"
    //积分商城
//    case icon_points_shop = "\u{e603}"
    //活色生鲜
//    case icon_fresh_goods = "\u{e60a}"
    //秒杀专区
    case icon_import_food = "\u{e67b}"
    //全部商品
    case icon_health_life = "\u{e690}"
    //微商专区
    case icon_home_life = "\u{e6da}"
    //关于我们
    case icon_about_us = "\u{e634}"
    //返回
    case icon_back = "\u{e61e}"
    //礼品
//    case icon_gift = "\u{e614}"
    //积分记录
    case icon_points_record = "\u{e622}"
    //待付款
    case icon_wait_pay = "\u{e606}"
    //待收货
    case icon_wait_receiving = "\u{e6a3}"
    //待评价
    case icon_wait_evaluate = "\u{e66c}"
    //返修/退换
    case icon_repair_or_replace = "\u{e687}"
    //我的订单
    case icon_my_order = "\u{e6b0}"
    //个人设置
    case icon_user_setting = "\u{e635}"
    //我的地址
    case icon_my_address = "\u{e632}"
    //我的收藏
    case icon_my_collection = "\u{e123}"  //  用不到
    //客服中心
    case icon_customer_service_center = "\u{e633}"
    //热门推荐
//    case icon_hot_recommend = "\u{e62f}"
    //健康水果
//    case icon_health_fruit = "\u{e60b}"
    //绿色蔬菜
//    case icon_green_vegetable = "\u{e62e}"
    //进口酒水
//    case icon_imported_wine = "\u{e62d}"
    //夏日酷饮
//    case icon_cool_drink = "\u{e62c}"
    //商品详情
    case icon_goods_backhome = "\u{e619}"   // 返回主页
    case icon_goods_edit = "\u{e618}"      // 编辑
    case icon_goods_showmore = "\u{e608}"
    case icon_goods_cart_dismiss = "\u{e63d}"    //  叉叉
    
    //pay
    case icon_wechat_pay = "\u{e642}"   // 微信支付
    case icon_alipay = "\u{e63a}"     // 支付宝
    case icon_unipay = "\u{e63b}"     // 银行卡
    case icon_add_newaddresss = "\u{e627}"   // 添加新地址
    case icon_delet_address = "\u{e623}"   // 删除
    //已发货
    case icon_send_goods = "\u{e617}"
    //系统
    case icon_system_message = "\u{e646}"
    //系统消息
    case icon_system_message_1 = "\u{e644}"
    //积分兑换
    case icon_integral_exchange = "\u{e604}"   // 货币兑换
    //眼睛
    case icon_eye = "\u{e639}"
    //微信
    case icon_wechat = "\u{e638}"
    //微博
    case icon_sina = "\u{e637}"
    //qq
    case icon_qq = "\u{e636}"
    //支付方式
    case icon_pay_way = "\u{e607}"  // 银行卡
    //收藏
    case icon_collect = "\u{e60d}"
    case icon_collected = "\u{e60c}"
    //分享
    case icon_share = "\u{e609}"
    //好评星星
    case icon_star_no = "\u{e63c}"
    case icon_star_yes = "\u{e643}"
    //时间
    case icon_time_start = "\u{e648}"
    //二维码
    case icon_qrcode = "\u{e656}"
    case icon_qrcode2 = "\u{e700}"
    case icon_homepage = "\u{e668}"
    
}


//拓展iconfont UILabel
extension UILabel{
    convenience init(iconName:IconFontIconName){
        self.init(frame: CGRect.zero)
        
        self.font = UIFont(name: "iconfont", size: 25)
        self.text = iconName.rawValue
    }
    
    func setIconFont(_ iconName:IconFontIconName){
        self.text = iconName.rawValue
    }
    
}
//拓展iconfont UIButton
extension UIButton{
    convenience init(iconName:IconFontIconName, fontSize:CGFloat = 25, normalColor:UIColor = UIColor.white, highlightColor:UIColor = UIColor(hexCode: "ff7d21")){
        self.init(frame:CGRect.zero)
        
        self.titleLabel?.font = UIFont(name: "iconfont", size: fontSize)
        self.setTitle(iconName.rawValue, for: UIControlState())
        self.setTitleColor(normalColor, for: UIControlState())
        self.setTitleColor(highlightColor, for: UIControlState.highlighted)
    }
    //storyboard 的调用该方法
    func setIconFont(_ iconName:IconFontIconName, normalColor:UIColor = UIColor.white, highlightColor:UIColor = UIColor(hexCode: "ff7d21")){
        self.setTitle(iconName.rawValue, for: UIControlState())
        self.setTitle(iconName.rawValue, for: UIControlState.selected)
        self.setTitleColor(normalColor, for: UIControlState())
        self.setTitleColor(highlightColor, for: UIControlState.highlighted)
    }
    
}
