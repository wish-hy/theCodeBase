//
//  pend_districtModel.h
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface pend_districtModel : JSONModel

//id
@property(nonatomic,copy)NSString *district_id;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSString *linkman;
@property(nonatomic,copy)NSString *linkmobile;
@property(nonatomic,copy)NSString *apply_time;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *pay_status;


@end
