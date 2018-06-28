//
//  MyRedBagViewCell.m
//  huabi
//
//  Created by hy on 2018/1/9.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "MyRedBagViewCell.h"

@implementation MyRedBagViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(MyRedBagViewCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"MyRedBagViewCell";
    MyRedBagViewCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyRedBagViewCell" owner:self options:nil][0];
    }
    return cell;
}

@end
