//
//  MySDKHelper.m
//  mibo
//
//  Created by TeamMac2 on 16/8/15.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//

#import "MySDKHelper.h"
#import "LHDBQueue.h"
#import "AddressChoicePickerView.h"
#import "Newyuanmeng-Swift.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/*************************************************************************************************/
/********************************************银联支付***********************************************/
//@implementation UPAPayHelper
//+(BOOL)UPAPay:(NSString*)tn
//         mode:(NSString*)mode
//viewController:(UIViewController*)viewController
//     delegate:(id<UPAPayPluginDelegate>)delegate
//andAPMechantID:(NSString* )mID{
////    *  支付接口
////    *
////    *  @param tn             订单信息
////    *  @param mode           接入模式,标识商户以何种方式调用支付控件,00生产环境，01测试环境
////    *  @param viewController 启动支付控件的viewController
////    *  @param delegate       实现 UPAPayPluginDelegate 方法的 UIViewController
////    *  @param mID            苹果公司分配的商户号,表示调用Apple Pay所需要的MerchantID;
////    *  @return 返回函数调用结果，成功或失败
//    BOOL result = [UPAPayPlugin startPay:tn mode:mode viewController:viewController delegate:delegate andAPMechantID:mID];
//    return result;
////    -force_load $(SRCROOT)/SDK/applePaySDK/libs/libUPAPayPlugin.a
//}
//@end
/*************************************************************************************************/
/********************************************支付宝***********************************************/
@implementation AliPayHelper
+(BOOL)payForAliPayWithPartner:(NSString *)partner
                        seller:(NSString *)seller
                       tradeNO:(NSString *)tradeNO
                   productName:(NSString *)productName
            productDescription:(NSString *)productDescription
                        amount:(NSString *)amount
                     notifyURL:(NSString *)notifyURL
                    privateKey:(NSString *)privateKey
                     appScheme:(NSString *)appScheme
{
    NSLog(@"消除警告  有问题删除方法");
    BOOL result = false;
    return result;
    
    
}

+(BOOL)payForAliPayWithPartner:(NSString *)partner
                        seller:(NSString *)seller
                       tradeNO:(NSString *)tradeNO
                   productName:(NSString *)productName
            productDescription:(NSString *)productDescription
                        amount:(NSString *)amount
                     notifyURL:(NSString *)notifyURL
                    privateKey:(NSString *)privateKey
                     appScheme:(NSString *)appScheme
                     payOrAuth:(BOOL)isPay
{
    BOOL result = false;
    if (isPay) {
        [AliPayHelper doAlipayPayWithPartner:partner seller:seller tradeNO:tradeNO productName:productName productDescription:productDescription amount:amount notifyURL:notifyURL privateKey:privateKey appScheme:appScheme];
    }else{
        [AliPayHelper doAlipayAuthWithPartner:partner seller:seller tradeNO:tradeNO productName:productName productDescription:productDescription amount:amount notifyURL:notifyURL privateKey:privateKey appScheme:appScheme];
    }
    return result;
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
+ (void)doAlipayPayWithPartner:(NSString *)partner
                        seller:(NSString *)seller
                       tradeNO:(NSString *)tradeNO
                   productName:(NSString *)productName
            productDescription:(NSString *)productDescription
                        amount:(NSString *)amount
                     notifyURL:(NSString *)notifyURL
                    privateKey:(NSString *)privateKey
                     appScheme:(NSString *)appScheme
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = AliAppID;
    //    NSString *privateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        //方法弃用告警
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        #pragma clang diagnostic pop
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;   //不知道有没问题
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = tradeNO; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = amount; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        //        NSString *appScheme = appScheme;
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

#pragma mark -
#pragma mark   ==============点击模拟授权行为==============

+ (void)doAlipayAuthWithPartner:(NSString *)partner
                         seller:(NSString *)seller
                        tradeNO:(NSString *)tradeNO
                    productName:(NSString *)productName
             productDescription:(NSString *)productDescription
                         amount:(NSString *)amount
                      notifyURL:(NSString *)notifyURL
                     privateKey:(NSString *)privateKey
                      appScheme:(NSString *)appScheme
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *pid = @"";
    NSString *appID = @"";
    //    NSString *privateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [appID length] == 0 ||
        [privateKey length] == 0)
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少pid或者appID或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        #pragma clang diagnostic pop
        return;
    }
    
    //生成 auth info 对象
    APAuthV2Info *authInfo = [APAuthV2Info new];
    authInfo.pid = pid;
    authInfo.appID = appID;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    //    NSString *appScheme = @"alisdkdemo";
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NSLog(@"authInfoStr = %@",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:authInfoStr];
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString.length > 0) {
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA"];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
                                               NSLog(@"result = %@",resultDic);
                                               // 解析 auth code
                                               NSString *result = resultDic[@"result"];
                                               NSString *authCode = nil;
                                               if (result.length>0) {
                                                   NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                                   for (NSString *subResult in resultArr) {
                                                       if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                           authCode = [subResult substringFromIndex:10];
                                                           break;
                                                       }
                                                   }
                                               }
                                               NSLog(@"授权结果 authCode = %@", authCode?:@"");
                                           }];
    }
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}
@end
/*************************************************************************************************/
/*******************************************微信支付***********************************************/
@implementation WXPayHelper

