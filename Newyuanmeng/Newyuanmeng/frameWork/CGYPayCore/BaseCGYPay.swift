//
//  BaseCGYPay.swift
//  CGYPay
//
//  Created by Chakery on 16/3/31.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import Foundation

open class BaseCGYPay: NSObject {
    fileprivate static let _sharedInstance = BaseCGYPay()
    open class var sharedInstance: BaseCGYPay {
        return _sharedInstance
    }
    
    open func handleOpenURL(_ url: URL) { }
    
    open func sendPay(_ channel: CGYPayChannel, callBack: CGYPayCompletedBlock) { }
    
    open func registerWxAPP(_ appid: String) { }
}
