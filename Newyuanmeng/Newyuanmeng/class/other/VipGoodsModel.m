//
//  VipGoodsModel.m
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "VipGoodsModel.h"

@implementation VipGoodsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.goodsID = @"";
        self.huabipay_amount = @"";
        self.goodsImg = @"";
        self.goodsCount = 0;
        self.goodsName = @"";
        self.market_price = @"";
        self.still_pay = @"";
        self.sell_price = @"";
        self.huabipay_set = @"";
        
    }
    return self;
}

-(void)setDictionayInfo:(NSDictionary *)info
{
    self.goodsID = [NSString stringWithFormat:@"%@",info[@"id"]];
    self.goodsImg = [MySDKHelper getFullImageURL:[NSString stringWithFormat:@"%@",info[@"img"]]];
    self.goodsName = [NSString stringWithFormat:@"%@",info[@"name"]];
    self.goodsCount = [[NSString stringWithFormat:@"%@",info[@"store_nums"]]integerValue];
    self.huabipay_amount = [NSString stringWithFormat:@"%@",info[@"huabipay_amount"]];
    self.still_pay = [NSString stringWithFormat:@"%@",info[@"still_pay"]];
    self.market_price = [NSString stringWithFormat:@"%@",info[@"market_price"]];
    self.sell_price = [NSString stringWithFormat:@"%@",info[@"sell_price"]];
    self.huabipay_set = [NSString stringWithFormat:@"%@",info[@"huabipay_set"]];

}
@end
