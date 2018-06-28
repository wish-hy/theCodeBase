//
//  HYEssenceCell.m
//  study
//
//  Created by hy on 2018/4/24.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYEssenceCell.h"

@implementation HYEssenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (HYEssenceCell *)creatCellInTableView:(UITableView *)tableView
{
    HYEssenceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYEssenceCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYEssenceCell" owner:nil options:nil] firstObject];
//        cell = [[HYEssenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
