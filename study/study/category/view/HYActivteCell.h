//
//  HYActivteCell.h
//  study
//
//  Created by hy on 2018/4/24.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYActivteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *activteName;
@property (weak, nonatomic) IBOutlet UILabel *activteInfo;

+ (HYActivteCell *)creatCellInTableView:(UITableView *)tableView;

@end