+(BOOL)payForWXPayWithViewController:(UIViewController *)controller
                           withAppid:(NSString *)appid
                       withPartnerid:(NSString *)partnerid
                        withPrepayid:(NSString *)prepayid
                      withPrivateKey:(NSString *)privateKey
                       withTimeStamp:(UInt32)timeStamp
                        withNonceStr:(NSString *)nonceStr
                            withSign:(NSString *)orderSign
{
//    NSString *str1 = [[NSString alloc]initWithFormat:@"appid=%@&noncestr=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%u",appid,nonceStr,partnerid,prepayid,(unsigned int)timeStamp];
//    NSString *signStr = [[NSString alloc]initWithFormat:@"%@&key=%@",str1,privateKey];
    
//    NSString *sign = [MySDKHelper getmd5WithString:signStr];
    BOOL result = [WXApiRequestHandler jumpToBizPay:controller postSNSWithPartnerId:partnerid prepayId:prepayid nonceStr:nonceStr timeStamp:timeStamp package:@"Sign=WXPay" sign:orderSign];
    return result;
}
@end
/*************************************************************************************************/
/********************************************Mob短信***********************************************/
@implementation MOBHelper

//初始化
+ (void)setMobWithAppkey:(NSString *)SMMSAppKey withSecret:(NSString *)SMMSAppSecret
{
//    [SMSSDK registerApp:SMMSAppKey withSecret:SMMSAppSecret];
}
//获取验证码
+(void)getVerificationCodeByMethod:(SMSGetCodeMethod)method
                       phoneNumber:(NSString *)phoneNumber
                              zone:(NSString *)zone
                  customIdentifier:(NSString *)customIdentifier
                            result:(SMSGetCodeResultHandler)result
{
    [SMSSDK getVerificationCodeByMethod:method phoneNumber:phoneNumber zone:zone
                               template:customIdentifier result:result];
//    [SMSSDK getVerificationCodeByMethod:method phoneNumber:phoneNumber zone:zone customIdentifier:customIdentifier result:result];
}
//获取当前SDK版本号
+(NSString *)SMSSDKVersion
{
    return [SMSSDK sdkVersion];
}
@end
/*************************************************************************************************/
/*********************************************友盟***********************************************/
@implementation UMengHelper

//初始化
+(void)UmengInit
{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppkey];
    
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_WechatSession appKey:WXAppID appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_QQ appKey:QQAppID appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_Sina appKey:SinaAppkey appSecret:SinaAppSecret redirectURL:@"http://sns.whalecloud.com"];
    
    //支付宝的appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_AlipaySession appKey:@"alipay2017072607901626" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    [WXApi registerApp:WXAppID withDescription:@"圆梦商城"];
    [WXApi registerApp:WXAppID];
}

//分享文本
+ (void)shareTextToViewController:(UIViewController *)controller  PlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr onShareSucceed:(void (^)() ) share_succeed onShareCancel:(void (^)()) share_cancel
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.title = title;
    messageObject.text = descr;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            share_cancel();
        }else{
            NSLog(@"response data is %@",data);
            share_succeed();
        }
    }];
}
//分享图片
+ (void)shareImageToViewController:(UIViewController *)controller  PlatformType:(UMSocialPlatformType)platformType thumbImage:(UIImage *)thumbImage shareImage:(UIImage *)shareImage onShareSucceed:(void (^)() ) share_succeed onShareCancel:(void (^)()) share_cancel
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumbImage;
    [shareObject setShareImage:shareImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            share_cancel();
        }else{
            NSLog(@"response data is %@",data);
            share_succeed();
        }
    }];
}
//分享图文（新浪支持，微信/QQ仅支持图或文本分享）
+ (void)shareImageAndTextToViewController:(UIViewController *)controller  PlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage shareImage:(UIImage *)shareImage onShareSucceed:(void (^)() ) share_succeed onShareCancel:(void (^)()) share_cancel
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.title = title;
    messageObject.text = descr;
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumbImage;
    [shareObject setShareImage:shareImage];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            share_cancel();
        }else{
            NSLog(@"response data is %@",data);
            share_succeed();
        }
    }];
}
//分享网页
+ (void)shareWebPageToViewController:(UIViewController *)controller  PlatformType:(UMSocialPlatformType)platformType url:(NSString *)url title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage onShareSucceed:(void (^)() ) share_succeed onShareCancel:(void (^)()) share_cancel
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
    //设置网页地址
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            share_cancel();
        }else{
            NSLog(@"response data is %@",data);
            share_succeed();
        }
    }];
}
//若只需获取第三方平台token和uid，不获取用户名等用户信息，可以调用以下接口，如微信：
+ (void)getAuthInfoFromViewController:(UIViewController *)controller PlatformType:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] authWithPlatform:platformType currentViewController:controller completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialAuthResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}
+ (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}
+ (void)getAuthWithUserInfoFromSina
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
        }
    }];
}
+ (void)getAuthWithUserInfoFromQQ
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
        }
    }];
}

