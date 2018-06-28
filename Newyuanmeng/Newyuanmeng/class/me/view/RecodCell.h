//
//  RecodCell.h
//  huabi
//
//  Created by hy on 2017/12/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *event;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *money;

+(RecodCell *)creatCell:(UITableView *)table;

@end
