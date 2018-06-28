//
//  SubordViewCell.m
//  huabi
//
//  Created by hy on 2018/1/22.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "SubordViewCell.h"

@implementation SubordViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(SubordViewCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"SubordViewCell";
    SubordViewCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SubordViewCell" owner:self options:nil][0];
    }
    return cell;
}
@end
