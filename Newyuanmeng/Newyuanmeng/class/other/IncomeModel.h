//
//  IncomeModel.h
//  huabi
//
//  Created by teammac3 on 2017/4/5.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface IncomeModel : JSONModel

@property(nonatomic,copy)NSString *valid_income;
@property(nonatomic,copy)NSString *frezze_income;
@property(nonatomic,copy)NSString *settled_income;

@end
