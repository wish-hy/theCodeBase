//
//  PromoterCodeCell.m
//  huabi
//
//  Created by hy on 2018/1/22.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "PromoterCodeCell.h"

@implementation PromoterCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(PromoterCodeCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"PromoterCodeCell";
    PromoterCodeCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PromoterCodeCell" owner:self options:nil][0];
    }
    return cell;
}

@end
