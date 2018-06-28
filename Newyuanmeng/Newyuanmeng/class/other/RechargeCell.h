//
//  RechargeCell.h
//  huabi
//
//  Created by huangyang on 2017/11/13.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RechargeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UIImageView *next;

@property (weak, nonatomic) IBOutlet UITextField *textfiled2;
@property (nonatomic,copy)void(^block)(NSString *);

+(RechargeCell *)creatCell:(UITableView *)table;

@end
