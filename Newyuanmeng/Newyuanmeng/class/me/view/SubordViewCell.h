//
//  SubordViewCell.h
//  huabi
//
//  Created by hy on 2018/1/22.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubordViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CoreImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *name;

+(SubordViewCell *)creatCell:(UITableView *)table;
@end
