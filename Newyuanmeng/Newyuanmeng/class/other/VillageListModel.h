//
//  VillageListModel.h
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface VillageListModel : JSONModel

//id
@property(nonatomic,copy)NSString *district_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *valid_income;
@property(nonatomic,copy)NSString *frezze_income;
@property(nonatomic,copy)NSString *settled_income;

@end
