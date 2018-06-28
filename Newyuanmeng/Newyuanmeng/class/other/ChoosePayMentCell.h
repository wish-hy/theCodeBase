//
//  ChoosePayMentCell.h
//  huabi
//
//  Created by hy on 2018/1/2.
//  Copyright © 2018年 ltl. All rights reserved.
//  支付方式某一行cell

#import <UIKit/UIKit.h>


@interface ChoosePayMentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payMentIcon;
@property (weak, nonatomic) IBOutlet UILabel *payMentName;

@property (weak, nonatomic) IBOutlet UIButton *isSelect;  // 是否选中

+(ChoosePayMentCell *)creatCell:(UITableView *)table;
@end
