//
//  HuaBiViewController.h
//  huabi
//
//  Created by TeamMac2 on 16/12/14.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuaBiViewController : UIViewController

@property (nonatomic, strong) NSString *huabipayAmount;
@property (nonatomic, strong) NSString *otherpayAmount;
@property (nonatomic, strong) NSString *shophuabiaccount;

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSArray<NSDictionary *> *dicArr;

@property (nonatomic, assign) NSInteger alipay;
@property (nonatomic, assign) NSInteger jindianPay;
@property (nonatomic, assign) NSInteger wxPay;
@property (nonatomic, assign) NSInteger applePay;
@property (nonatomic, assign) NSInteger huadianPay;

@end
