//
//  ScanCodeOrderCell.h
//  huabi
//
//  Created by huangyang on 2017/12/22.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCodeOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *payMan;

@property (weak, nonatomic) IBOutlet UILabel *payMethod;
@property (weak, nonatomic) IBOutlet UIImageView *payImage;

@property (weak, nonatomic) IBOutlet UILabel *money;
+(ScanCodeOrderCell *)creatCell:(UITableView *)table;
@end
