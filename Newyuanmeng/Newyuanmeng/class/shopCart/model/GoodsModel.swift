//
//  GoodsModel.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/27.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

open class GoodsModel: NSObject {
    
    var id:String!                  //抢购的id，在生成抢购的订单时需要
    var title:String!               //
    var tag:String!                 //
    var max_num:String!             //参与抢购的物品数量
    var quota_num:String!           //每人可抢购的最大数量
    var price:String!               //抢购价
    var goods_id:String!            //商品id
    var descriptions: String!       //商品描述
    var start_time:String!          //开始时间
    var end_time:String!            //结束时间
    var goods_num:String!           //剩余数
    var order_num:String!           //已生成订单数
    var is_end:String!              //是否结束的标志 0 未结束  1已结束
    var wants:String!               //
    var wants_num:String!           //想要抢购该物品的人数
    var name:String!                //商品名
    var subtitle:String!            //副标题
    var category_id:String!         //所属分类id
    var goods_no:String!            //
    var pro_no:String!              //
    var type_id:String!             //
    var brand_id:String!            //
    var unit:String!                //
    var img:String!                 //图片地址
    var imgs:Array<JSON> = []       //
    var tag_ids:String!             //
    var sell_price:String!          //
    var market_price:String!        //
    var cost_price:String!          //
    var create_time:String!         //
    var store_nums:String!          //
    var warning_line:String!        //
    var seo_title:String!           //
    var seo_keywords:String!        //
    var seo_description:String!     //
    var weight:String!              //
    var point:String!               //
    var visit:String!               //
    var favorite:String!            //
    var sort:String!                //
    var attrs:String!               //
    var prom_id:String!             //
    var is_online:String!           //
    var sale_protection:String!     //
    var review_count:String!        //
    var satisfaction_rate:String!   //
    var freeshipping:String!        //
    var flash_type:String!          // 是否积分抢购
    var cost_point:String!
    
    
    init(goodsInfo:JSON){
        
        self.id = goodsInfo["id"].stringValue
        self.title = goodsInfo["title"].stringValue
        self.tag = goodsInfo["tag"].stringValue
        self.max_num = goodsInfo["max_num"].stringValue
        self.quota_num = goodsInfo["quota_num"].stringValue
        self.price = goodsInfo["price"].stringValue
        self.goods_id = goodsInfo["goods_id"].stringValue
        self.descriptions = goodsInfo["description"].stringValue
        self.start_time = goodsInfo["start_time"].stringValue
        self.end_time = goodsInfo["end_time"].stringValue
        self.goods_num = goodsInfo["goods_num"].stringValue
        self.order_num = goodsInfo["order_num"].stringValue
        self.is_end = goodsInfo["is_end"].stringValue
        self.wants = goodsInfo["wants"].stringValue
        self.wants_num = goodsInfo["wants_num"].stringValue
        self.name = goodsInfo["name"].stringValue
        self.subtitle = goodsInfo["subtitle"].stringValue
        self.category_id = goodsInfo["category_id"].stringValue
        self.goods_no = goodsInfo["goods_no"].stringValue
        self.pro_no = goodsInfo["pro_no"].stringValue
        self.type_id = goodsInfo["type_id"].stringValue
        self.brand_id = goodsInfo["brand_id"].stringValue
        self.unit = goodsInfo["unit"].stringValue
        self.img = goodsInfo["img"].stringValue
        self.imgs = goodsInfo["imgs"].arrayValue
        self.tag_ids = goodsInfo["tag_ids"].stringValue
        self.sell_price = goodsInfo["sell_price"].stringValue
        self.market_price = goodsInfo["market_price"].stringValue
        self.cost_price = goodsInfo["cost_price"].stringValue
        self.create_time = goodsInfo["create_time"].stringValue
        self.store_nums = goodsInfo["store_nums"].stringValue
        self.warning_line = goodsInfo["warning_line"].stringValue
        self.seo_title = goodsInfo["seo_title"].stringValue
        self.seo_keywords = goodsInfo["seo_keywords"].stringValue
        self.seo_description = goodsInfo["seo_description"].stringValue
        self.weight = goodsInfo["weight"].stringValue
        self.point = goodsInfo["point"].stringValue
        self.visit = goodsInfo["visit"].stringValue
        self.favorite = goodsInfo["favorite"].stringValue
        self.sort = goodsInfo["sort"].stringValue
        self.attrs = goodsInfo["attrs"].stringValue
        self.prom_id = goodsInfo["prom_id"].stringValue
        self.is_online = goodsInfo["is_online"].stringValue
        self.sale_protection = goodsInfo["sale_protection"].stringValue
        self.review_count = goodsInfo["review_count"].stringValue
        let rate = goodsInfo["satisfaction_rate"].floatValue * 100
        self.satisfaction_rate = "\(rate)%"
        self.freeshipping = goodsInfo["freeshipping"].stringValue
        self.flash_type = goodsInfo["flash_type"].stringValue
        self.cost_point = goodsInfo["cost_point"].stringValue
    }

}
