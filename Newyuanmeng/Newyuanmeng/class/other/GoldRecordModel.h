//
//  GoldRecordModel.h
//  huabi
//
//  Created by TeamMac2 on 17/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface GoldRecordModel : JSONModel


@property(nonatomic,copy)NSString *order_no;//!<订单编号
@property(nonatomic,copy)NSString *amount;//!<支出或获得
@property(nonatomic,copy)NSString *type;//!<类型
@property(nonatomic,copy)NSString *log_time;//!<时间

@end