//授权并获取用户信息(获取uid、access token及用户名等)
+ (void)getAuthWithUserInfoFromViewController:(UIViewController *)controller PlatformType:(UMSocialPlatformType)platformType onLoginSucceed:(void (^)(NSString *otherType,NSString *otherId,NSString *icon,NSString *nickname,NSString *unionId,NSString *token,NSString *gender)) login_succeed onLoginCancel:(void (^)(NSString *error)) login_cancel
{
    
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:controller completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            login_cancel([NSString stringWithFormat:@"%@",error]);
        } else {
            UMSocialUserInfoResponse *resp = result;
            //            NSLog(@"resp:%@",resp);
            // 授权信息
            NSLog(@"auth uid: %@", resp.uid);
            NSLog(@"auth openid: %@", resp.openid);
            NSLog(@"auth accessToken: %@", resp.accessToken);
            NSLog(@"auth expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"user name: %@", resp.name);
            NSLog(@"user iconurl: %@", resp.iconurl);
            NSLog(@"user gender: %@", resp.gender);
            
            //            NSLog("%@"
            // 第三方平台SDK源数据
            NSLog(@"platform originalResponse: %@", resp.originalResponse);
            NSString *otherType = @"0";
            if (platformType == UMSocialPlatformType_QQ) {
                otherType = @"0";
                login_succeed(otherType,resp.openid,resp.iconurl,resp.name,resp.uid,resp.accessToken,resp.gender);
            }else if (platformType == UMSocialPlatformType_Sina){
                otherType = @"1";
                login_succeed(otherType,resp.uid,resp.iconurl,resp.name,resp.uid,resp.accessToken,resp.gender);
            }else if (platformType == UMSocialPlatformType_WechatSession){
                otherType = @"2";
                login_succeed(otherType,resp.openid,resp.iconurl,resp.name,resp.uid,resp.accessToken,resp.gender);
            }else if (platformType == UMSocialPlatformType_AlipaySession){
                otherType = @"3";
                login_succeed(otherType,resp.openid,resp.iconurl,resp.name,resp.uid,resp.accessToken,resp.gender);
            }
            
            
            
        }
    }];
}
//取消授权
+(void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"************cancelAuth fail with error %@*********",error);
        }else{
            NSLog(@"************cancelAuth success*********");
            
        }
    }];
}
@end
/*************************************************************************************************/
/*******************************************极光推送***********************************************/
static BOOL canShowAlert = true;
NSDictionary *extraDic = nil;
@implementation JPushHelper

JPsuhAlertType alertType;
//设置是否显示推送消息
+ (void) setCanShowAlert:(BOOL) show{
    canShowAlert  = show;
}
+ (BOOL) getCanShowAlert{
    return canShowAlert;
}

+(NSString *)getRegistrationID
{
    return [JPUSHService registrationID];
}
//设置显示弹框的样式
+ (void)setJPushAlertType:(JPsuhAlertType)type
{
    alertType = type;
}
//初始化
+ (void)setupWithOptions:(NSDictionary *)launchOptions withAppKey:(NSString *)appkey withChannel:(NSString *)channel withAPSForProduction:(BOOL)isPro withJPsuhAlertType:(JPsuhAlertType)type{
    [JPushHelper setJPushAlertType:type];
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:appkey channel:channel apsForProduction:isPro];//发布时改为true
    [JPushHelper observeAllNotifications:self];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
                //方法弃用告警
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
        #pragma clang diagnostic pop

    }
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    // Required
    NSLog(@"%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

+ (void)registerUserInfo:(NSDictionary *)userInfo  {
    // Required,For systems with less than or equal to iOS6
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    [JPUSHService handleRemoteNotification:userInfo];
}


+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    // IOS 7 Support Required
    NSLog(@"this is iOS7 Remote Notification");
    [JPUSHService handleRemoteNotification:userInfo];
    completion(UIBackgroundFetchResultNewData);
}

+ (void)handleFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification {
    NSLog(@"%@",notification);
            //方法弃用告警
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
    #pragma clang diagnostic pop

    return;
}

//防止乱码
+ (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
        //方法弃用告警
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    #pragma clang diagnostic pop
    return str;
}

+ (void) observeAllNotifications:(id) observer  {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:observer
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:observer
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:observer
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:observer
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:observer
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:observer
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

+ (void)removeObserveAllNotifications:(id) observer {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:observer
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:observer
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:observer
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:observer
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:observer
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:observer
                             name:kJPFServiceErrorNotification
                           object:nil];
}

+ (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

+ (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

+ (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    NSLog(@"已注册");
}

+ (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    if ([JPUSHService registrationID]) {
        NSLog(@"get RegistrationID");
    }
}
+ (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"JPushError is %@", error);
}
+ (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSLog(@"userInfo : %@",userInfo);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [JPushHelper logDic:extra]];
    NSLog(@"%@", currentContent);
    NSString *type = [NSString stringWithFormat:@"%@",[extra objectForKey:@"type"]];
    NSInteger types = type.integerValue;
    if (canShowAlert){
        if (alertType == JPsuhAlertTypeCustom) {
            if (extra != nil) {
                NSNotification * notice = [NSNotification notificationWithName:@"customNotice" object:userInfo];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }else if (alertType == JPsuhAlertTypeDefult) {
            if (extra != nil) {
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                    [JPushHelper setAlertView:content cancelButtonTitle:@"取消" otherButtonTitles:@"确定" type:types extra:extra];
                }else{
                    [JPushHelper addAlertView:content cancelButtonTitle:@"取消" otherButtonTitles:@"确定" type:types extra:extra];
                }
            }
        }
    }
}

+ (void)addAlertView:(NSString *)content cancelButtonTitle:(NSString *)cancel otherButtonTitles:(NSString *)other type:(NSInteger)type extra:(NSDictionary *)extra{
    extraDic = extra;
    UIViewController *now = [MySDKHelper getCurrentVC];
        //方法弃用告警
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:content delegate:now cancelButtonTitle:cancel otherButtonTitles:other, nil];
    #pragma clang diagnostic pop
    alert.cancelButtonIndex = 0;
    [alert show];
    
}

+ (void)setAlertView:(NSString *)content cancelButtonTitle:(NSString *)cancel otherButtonTitles:(NSString *)other type:(NSInteger)type extra:(NSDictionary *)extra{
    
    UIViewController *now = [MySDKHelper getCurrentVC];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSNotification * notice = [NSNotification notificationWithName:@"cancelNotice" object:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSNotification * notice = [NSNotification notificationWithName:@"otherNotice" object:extra];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [now presentViewController:alertController animated:YES completion:^{
        
    }];
    
}
@end

/*************************************************************************************************/
/*******************************************IAP支付***********************************************/
@implementation IAPHelper
NSInteger paymentFlag; //防止IAP交易失败提示重复出现
NSString *userId;
//监听购买结果
+(void)addTransactionObserverWithDelegate:(nullable id <SKPaymentTransactionObserver>)delegate
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:delegate];
}
//移除监听
+ (void)removeTransactionWithDelegate:(nullable id <SKPaymentTransactionObserver>)delegate
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:delegate];
}

