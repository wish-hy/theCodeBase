//
//  ShopInfoViewCell.m
//  huabi
//
//  Created by huangyang on 2017/12/12.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ShopInfoViewCell.h"


@implementation ShopInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setStartNumber:(NSInteger )startNumber{
    self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 24) numberOfStars:startNumber];
    self.starRateView.scorePercent = 0.5;
    self.starRateView.allowIncompleteStar = YES;
    self.starRateView.hasAnimation = YES;
    [self.goodReputation addSubview:self.starRateView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
