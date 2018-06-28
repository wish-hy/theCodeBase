//
//  UPAPayViewController.h
//  huabi
//
//  Created by TeamMac2 on 16/9/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "APAuthV2Info.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"                   // 导入订单类
#import "DataSigner.h"              // 生成signer的类：获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode

@interface UPAPayViewController : UIViewController 
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *recharge;
@property (nonatomic,assign) NSInteger package;//!<套餐类型
@property (nonatomic,strong) NSString *base_rate;
@property(nonatomic,copy)NSString *gift;//!<选择的套餐礼品
@property(nonatomic,copy)NSString *recommend;//!<recommend
@property(nonatomic,copy)NSString *address_id;//!<选择的收货地址
@property (nonatomic, assign) BOOL chongzhi;
@property(nonatomic,assign) BOOL taocanchongzhi;
//成为推广者
@property(nonatomic,assign)BOOL bePromoter;
@property(nonatomic,strong)NSDictionary *pInfo;

@end
