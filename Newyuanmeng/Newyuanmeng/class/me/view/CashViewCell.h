//
//  CashViewCell.h
//  huabi
//
//  Created by hy on 2018/1/23.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weekDay;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *status;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *moneyGo;

@property (weak, nonatomic) IBOutlet UILabel *moneyStatus;

+(CashViewCell *)creatCell:(UITableView *)table;
@end
