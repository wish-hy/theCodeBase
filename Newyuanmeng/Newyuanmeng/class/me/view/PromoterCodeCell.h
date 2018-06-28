//
//  PromoterCodeCell.h
//  huabi
//
//  Created by hy on 2018/1/22.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoterCodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Code;
@property (weak, nonatomic) IBOutlet UILabel *codeStatus;

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *label;

+(PromoterCodeCell *)creatCell:(UITableView *)table;
@end
