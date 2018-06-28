//
//  SilverRecordModel.h
//  huabi
//
//  Created by TeamMac2 on 17/3/31.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface SilverRecordModel : JSONModel

@property(nonatomic,copy)NSString *order_no;//!<订单编号
@property(nonatomic,copy)NSString *amount;//!<支出或获得
@property(nonatomic,copy)NSString *type;//!<类型
@property(nonatomic,copy)NSString *log_time;//!<银点记录的时间
@property(nonatomic,copy)NSString *time;//!<金点记录的时间


@end
