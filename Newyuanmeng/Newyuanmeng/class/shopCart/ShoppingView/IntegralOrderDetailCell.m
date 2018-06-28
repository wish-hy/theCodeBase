//
//  IntegralOrderDetailCell.m
//  huabi
//
//  Created by teammac3 on 2017/4/18.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "IntegralOrderDetailCell.h"

@implementation IntegralOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _goodsName.numberOfLines = 0;
    [_goodsName sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
