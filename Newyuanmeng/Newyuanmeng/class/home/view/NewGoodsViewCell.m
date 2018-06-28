//
//  NewGoodsViewCell.m
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//  新品专区

#import "NewGoodsViewCell.h"

@implementation NewGoodsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.banner.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClick)];
    [self.banner addGestureRecognizer:tap];
    self.everyDayFound.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Found)];
    [self.everyDayFound addGestureRecognizer:tap2];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(_everyDayFound.mas_left);
        make.top.mas_equalTo(self.mas_top).offset(8);
        make.height.mas_equalTo(self.height - 8);
    }];
    
    [_everyDayFound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top).offset(8);
        make.left.mas_equalTo(_banner.mas_right);
        make.width.mas_equalTo(self.height - 8);
        make.height.mas_equalTo(self.height - 8);
    }];
}

-(void)bannerClick
{
    self.selectBanner();
}

-(void)Found
{
    self.selectFount();
}

@end
