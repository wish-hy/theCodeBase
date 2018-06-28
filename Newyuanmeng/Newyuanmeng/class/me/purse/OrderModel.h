//
//  OrderModel.h
//  huabi
//
//  Created by huangyang on 2017/12/14.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, assign) NSInteger pending;

@property (nonatomic, assign) NSInteger todayamount;

@property (nonatomic, assign) NSInteger unreceived;

@property (nonatomic, assign) NSInteger uncomment;

@property (nonatomic, assign) NSInteger undelivery;

@end
