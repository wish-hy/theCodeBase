//
//  MySDKHelper.h
//  mibo
//
//  Created by TeamMac2 on 16/8/15.
//  Copyright © 2016年 TeamMac2. All rights reserved.
//
#import "MyManager.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
//#import "UPAPayPlugin.h"
//#import "UPAPayPluginDelegate.h"


#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

#define AppID @"1330161083"  
#define AliAppID @"alipay2017072607901626"

#define UMengAppkey @"5a59af09f29d9829a3000182"

#define SinaAppkey @"1023386547"
#define SinaAppSecret @"21f3b03bd6a3d741eedac88bcfb44d1a"


#define QQAppID @"1106298048"
#define QQAppkey @"WgzvF8bV4GDTcXay"


#define WXAppID @"wx167f2c4da1f798b0"
#define WXAppSecret @"d8ef3cf4caf1f2625280f0c782bd0225"

#define MobAppkey @"1f4d2d20dd266"
#define MobAppSecret @"46aa3272cd79dd41cca1ac09c374ebd8"

#define JPushAppkey @"feaaf7eaf74a3c1a161b779d"    
#define JPushAppSecret @"c8914faebc51bef2c87a1ea1"


#define mainUrl @"http://www.ymlypt.com"

//极光推送
#import "JPUSHService.h"
//支付宝支付
#import "APAuthV2Info.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"                   // 导入订单类
#import "DataSigner.h"              // 生成signer的类：获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
//IAP支付
#import <StoreKit/StoreKit.h>
//微信支付
#import "WXApi.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "WXApiObject.h"
//Mob短信
#import <SMS_SDK/SMSSDK.h>

#import <MOBFoundation/MOBFDevice.h>
//友盟
#import <UMSocialCore/UMSocialCore.h>


/*
 AliPayHelper           支付宝
 WXPayHelper            微信支付
 MOBHelper              Mob短信
 UMengHelper            友盟
 TalkingDataHelper      TalkingData
 JPushHelper            极光推送
 IAPHelper              IAP内购
 MySDKHelper            其它实用方法
 */
/*************************************************************************************************/
/********************************************银联支付***********************************************/
//@interface UPAPayHelper : NSObject <UIAlertViewDelegate,UPAPayPluginDelegate>
//+(BOOL)UPAPay:(NSString*)tn
//         mode:(NSString*)mode
//viewController:(UIViewController*)viewController
//     delegate:(id<UPAPayPluginDelegate>)delegate
//andAPMechantID:(NSString* )mID;
//@end
/*************************************************************************************************/
/********************************************支付宝***********************************************/
NS_ASSUME_NONNULL_BEGIN
@interface AliPayHelper : NSObject <UIAlertViewDelegate>
+(BOOL)payForAliPayWithPartner:(NSString *)partner
                        seller:(NSString *)seller
                       tradeNO:(NSString *)tradeNO
                   productName:(NSString *)productName
            productDescription:(NSString *)productDescription
                        amount:(NSString *)amount
                     notifyURL:(NSString *)notifyURL
                    privateKey:(NSString *)privateKey
                     appScheme:(NSString *)appScheme;
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
// NOTE: 9.0以后使用新API接口
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;
@end
/*************************************************************************************************/
/*******************************************微信支付***********************************************/
@interface WXPayHelper : NSObject <UIAlertViewDelegate>
+(BOOL)payForWXPayWithViewController:(UIViewController *)controller
                           withAppid:(NSString *)appid
                       withPartnerid:(NSString *)partnerid
                        withPrepayid:(NSString *)prepayid
                      withPrivateKey:(NSString *)privateKey
                       withTimeStamp:(UInt32)timeStamp
                        withNonceStr:(NSString *)nonceStr
                            withSign:(NSString *)orderSign;
@end
/*************************************************************************************************/
/********************************************Mob短信***********************************************/
@interface MOBHelper : NSObject <UIAlertViewDelegate>
//2.0.0版本不需要前端进行验证码校验，由后台去验证并返回验证结果
//初始化
+ (void)setMobWithAppkey:(NSString *)SMMSAppKey withSecret:(NSString *)SMMSAppSecret;
//获取验证码
+(void)getVerificationCodeByMethod:(SMSGetCodeMethod)method
                       phoneNumber:(NSString *)phoneNumber
                              zone:(NSString *)zone
                  customIdentifier:(NSString *)customIdentifier
                            result:(SMSGetCodeResultHandler)result;
