//
//  integralModel.swift
//  huabi
//
//  Created by TeamMac2 on 17/4/18.
//  Copyright © 2017年 ltl. All rights reserved.
//

import Foundation
import SwiftyJSON


public class integralModel: NSObject{

    //需要的字段: cash  point  img  name  goods_id
//    
//    var cash:String!
//    var point:String!
    var img:String!
    var name:String!
    var goods_id:String!
    var price_set:Array<JSON> = []
    
    
    init(integralInfo:JSON){
    
//        self.cash = integralInfo["cash"].stringValue
//        self.point = integralInfo["point"].stringValue
        self.img = integralInfo["img"].stringValue
        self.name = integralInfo["name"].stringValue
        self.goods_id = integralInfo["id"].stringValue
        self.price_set = integralInfo["price_set"].arrayValue
    
    }
    
}