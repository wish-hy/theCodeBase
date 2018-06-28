//
//  SaleRecordCell.h
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDrawRecordModel.h"
#import "IncomeRecordModel.h"

@interface SaleRecordCell : UITableViewCell

+(SaleRecordCell *)creatCell:(UITableView *)table;
-(void)setTime:(NSString *)time AvailableIncome:(NSString *)availableIncome UnlockedIncome:(NSString *)unlockedIncome ExtractedIncome:(NSString *)extractedIncome Describe:(NSString *)describe Status:(NSString *)status;

@end
