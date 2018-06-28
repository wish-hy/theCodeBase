//
//  HYEssenceCell.h
//  study
//
//  Created by hy on 2018/4/24.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYEssenceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet CoreImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;

+ (HYEssenceCell *)creatCellInTableView:(UITableView *)tableView;

@end
