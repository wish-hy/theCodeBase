//
//  SaleRecordModel.h
//  huabi
//
//  Created by teammac3 on 2017/3/31.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface SaleRecordModel : JSONModel

@property(nonatomic,copy)NSString *district_id;
@property(nonatomic,copy)NSString *weekday;
@property(nonatomic,copy)NSString *month;
@property(nonatomic,copy)NSString *img_url;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *income;
@property(nonatomic,copy)NSString *sell_num;
@property(nonatomic,copy)NSString *unit_price;

@end
