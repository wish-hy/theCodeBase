//
//  UserBalance.h
//  huabi
//
//  Created by huangyang on 2017/12/14.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerModel.h"
#import "OrderModel.h"

@interface UserBalance : NSObject
@property (nonatomic,strong)CustomerModel *customer;
@property (nonatomic,strong)OrderModel *order;

@end
