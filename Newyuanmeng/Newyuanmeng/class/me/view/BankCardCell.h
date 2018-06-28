//
//  BankCardCell.h
//  huabi
//
//  Created by hy on 2017/12/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankImage;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UIButton *isSelect;

+(BankCardCell *)creatCell:(UITableView *)table;

@end
