//
//  MyInviteGenerCell.h
//  huabi
//
//  Created by hy on 2018/1/6.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInviteGenerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *catgroy;


+(MyInviteGenerCell *)creatCell:(UITableView *)table;
@end
