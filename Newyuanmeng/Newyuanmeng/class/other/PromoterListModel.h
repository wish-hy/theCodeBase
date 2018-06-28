//
//  PromoterListModel.h
//  huabi
//
//  Created by teammac3 on 2017/3/31.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface PromoterListModel : JSONModel

@property(nonatomic,copy)NSString *district_id;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;

@end
