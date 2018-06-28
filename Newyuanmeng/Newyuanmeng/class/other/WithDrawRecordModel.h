//
//  WithDrawRecordModel.h
//  huabi
//
//  Created by teammac3 on 2017/3/31.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface WithDrawRecordModel : JSONModel

@property(nonatomic,copy)NSString *district_id;
@property(nonatomic,copy)NSString *weekday;
@property(nonatomic,copy)NSString *month;
@property(nonatomic,copy)NSString *status_icon;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *settle_type;
@property(nonatomic,copy)NSString *status;

@end
