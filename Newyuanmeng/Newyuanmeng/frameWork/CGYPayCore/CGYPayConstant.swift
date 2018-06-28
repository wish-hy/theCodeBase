//
//  CGYPayConstant.swift
//  CGYPay
//
//  Created by Chakery on 16/3/26.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import Foundation

/**
 支付状态码
 
 - PaySuccess:           支付成功
 - PayProcessing:        正在处理
 - PayErrCodeUserCancel: 用户取消支付
 - PayErrSentFail:       发送失败
 - PayErrAuthDeny:       授权失败
 - PayErrPayFail:        支付失败
 - PayErrWxUnsupport:    微信不支持
 - PayErrWxUnInstall:    微信未安装
 - PayErrNetWorkFail:    网络错误
 - PayErrSDKNotFound:    SDK没有导入
 - PayErrUnKnown:        未知错误
 */
public enum CGYPayStatusCode {
    /**
     *  支付成功
     *
     *  @param wxPayResult  微信支付结果
     *  @param aliPayResult 支付宝支付结果
     *  @param upPayResult  银联支付结果
     *
     *  @return 返回支付结果
     */
    case paySuccess(wxPayResult: String?, aliPayResult: String?, upPayResult: [String:AnyObject]?)
    /// 正在处理
    case payProcessing
    /// 用户取消支付
    case payErrCodeUserCancel
    /// 发送失败
    case payErrSentFail
    /// 授权失败
    case payErrAuthDeny
    /// 支付失败
    case payErrPayFail
    /// 微信不支持
    case payErrWxUnsupport
    /// 未安装微信
    case payErrWxUnInstall
    /// 网络错误
    case payErrNetWorkFail
    /// 没有导入相应的SDK
    case payErrSDKNotFound
    /// 未知错误
    case payErrUnKnown
}

/// 支付回调
public typealias CGYPayCompletedBlock = (CGYPayStatusCode) -> Void