-(void)payForIAPWithViewController:(UIViewController *)controller
                        withUserID:(NSString *)userID
                      withOrderNum:(NSString *)orderNum
                        withPayNum:(NSString *)payNum
                       withReceipt:(NSString *)receipt
                         withTotal:(NSString *)total
                withAppleValidType:(NSString *)appleValidType
                   withTransaction:(SKPaymentTransaction *)transaction
                       withReceipt:(BOOL)isIAPReceipt
                      withDelegate:(nullable id <SKProductsRequestDelegate>)delegate
{
    self.orderNum = orderNum;
    self.payNum = payNum;
    self.receipt = receipt;
    self.total = total;
    self.appleValidType = appleValidType;
    self.isIAPReceipt = isIAPReceipt;
    paymentFlag = 0;
    userId = userID;
    if ([SKPaymentQueue canMakePayments]) {
        [IAPHelper getProductInfoWithOrderNum:payNum withDelegate:delegate];
    }
}

+(void)getProductInfoWithOrderNum:(NSString *)payNum  withDelegate:(nullable id <SKProductsRequestDelegate>)delegate
{
    NSSet<NSString *> *set = [NSSet setWithArray:@[payNum]];
    SKProductsRequest *requeset = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
    requeset.delegate = delegate;
    [requeset start];
}
//查询的回调函数
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray<SKProduct *>* myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    SKProduct *p = [[SKProduct alloc]init];
    for (SKProduct *pro in myProduct) {
        if (pro.productIdentifier == self.payNum) {
            p = pro;
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
// 在viewDidLoad方法中，将购买页面设置成购买的Observer。
//当用户购买的操作有结果时，就会触发下面的回调函数，相应进行处理即可。
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                self.transaction = tran;
                [self checkReceiptIsValid];
                [self completeTransaction:tran withType:0];
                break;
                
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"正在请求付费信息");
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                NSLog(@"error:%@ code:%ld",tran.error,(long)tran.error.code);
                if (paymentFlag == 0) {
                    paymentFlag = 1;
                    [self completeTransaction:tran withType:1];
                }
                break;
                
                
            default:
                break;
        }
    }
}

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"请求结束");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"商品信息请求错误:%@",error.localizedDescription);
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction withType:(NSInteger)type
{
    NSLog(@"交易结束");
    if (type == 1) {
        NSString *mess = @"购买失败";
        switch (transaction.error.code) {
            case SKErrorUnknown:
                mess = @"未知错误";
                break;
                
            case SKErrorClientInvalid:
                mess = @"无效用户";
                break;
                
            case SKErrorPaymentCancelled:
                mess = @"用户取消支付";
                break;
                
            case SKErrorPaymentInvalid:
                mess = @"支付无效";
                break;
                
            case SKErrorPaymentNotAllowed:
                mess = @"此账号禁止支付";
                break;
                
            case SKErrorStoreProductNotAvailable:
                mess = @"获取不到商品";
                break;
                
                
            default:
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:mess delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 10001;
        [alert show];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)checkReceiptIsValid
{
    NSString *productIdentifiler = self.transaction.payment.productIdentifier;
    NSLog(@"%@",productIdentifiler);
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptDATA = [[NSData alloc]initWithContentsOfURL:recepitURL];
    if (receiptDATA == nil) {
        NSLog(@"凭证错误");
        return;
    }
    self.receipt = [receiptDATA base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (self.isIAPReceipt) {
        [self checkIAPReceipt:self.receipt];
    }else{
        [IAPHelper checkReceipt:self.receipt];
    }
}
//前端验证收据
- (void)checkIAPReceipt:(NSString *)receipt
{
    NSDictionary *requestContents = [[NSDictionary alloc]initWithObjects:@[receipt] forKeys:@[@"receipt-data"]];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:NSJSONWritingPrettyPrinted error:nil];
    NSURL *storeURL = [[NSURL alloc]initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *storeRequest = [[NSMutableURLRequest alloc]initWithURL:storeURL];
    storeRequest.HTTPBody = requestData;
    storeRequest.HTTPMethod = @"POST";
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError != nil) {
            NSLog(@"验证失败");
            NSLog(@"connectionError:%@",connectionError);
            switch (connectionError.code) {
                case 21001:
                    NSLog(@"App Store无法读取你提供的JSON数据");
                    break;
                    
                case 21002:
                    NSLog(@"收据数据不符合格式");
                    break;
                    
                case 21003:
                    NSLog(@"收据无法被验证");
                    break;
                    
                case 21004:
                    NSLog(@"你提供的共享密钥和账户的共享密钥不一致");
                    break;
                    
                case 21005:
                    NSLog(@"收据服务器当前不可用");
                    break;
                    
                case 21006:
                    NSLog(@"收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中");
                    break;
                    
                case 21007:
                    NSLog(@"收据信息是测试用（sandbox），但却被发送到产品环境中验证");
                    break;
                    
                case 21008:
                    NSLog(@"收据信息是产品环境中使用，但却被发送到测试环境中验证");
                    break;
                    
                    
                default:
                    [self saveReceipt];
                    break;
            }
        }else{
            NSLog(@"验证成功");
            NSJSONSerialization *jsonRsponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (jsonRsponse != nil) {
                NSLog(@"jsonRsponse:%@",jsonRsponse);
            }
        }
    }];
}
//后台验证收据,调用后台给的接口去验证，参数orderNum, receipt, appleValidType
+ (void)checkReceipt:(NSString *)receipt
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证失败!(选择取消将在下次启动app时自动验证，验证通过将自动充值)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    alert.tag = 1000;
    alert.cancelButtonIndex = 0;
    [alert show];
}