//获取sdk版本号
+(NSString *)SMSSDKVersion;
@end
/*************************************************************************************************/
/*********************************************友盟***********************************************/
@interface UMengHelper : NSObject
//初始化
+(void)UmengInit;
//分享文本
+ (void)shareTextToViewController:(UIViewController *)controller  PlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr onShareSucceed:(void (^)() ) share_succeed onShareCancel:(void (^)()) share_cancel;
//分享图片
+ (void)shareImageToViewController:(UIViewController *)controller  PlatformType:(UMSocialPlatformType)platformType thumbImage:(UIImage *)thumbImage shareImage:(UIImage *)shareImage onShareSucceed:(void (^)() ) share_succeed onShareCancel:(void (^)()) share_cancel;
//分享图文（新浪支持，微信/QQ仅支持图或文本分享）
+ (void)shareImageAndTextToViewController:(UIViewController *)controller  PlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage shareImage:(UIImage *)shareImage onShareSucceed:(void (^)() ) share_succeed onShareCancel:(void (^)()) share_cancel;
//分享网页
+ (void)shareWebPageToViewController:(UIViewController *)controller  PlatformType:(UMSocialPlatformType)platformType url:(NSString *)url title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage onShareSucceed:(void (^)() ) share_succeed onShareCancel:(void (^)()) share_cancel;
+ (void)getAuthWithUserInfoFromSina;
+ (void)getAuthWithUserInfoFromWechat;
+ (void)getAuthWithUserInfoFromQQ;
//若只需获取第三方平台token和uid，不获取用户名等用户信息，可以调用以下接口，如微信：
+ (void)getAuthInfoFromViewController:(UIViewController *)controller PlatformType:(UMSocialPlatformType)platformType;
//授权并获取用户信息(获取uid、access token及用户名等)
+ (void)getAuthWithUserInfoFromViewController:(UIViewController *)controller PlatformType:(UMSocialPlatformType)platformType onLoginSucceed:(void (^)(NSString *otherType,NSString *otherId,NSString *icon,NSString *nickname,NSString *unionId,NSString *token,NSString *gender)) login_succeed onLoginCancel:(void (^)(NSString *error)) login_cancel;
//取消授权
+(void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType;

@end
//*************************************************************************************************/
/*******************************************极光推送***********************************************/
@interface JPushHelper : NSObject <UIAlertViewDelegate>
//极光推送提示框风格
typedef NS_ENUM(NSInteger, JPsuhAlertType) {
    JPsuhAlertTypeNone = 0, //APP运行时不显示推送提示
    JPsuhAlertTypeDefult,   //APP运行时用默认风格显示推送提示
    JPsuhAlertTypeCustom    //APP运行时用自定义风格显示推送提示
};
//设置是否显示推送消息
+ (void) setCanShowAlert:(BOOL) show;
+ (BOOL) getCanShowAlert;
//设置显示弹框的样式
+ (void)setJPushAlertType:(JPsuhAlertType)type;
// 在应用启动的时候调用
+ (void)setupWithOptions:(NSDictionary *)launchOptions withAppKey:(NSString *)appkey withChannel:(NSString *)channel withAPSForProduction:(BOOL)isPro withJPsuhAlertType:(JPsuhAlertType)type;
//获取JPush标识此设备的 registrationID
// @discussion SDK注册成功后, 调用此接口获取到 registrationID 才能够获取到.
//* JPush 支持根据 registrationID 来进行推送.
//* 如果你需要此功能, 应该通过此接口获取到 registrationID 后, 上报到你自己的服务器端, 并保存下来.
+ (NSString *)getRegistrationID;
// 在appdelegate注册设备处调用
+ (void)registerDeviceToken:(NSData *)deviceToken;
//IOS6
+ (void)registerUserInfo:(NSDictionary *)userInfo;
// ios7以后，才有completion，否则传nil
+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;
+ (void)handleFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
// 显示本地通知在最前面
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification;
//防止乱码
+ (NSString *)logDic:(NSDictionary *)dic;
+ (void) observeAllNotifications:(id) observer;
+ (void) removeObserveAllNotifications:(id) observer;
@end
/*************************************************************************************************/
/*******************************************IAP支付***********************************************/
@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver,UIAlertViewDelegate>
@property (nonatomic, assign) BOOL isIAPReceipt;    //yes 前端验证  no 后台验证
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *payNum;
@property (nonatomic, strong) NSString *receipt;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *appleValidType;     // 0 沙盒验证接口 1 发布验证接口
@property (nonatomic, strong) SKPaymentTransaction *transaction;
//监听购买结果
+(void)addTransactionObserverWithDelegate:(nullable id <SKPaymentTransactionObserver>)delegate;
//移除监听
+(void)removeTransactionWithDelegate:(nullable id <SKPaymentTransactionObserver>)delegate;

+(void)payForIAPWithViewController:(UIViewController *)controller
                        withUserID:(NSString *)userID
                      withOrderNum:(NSString *)orderNum
                        withPayNum:(NSString *)payNum
                       withReceipt:(NSString *)receipt
                         withTotal:(NSString *)total
                withAppleValidType:(NSString *)appleValidType
                   withTransaction:(SKPaymentTransaction *)transaction
                       withReceipt:(BOOL)isIAPReceipt
                      withDelegate:(nullable id <SKProductsRequestDelegate>)delegate;
//后台验证
+(void)checkIAPReceiptWithPath;

//检查路径下是否存在凭证文件,验证receipt失败,App启动后再次验证
+(void)checkIAPReceiptWithPath:(NSString *)plistPath type:(NSInteger)type;
@end

/*******************************************其他接口***********************************************/
@interface MySDKHelper : NSObject <UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
+(NSString *)getFullImageURL:(NSString *)imageurl;
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString *)string;
//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;
//判断是否是纯汉字
+ (BOOL)isChinese:(NSString*)string;
+(BOOL)isNumbOrString:(NSString *)string;
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;
+(NSString *)signDictionary:(NSDictionary *)dic;
+(void)postAsyncWithURL:(NSString *)requestURL withParamBodyKey:(NSArray<NSString *> *)paramBodyKey withParamBodyValue:(NSArray *)paramBodyValue needToken:(NSString *)needToken postSucceed:(void (^)(NSDictionary *result))post_succeed postCancel:(void (^)(NSString *error)) post_cancel;

