//
//  HYActivteCell.m
//  study
//
//  Created by hy on 2018/4/24.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYActivteCell.h"

@implementation HYActivteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (HYActivteCell *)creatCellInTableView:(UITableView *)tableView
{
    HYActivteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYActivteCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYActivteCell" owner:nil options:nil] firstObject];
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