//持久化存储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
- (void)saveReceipt
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/EACEF35FE363A75A/",[paths objectAtIndex:0]];
    NSString *fileName = [MySDKHelper getNowTimeWithDateFormat:@"yyyyMMddHHmmss" withIsNeed:false withType:1];
    NSString *savePath = [NSString stringWithFormat:@"%@%@.plist",documentsDirectory,fileName];
    NSDictionary *dic = @{@"receipt-data":self.receipt,@"DATE":fileName,@"USERID":userId,@"payNum":self.payNum,@"orderNum":self.orderNum,@"total":self.total,@"appleValidType":self.appleValidType};
    [dic writeToFile:savePath atomically:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001) {
        
    }else if (alertView.tag == 1000) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self saveReceipt];
        }else{
            if (self.isIAPReceipt) {
                [self checkIAPReceipt:self.receipt];
            }else{
                [IAPHelper checkReceipt:self.receipt];
            }
        }
    }
}
//检查路径下是否存在凭证文件,验证receipt失败,App启动后再次验证
+(void)checkIAPReceiptWithPath:(NSString *)plistPath type:(NSInteger)type
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/EACEF35FE363A75A/",[paths objectAtIndex:0]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (type == 1) {
        NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
        for (NSString * fileName in cacheFileNameArray) {
            if ([fileName hasSuffix:@".plist"]) {//如果有plist后缀的文件，说明就是存储的购买凭证
                NSString *filePath = [NSString stringWithFormat:@"%@%@",documentsDirectory,fileName];
                [IAPHelper sendAppStoreRequestBuyPlist:filePath];
            }
        }
    }else{
        //如果在该路径下不存在文件，说明就没有保存验证失败后的购买凭证，也就是说发送凭证成功。
        if ([fileManager fileExistsAtPath:documentsDirectory]) {
            if (type == 0) {
                //存在购买凭证，说明发送凭证失败，再次发起验证
                [IAPHelper checkIAPReceiptWithPath:documentsDirectory type:1];
            }else if (type == 2) {
                //删除本地凭证
                [fileManager removeItemAtPath:plistPath error:nil];
            }
        }
    }
}

+(void)sendAppStoreRequestBuyPlist:(NSString *)plistPath
{
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    //这里的参数请根据自己公司后台服务器接口定制，但是必须发送的是持久化保存购买凭证
    if (dic != nil && ![(NSString *)[dic objectForKey:@"receipt-data"] isEqualToString:@""]) {
        [IAPHelper checkReceipt:(NSString *)[dic objectForKey:@"receipt-data"]];
        //验证成功
        //[IAPHelper checkIAPReceiptWithPath:plistPath type:2];
        //验证失败
        //[IAPHelper checkIAPReceiptWithPath:plistPath type:1];
    }
}

@end
/*************************************************************************************************/
/*******************************************其他接口***********************************************/
@implementation MySDKHelper
/*************************************************************************************************/
{
    LHDBQueue* queue;
}

+ (NSString *)insetString:(NSString *)text size:(NSInteger)width{
    NSMutableString *mutableString = [[NSMutableString alloc]initWithString:text];
    //这部分就是我们要插入的css语句
    NSString *css = [NSString stringWithFormat:@"<style type=\"text/css\">body {font-size: 15;}img {  width:%ldpx;}</style>", (long)width];
    //将css语句插入到可变字符串的第一个位置
    [mutableString insertString:css atIndex:0];
    return mutableString;
}

- (void)getCityData:(void (^)(NSArray *citydata))succeed {
    // 0.获得沙盒中的数据库文件名
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"regioin.db"];
//    NSError *error;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filenameAgo = [bundle pathForResource:@"regioin" ofType:@"db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filename];
    if (!isExist) {
        //拷贝数据库
        NSError *error = [[NSError alloc] init];
        BOOL cp = [fileManager copyItemAtPath:filenameAgo toPath:filename error:&error];
        if (cp) {
            NSLog(@"数据库拷贝成功");
        }else{
            NSLog(@"数据库拷贝失败： %@",[error localizedDescription]);
        }
    }
    //使用单例方法构建单列对象  使用之前请导入sqlite3框架
    queue = [LHDBQueue instanceManager];
    //设置数据库路径   这一步一定要做   没有设置数据库路径 所有的数据库操作都会失败  因为没有创建数据库  这一步的作用就是创建数据库
    queue.sqlPath =  filenameAgo;
    //执行查询操作   返回数组中全部是字典
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [queue readOpeartionWith:@"SELECT * FROM tiny_region" tableName:@"tiny_region" success:^(NSArray *resultArray) {
            
            succeed([MySDKHelper choosecity:resultArray]);
        } faild:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    });
}

