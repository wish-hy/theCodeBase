//
//  ScanCodeOrderCell.m
//  huabi
//
//  Created by huangyang on 2017/12/22.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ScanCodeOrderCell.h"

@implementation ScanCodeOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(ScanCodeOrderCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"ScanCodeOrderCell";
    ScanCodeOrderCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ScanCodeOrderCell" owner:self options:nil][0];
    }
    return cell;
}

@end
