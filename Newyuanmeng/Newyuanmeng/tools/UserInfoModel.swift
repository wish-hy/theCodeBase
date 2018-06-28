//
//  UserInfoModel.swift
//  mibo
//
//  Created by TeamMac2 on 16/3/21.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//

import Foundation
import SwiftyJSON

open class UserInfoModel:NSObject{
    var id:Int = 0                 //id
    var userId:Int = 0             //用户id
    var name:String = ""            //
    var nickName:String = ""        //用户昵称
    var photo:URL!            //用户头像
    var signture:String = ""        //签名
    var sex:String!             //性别 1男 2 女
    var coin:Int!               //米币数
    var code:Int!               //显示的id
    var otherId:String!         //第三方id
    var otherType:String!       //登录类型  /**0-手机注册；1-微信；2-QQ；3-微博；4-游客；5-PC**/
    var ticket:Int!             //米券数
    var phone:String!           //绑定的手机
    var area:String!            //区域
    var isSignIn:Bool!          //是否签到了
    var account:String = ""         //登陆账号
    var password:String = ""        //登录密码
    var city:String!            //城市
    var grade:Int               //等级
    var isPush:String           //是否推送
    var pushId:String           //推送id
    var userThirds:Array<JSON> = []        //第三方绑定的帐号
    var imId:String             //环信id
    var photoUrl:String!         //头像url
    var status:String!           //
    var group_id:String!
    var rongyun_token:String = "" //融云的token
    var verified:String = ""
    
    init(userInfo:JSON) {
        self.id = userInfo["id"].intValue
        self.userId = userInfo["user_id"].intValue
        self.name = userInfo["name"].stringValue
        self.nickName = userInfo["nickname"].stringValue
        self.photo = NSURL(string: CommonConfig.getImageUrl(userInfo["avatar"].stringValue)) as! URL
        self.signture = userInfo["signture"].stringValue
        self.otherId = userInfo["otherId"].stringValue
        self.otherType = userInfo["otherType"].stringValue
        self.phone = userInfo["mobile"].stringValue
        self.area = userInfo["area"].stringValue
        self.grade = userInfo["grade"].intValue
        self.coin = userInfo["coin"].intValue
        self.code = userInfo["code"].intValue
        self.ticket = userInfo["ticket"].intValue
        self.account = userInfo["account"].stringValue
        self.password = userInfo["password"].stringValue
        self.isSignIn = userInfo["isSignIn"].boolValue
        if userInfo["city"] != nil {
            self.city = userInfo["city"].stringValue
        }else {
            self.city = "无"
        }
        self.isPush = userInfo["isPush"].stringValue
        self.pushId = userInfo["pushId"].stringValue
        self.userThirds = JSON.parse(userInfo["userThirds"].stringValue).arrayValue
        self.imId = userInfo["imId"].stringValue
        self.photoUrl = CommonConfig.getImageUrl(userInfo["avatar"].stringValue)
        self.status = userInfo["status"].stringValue
        self.group_id = userInfo["group_id"].stringValue
        self.rongyun_token = userInfo["rongyun_token"].stringValue
        self.verified = userInfo["verified"].stringValue
    }

}