+(NSArray *)choosecity:(NSArray *)resultArray{
    NSMutableArray *pArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < resultArray.count ; i++) {
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithDictionary:[resultArray objectAtIndex:i]];
        if ([dic1[@"parent_id"] integerValue]== 0) {
            NSMutableArray *cArr = [NSMutableArray arrayWithCapacity:0];
            for (int j = 0; j < resultArray.count; j++) {
                NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]initWithDictionary:[resultArray objectAtIndex:j]];
                if ([dic2[@"parent_id"] integerValue] == [dic1[@"id"] integerValue]) {
                    NSMutableArray *aArr = [NSMutableArray arrayWithCapacity:0];
                    for (int k = 0; k < resultArray.count; k++) {
                        NSMutableDictionary *dic3 = [[NSMutableDictionary alloc]initWithDictionary:[resultArray objectAtIndex:k]];
                        if ([dic3[@"parent_id"] integerValue]== [dic2[@"id"] integerValue]) {
                            [aArr addObject:dic3];
                        }
                    }
                    NSMutableDictionary *newdic2 = [NSMutableDictionary dictionaryWithDictionary:dic2];
                    [newdic2 setObject:[NSArray arrayWithArray:aArr] forKey:@"areas"];
                    [cArr addObject:newdic2];
                    
                }
            }
            NSMutableDictionary *newdic1 = [NSMutableDictionary dictionaryWithDictionary:dic1];
            [newdic1 setObject:[NSArray arrayWithArray:cArr] forKey:@"cities"];
            [pArr addObject:newdic1];
        }
    }
    return pArr;
}
+ (void)getCityName:(void (^)(NSString *city)) login_succeed {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [defaults objectForKey:@"citydata"];
    if (data.count == 0) {
        return;
    }
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]initWithData:data];
//    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate){
//        NSString *city = [NSString stringWithFormat:@"%@",locate];
//        login_succeed(city);
//    };
    
    addressPickerView.block = ^(AddressChoicePickerView *view, UIButton *btn, AreaObject *locate) {
        NSString *city = [NSString stringWithFormat:@"%@",locate];
        login_succeed(city);
    };
    [addressPickerView show];
}

//补全图片
+(NSString *)getFullImageURL:(NSString *)imageurl
{
    NSString *fullImageurl = [imageurl stringByReplacingOccurrencesOfString:@"'\'" withString:@""];
    if (![fullImageurl hasPrefix:@"http://"]) {
        if ([fullImageurl hasPrefix:@"/"]) {
            fullImageurl = [NSString stringWithFormat:@"%@%@",[MyManager sharedMyManager].ImageHost,fullImageurl];
        }else{
            fullImageurl = [NSString stringWithFormat:@"%@/%@",[MyManager sharedMyManager].ImageHost,fullImageurl];
        }
    }
    return  fullImageurl;
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否是纯汉字
+ (BOOL)isChinese:(NSString*)string
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}
//密码不能有标点
+(BOOL)isNumbOrString:(NSString *)string
{
    NSString * regex = @"^[A-Za-z0-9]{0,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}
//判断身份证是否合法
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

+(NSDictionary *)removeEmptyKey:(NSDictionary *)dic
{
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    NSArray *keys = [dic allKeys];
    for (int i = 0; i < keys.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%@",keys[i]];
        NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
        if ([value isEqualToString:@""]) {
            [newDic removeObjectForKey:key];
        }
    }
    return newDic;
}

+(NSString *)signDictionary:(NSDictionary *)dic
{
    NSString *signData = [[NSString alloc]init];
    NSArray *keys = [dic allKeys];
    for (NSString *key in keys) {
        NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
        value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
        signData = [NSString stringWithFormat:@"%@%@=%@",signData,key,value];
    }
    signData = [NSString stringWithFormat:@"%@ajsO4jnlkIVjf2taQWEQWdfgfh==",signData];
    signData = [MySDKHelper getmd5WithString:signData];
    signData = [NSString stringWithFormat:@"%@123456",signData];
    signData = [MySDKHelper getmd5WithString:signData];
    return signData;
}



+(void)postAsyncWithURL:(NSString *)requestURL
       withParamBodyKey:(NSArray<NSString *> *)paramBodyKey
     withParamBodyValue:(NSArray *)paramBodyValue
              needToken:(NSString *)needToken
            postSucceed:(void (^)(NSDictionary *result))post_succeed
             postCancel:(void (^)(NSString *error)) post_cancel

{
    //拼接URL字符串
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",mainUrl,requestURL];
    //获取URL
    NSURL *url = [NSURL URLWithString:strUrl];
    //设置请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //请求方式
    request.HTTPMethod = @"POST";
    //超时5秒
    request.timeoutInterval = 10;
    //请求体
    //多个参数的时候
    NSMutableArray<NSString *> *fullparams = [[NSMutableArray alloc]initWithArray:paramBodyKey];
    NSMutableArray *fullparamsvalue = [[NSMutableArray alloc]initWithArray:paramBodyValue];
    if (![needToken isEqualToString:@""]) {
        [fullparams addObject:@"token"];
        [fullparamsvalue addObject:needToken];
    }
    if (fullparams.count != 0) {
        
        NSMutableDictionary *codeDic = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *fullDic = [[NSMutableDictionary alloc]init];
        for (int j = 0; j < fullparams.count; j++) {
            [codeDic setValue:fullparamsvalue[j] forKey:fullparams[j]];
        }
        [fullDic setObject:[MySDKHelper toJSONData:[MySDKHelper removeEmptyKey:codeDic]] forKey:@"code"];
        [fullDic setObject:[MySDKHelper signDictionary:[MySDKHelper removeEmptyKey:codeDic]] forKey:@"sign"];
        NSMutableString *params = [NSMutableString string];
        NSArray *keys = [fullDic allKeys];
        for (int i = 0; i < keys.count; i++) {
            [params appendString:[NSString stringWithFormat:@"%@=%@",keys[i],[fullDic objectForKey:keys[i]]]];
            if (i < keys.count - 1) {
                [params appendString:@"&"];
            }
        }
        NSString *param = [NSString stringWithString:params];
        //将中文转码(url中有中文的时候一定要使用这句)
        param = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
//        NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
//        NSCharacterSet *allowedChar = [NSCharacterSet characterSetWithCharactersInString:charactersToEscape];
//        param = [param stringByAddingPercentEncodingWithAllowedCharacters:allowedChar];
//        NSCharacterSet
        //设置请求体
        NSLog(@"strUrl %@ ? %@ nparam  %@",strUrl,param, fullDic);
        request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
        //设置请求头信息
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError || data == nil) {
            NSLog(@"connectionError %@",connectionError.description);
            return ;
        }
        //解析JSON数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"response %@",dic);
        NSString *error = [NSString stringWithFormat:@"%@",dic[@"code"]];
        if ([error isEqualToString:@"0"]) {
            post_succeed(dic);
        } else {
            post_cancel([NSString stringWithFormat:@"%@",dic[@"message"]]);
            if ([error isEqualToString:@"1003"]) {
                CommonConfig.isLogin = NO;
                LoginViewController *login = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
                login.ispresent = YES;
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window.rootViewController presentViewController:login animated:YES completion:nil];
            }
        }
    }];
