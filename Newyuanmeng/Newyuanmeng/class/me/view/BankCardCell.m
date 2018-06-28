//
//  BankCardCell.m
//  huabi
//
//  Created by hy on 2017/12/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "BankCardCell.h"

@implementation BankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)layoutSubviews
{
    [self.isSelect setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e69d", 30, [UIColor colorWithHexString:@"dddddd"])] forState:UIControlStateNormal];
    [self.isSelect setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e68b", 30, [UIColor colorWithHexString:@"e84f37"])] forState:UIControlStateSelected];
}

+(BankCardCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"BankCardCell";
    BankCardCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"BankCardCell" owner:self options:nil][0];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
