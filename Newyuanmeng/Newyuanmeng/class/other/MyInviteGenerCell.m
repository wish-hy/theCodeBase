//
//  MyInviteGenerCell.m
//  huabi
//
//  Created by hy on 2018/1/6.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "MyInviteGenerCell.h"

@implementation MyInviteGenerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(MyInviteGenerCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"MyInviteGenerCell";
    MyInviteGenerCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyInviteGenerCell" owner:self options:nil][0];
    }
    return cell;
}

@end