//    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error || data == nil) {
//            NSLog(@"connectionError %@",error.description);
//            return ;
//        }
//        //解析JSON数据
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"response %@",dic);
//        NSString *connectionError = [NSString stringWithFormat:@"%@",dic[@"code"]];
//        if ([connectionError isEqualToString:@"0"]) {
//            post_succeed(dic);
//        } else {
//            post_cancel([NSString stringWithFormat:@"%@",dic[@"message"]]);
//        }
//    }];
}

// 将字典或者数组转化为JSON串
+ (NSString *)toJSONData:(NSDictionary *)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    if ([jsonData length] > 0 && error == nil){
        //使用这个方法的返回，我们就可以得到想要的JSON字符串
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/**************************************选取图片和保存图片******************************************/
//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName viewController:(UIViewController *)controller
{
    
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    UIImageWriteToSavedPhotosAlbum(tempImage, controller, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [NoticeView showMessage:msg];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
//    [alert show];
    
}

//从document取得图片
- (UIImage *)getImage:(NSString *)urlStr
{
    return [UIImage imageWithContentsOfFile:urlStr];
}
-(void) ShowCamera:(UIViewController *)controller withDelegate:(nullable id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = delegate;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [controller presentViewController:picker animated:YES completion:nil];
    
}
-(void)ShowAlumb:(UIViewController *)controller withDelegate:(nullable id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = delegate;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [controller presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!originalImage)
        return;
    originalImage=nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/**************************************创建高斯模糊效果的背景******************************************/
+(UIImage *)createBlurBackground:(UIImage *)image blurRadius:(CGFloat)blurRadius
{
    CIImage *originImage = [[CIImage alloc]initWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:originImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blurRadius] forKey:@"inputRadius"];
    CIImage *result = (CIImage *)[filter valueForKey:kCIOutputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *blurImage = [UIImage imageWithCGImage:[context createCGImage:result fromRect:result.extent]];
    return blurImage;
}

/**************************************判断手机号码是否正确******************************************/
+ (BOOL) isMobileTwo:(NSString *)mobileNumbel
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181,177(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((77|33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    return NO;
}

// 判断是否是11位手机号码
+ (BOOL)isMobile:(NSString *)phoneNum
{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    
    // 一个判断是否是手机号码的正则表达式
    NSString *pattern = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",CM_NUM,CU_NUM,CT_NUM];
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *mobile = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        NO;
    }
    
    // 无符号整型数据接收匹配的数据的数目
    NSUInteger numbersOfMatch = [regularExpression numberOfMatchesInString:mobile options:NSMatchingReportProgress range:NSMakeRange(0, mobile.length)];
    if (numbersOfMatch>0) return YES;
    
    return NO;
    
}

/*****************************************获取当前控制器*********************************************/
//获取当前屏幕中present出来的viewcontroller
+ (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
    
}
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
    
}

/******************获取字符串的宽度和高度||获取当前时间||时间戳转时间||时间转时间戳************************/
//获取字符串的宽度和高度
+ (CGRect)getTextRectSize:(NSString *)text withFont:(UIFont *)font withSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGRect newsize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return newsize;
}
//获取当前时间
+ (NSString *)getNowTimeWithDateFormat:(NSString *)dateFormat withIsNeed:(BOOL)isNeed withType:(NSInteger)type
{
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = dateFormat;
    NSString *dateStr = [formatter stringFromDate:date];
    if (type == 0) {
        dateStr = [MySDKHelper stringToTimeStamp:dateStr withDateFormat:dateFormat withIsNeed:isNeed];
    }
    return dateStr;
}
//时间转化成时间戳 yyyy年MM月dd日
+ (NSString *)stringToTimeStamp:(NSString *)stringTime withDateFormat:(NSString *)dateFormat withIsNeed:(BOOL)isNeed
{
    NSDateFormatter *dfmatter = [[NSDateFormatter alloc]init];
    dfmatter.dateFormat = dateFormat;
    NSDate *date = [dfmatter dateFromString:stringTime];
    NSTimeInterval dateStamp = [date timeIntervalSince1970];
    if (isNeed) {
        dateStamp = [date timeIntervalSince1970]*1000;
    }
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)dateStamp];
    return timeSp;
}
//时间戳转化成时间
+(NSString *)timeStampToString:(NSString *)timeStamp withDateFormat:(NSString *)dateFormat withIsNeed:(BOOL)isNeed
{
    NSString *timeStr = timeStamp;
    NSTimeInterval dateStamp = timeStr.doubleValue;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = dateFormat;
    if (isNeed) {
        dateStamp = dateStamp / 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStamp];
    return [formatter stringFromDate:date];
}

/*******************************************MD5加密***********************************************/
#define CC_MD5_DIGEST_LENGTH 16

