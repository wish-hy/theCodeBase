//
//  RecodCell.m
//  huabi
//
//  Created by hy on 2017/12/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "RecodCell.h"

@implementation RecodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(RecodCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"RecodCell";
    RecodCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RecodCell" owner:self options:nil][0];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
