//
//  CashViewCell.m
//  huabi
//
//  Created by hy on 2018/1/23.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "CashViewCell.h"

@implementation CashViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(CashViewCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"CashViewCell";
    CashViewCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CashViewCell" owner:self options:nil][0];
    }
    return cell;
}

@end
