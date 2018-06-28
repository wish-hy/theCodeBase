//
//  MyRedBagViewCell.h
//  huabi
//
//  Created by hy on 2018/1/9.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRedBagViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *redBagType;
@property (weak, nonatomic) IBOutlet UILabel *redBagFrom;
@property (weak, nonatomic) IBOutlet UILabel *redBagStatus;



+(MyRedBagViewCell *)creatCell:(UITableView *)table;

@end