/**************************************选取图片和保存图片******************************************/
+ (NSString *)insetString:(NSString *)text size:(NSInteger)width;
+(NSArray *)choosecity:(NSArray *)resultArray;
+ (void)getCityName:(void (^)(NSString *city) ) login_succeed;
+ (NSString *)toJSONData:(NSDictionary *)theData;
//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName viewController:(UIViewController *)controller;
-(void) ShowCamera:(UIViewController *)controller withDelegate:(nullable id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate;
-(void)ShowAlumb:(UIViewController *)controller withDelegate:(nullable id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate;
/**************************************创建高斯模糊效果的背景******************************************/
+(UIImage *)createBlurBackground:(UIImage *)image blurRadius:(CGFloat)blurRadius;

/**************************************判断手机号码是否正确******************************************/
+ (BOOL) isMobile:(NSString *)mobileNumbel;

/*****************************************获取当前控制器*********************************************/
//获取当前屏幕中present出来的viewcontroller
+ (UIViewController *)appRootViewController;
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

/******************获取字符串的宽度和高度||获取当前时间||时间戳转时间||时间转时间戳************************/
//获取字符串的宽度和高度
+ (CGRect)getTextRectSize:(NSString *)text withFont:(UIFont *)font withSize:(CGSize)size;
//获取当前时间
+ (NSString *)getNowTimeWithDateFormat:(NSString *)dateFormat withIsNeed:(BOOL)isNeed withType:(NSInteger)type;
//时间转化成时间戳 yyyy年MM月dd日
+ (NSString *)stringToTimeStamp:(NSString *)stringTime withDateFormat:(NSString *)dateFormat withIsNeed:(BOOL)isNeed;
//时间戳转化成时间
+(NSString *)timeStampToString:(NSString *)timeStamp withDateFormat:(NSString *)dateFormat withIsNeed:(BOOL)isNeed;

/*******************************************MD5加密***********************************************/
//计算NSData 的MD5值
+(NSString*)getMD5WithData:(NSData*)data;

//计算字符串的MD5值，
+(NSString*)getmd5WithString:(NSString*)string;

//计算大文件的MD5值
+(NSString*)getFileMD5WithPath:(NSString*)path;

+ (NSString *)uploadImageToUPyun:(NSData *)fileData;

+ (void)uploadImageToUPyun:(NSData *)fileData withPolicy:(NSString *)policy withSignture:(NSString *)signture;
NS_ASSUME_NONNULL_END
@end
