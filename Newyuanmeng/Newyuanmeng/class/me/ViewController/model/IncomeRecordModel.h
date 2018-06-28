//
//  IncomeRecordModel.h
//  huabi
//
//  Created by hy on 2018/1/12.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeRecordModel : NSObject

@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *valid_income_change; // 可用收益
@property(nonatomic,copy)NSString *frezze_income_change; // 待解锁
@property(nonatomic,copy)NSString *settled_income_change;// 已提取
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *note;


@end
