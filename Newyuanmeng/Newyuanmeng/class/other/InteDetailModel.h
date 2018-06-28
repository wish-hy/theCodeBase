//
//  InteDetailModel.h
//  huabi
//
//  Created by teammac3 on 2017/6/7.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface InteDetailModel : JSONModel
@property(nonatomic,copy)NSString *InteID;
@property(nonatomic,copy)NSString *admin_id;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *current_amount;
@property(nonatomic,copy)NSString *order_no;//订单号
@property(nonatomic,copy)NSString *amount;//数额
@property(nonatomic,copy)NSString *log_date;//日期
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *note;//备注

@end
