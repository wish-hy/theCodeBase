//
//  VipGoodsModel.h
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipGoodsModel : NSObject

@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, strong) NSString *still_pay;
@property (nonatomic, strong) NSString *market_price;
@property (nonatomic, strong) NSString *sell_price;
@property (nonatomic, assign) NSInteger goodsCount;
@property (nonatomic, strong) NSString *goodsImg;
@property (nonatomic, strong) NSString *huabipay_set;
@property (nonatomic, strong) NSString *huabipay_amount;

-(void)setDictionayInfo:(NSDictionary *)info;

@end
