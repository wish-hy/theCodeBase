//
//  CGYPay.swift
//  CGYPay
//
//  Created by Chakery on 16/3/26.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import Foundation

open class CGYPay: NSObject {
    /**
     调起支付
     
     - parameter channel:  支付渠道
     - parameter callBack: 支付回调
     */
    open class func createPayment(_ channel: CGYPayChannel, callBack: CGYPayCompletedBlock) {
        switch channel {
        case .weixin:
            if let wxPay = wxPay {
                wxPay.sendPay(channel, callBack: callBack)
            } else {
                callBack(.payErrSDKNotFound)
            }
        case .aliPay:
            if let aliPay = aliPay {
                aliPay.sendPay(channel, callBack: callBack)
            } else {
                callBack(.payErrSDKNotFound)
            }
        case .upPay:
            if let upPay = upPay {
                upPay.sendPay(channel, callBack: callBack)
            } else {
                callBack(.payErrSDKNotFound)
            }
        }
    }
    
    /**
     从APP返回时执行的回调
     
     - parameter url: url
     
     - returns: 
     */
    open class func handlerOpenURL(_ url: URL) -> Bool {
        if let wxPay = wxPay {
            wxPay.handleOpenURL(url)
        }
        if let aliPay = aliPay {
            aliPay.handleOpenURL(url)
        }
        if let upPay = upPay {
            upPay.handleOpenURL(url)
        }
        return true
    }
    
    /**
     注册微信
     
     - parameter appid: appid
     */
    open class func registerWxAPP(_ appid: String) {
        if let wxPay = wxPay {
            wxPay.registerWxAPP(appid)
        }
    }
    
    // 银联支付
    fileprivate static var upPay: BaseCGYPay? = {
        let upPayType = NSObject.cgy_classFromString("CGYPayUPService") as? BaseCGYPay.Type
        return upPayType?.sharedInstance
    }()
    // 微信支付
    fileprivate static var wxPay: BaseCGYPay? = {
        let wxPayType = NSObject.cgy_classFromString("CGYPayWxService") as? BaseCGYPay.Type
        return wxPayType?.sharedInstance
    }()
    // 支付宝支付
    fileprivate static var aliPay: BaseCGYPay? = {
        let aliPayType = NSObject.cgy_classFromString("CGYPayAliService") as? BaseCGYPay.Type
        return aliPayType?.sharedInstance
    }()
}