+ (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02X", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

+ (NSString*)getMD5WithData:(NSData *)data{
    const char* original_str = (const char *)[data bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02X",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    
    //也可以定义一个字节数组来接收计算得到的MD5值
    //    Byte byte[16];
    //    CC_MD5(original_str, strlen(original_str), byte);
    //    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    //    for(int  i = 0; i<CC_MD5_DIGEST_LENGTH;i++){
    //        [outPutStr appendFormat:@"%02x",byte[i]];
    //    }
    //    [temp release];
    
    return [outPutStr lowercaseString];
    
}

//+(NSString*)getFileMD5WithPath:(NSString*)path
//{
//    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path,FileHashDefaultChunkSizeForReadingData);
//}

//CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
//                                      size_t chunkSizeForReadingData) {
//
//    // Declare needed variables
//    CFStringRef result = NULL;
//    CFReadStreamRef readStream = NULL;
//
//    // Get the file URL
//    CFURLRef fileURL =
//    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
//                                  (CFStringRef)filePath,
//                                  kCFURLPOSIXPathStyle,
//                                  (Boolean)false);
//
//    CC_MD5_CTX hashObject;
//    bool hasMoreData = true;
//    bool didSucceed;
//
//    if (!fileURL) goto done;
//
//    // Create and open the read stream
//    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
//                                            (CFURLRef)fileURL);
//    if (!readStream) goto done;
//    didSucceed = (bool)CFReadStreamOpen(readStream);
//    if (!didSucceed) goto done;
//
//    // Initialize the hash object
//    CC_MD5_Init(&hashObject);
//
//    // Make sure chunkSizeForReadingData is valid
//    if (!chunkSizeForReadingData) {
//        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
//    }
//
//    // Feed the data to the hash object
//    while (hasMoreData) {
//        uint8_t buffer[chunkSizeForReadingData];
//        CFIndex readBytesCount = CFReadStreamRead(readStream,
//                                                  (UInt8 *)buffer,
//                                                  (CFIndex)sizeof(buffer));
//        if (readBytesCount == -1)break;
//        if (readBytesCount == 0) {
//            hasMoreData =false;
//            continue;
//        }
//        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
//    }
//
//    // Check if the read operation succeeded
//    didSucceed = !hasMoreData;
//
//    // Compute the hash digest
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5_Final(digest, &hashObject);
//
//    // Abort if the read operation failed
//    if (!didSucceed) goto done;
//
//    // Compute the string result
//    char hash[2 *sizeof(digest) + 1];
//    for (size_t i =0; i < sizeof(digest); ++i) {
//        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
//    }
//    result = CFStringCreateWithCString(kCFAllocatorDefault,
//                                       (const char *)hash,
//                                       kCFStringEncodingUTF8);
//
//done:
//
//    if (readStream) {
//        CFReadStreamClose(readStream);
//        CFRelease(readStream);
//    }
//    if (fileURL) {
//        CFRelease(fileURL);
//    }
//    return result;
//}
+ (void)uploadImageToUPyun:(NSData *)fileData withPolicy:(NSString *)policy withSignture:(NSString *)signture{
     UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //以本地时间作为图片名
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *imgName = [formatter stringFromDate:[NSDate date]];
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:32];
    for (NSInteger i = 0; i < 32; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)letters.length)]];
    }
    imgName = [NSString stringWithFormat:@"%@%@",imgName,randomString];
    [up uploadWithOperator:@"operator1"
                    policy:policy
                 signature:signture
                  fileData:fileData
                  fileName:imgName
                   success:^(NSHTTPURLResponse *response, NSDictionary *responseBody) {
                       NSLog(@"上传成功 responseBody：%@", responseBody);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImageSuccess" object:nil userInfo:@{@"url" : [responseBody objectForKey:@"url"]}];
                 } failure:^(NSError *error, NSHTTPURLResponse *response, NSDictionary *responseBody) {
                     NSLog(@"上传失败 responseBody：%@", responseBody);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImageFail" object:nil];
                 } progress:^(int64_t completedBytesCount, int64_t totalBytesCount) {
                     NSString *progress = [NSString stringWithFormat:@"%lld / %lld", completedBytesCount, totalBytesCount];
                     NSLog(@"upload progress: %@", progress);
                 }];
   
}

////上传图片到ypanyun
+ (NSString *)uploadImageToUPyun:(NSData *)fileData{
    UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //以本地时间作为图片名
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *imgName = [formatter stringFromDate:[NSDate date]];
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:32];
    for (NSInteger i = 0; i < 32; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)letters.length)]];
    }
    imgName = [NSString stringWithFormat:@"%@%@",imgName,randomString];
    __block NSString *path = [NSString stringWithFormat:@"/public/upload/contract/%@.png",imgName];
    NSString *bucketName = @"ymlypt";
    [up uploadWithBucketName:bucketName
                    operator:@"operator1"
                    password:@"operator1"
                    fileData:fileData
                    fileName:nil
                     saveKey:path
             otherParameters:nil
                     success:^(NSHTTPURLResponse *response,
                               NSDictionary *responseBody) {
                         NSLog(@"上传成功 responseBody：%@", responseBody);
                         //NSLog(@"file url：https://%@.b0.upaiyun.com/%@", bucketName, [responseBody objectForKey:@"url"]);
                         //主线程刷新ui
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImageSuccess" object:nil userInfo:@{@"url" : [responseBody objectForKey:@"url"]}];
                     }
                     failure:^(NSError *error,
                               NSHTTPURLResponse *response,
                               NSDictionary *responseBody){
                         NSLog(@"上传失败 message：%@", responseBody);
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImageFail" object:nil];
                     }
                    progress:^(int64_t completedBytesCount,
                               int64_t totalBytesCount) {
                        NSString *progress = [NSString stringWithFormat:@"%lld / %lld", completedBytesCount, totalBytesCount];
                        NSLog(@"upload progress: %@", progress);

                        //主线程刷新ui
                        dispatch_async(dispatch_get_main_queue(), ^(){

                        });
                    }];
    return path;
}
#pragma clang diagnostic pop
@end

