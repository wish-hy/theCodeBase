//
//  VIPCell.m
//  huabi
//
//  Created by teammac3 on 2017/6/2.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "VIPCell.h"

@implementation VIPCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setImageWithBtn];
    }
    return self;
}

-(void)setImageWithBtn{
    self.icon = [UIImageView new];
//    self.icon.backgroundColor = [UIColor yellowColor];
    self.icon.image = [UIImage imageNamed:@"moren"];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(10*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10*ScaleWidth);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(200*ScaleWidth);
    }];
    
    self.title = [UILabel new];
    self.title.textColor = color_title_main;
    self.title.backgroundColor = color_clear;
    self.title.font = MyFontSize(22*ScaleWidth);
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.numberOfLines = 0;
    self.title.text = @"";
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(5*ScaleWidth);
        make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(60*ScaleWidth);
        make.right.mas_equalTo(self).mas_offset(-5*ScaleWidth);
    }];
    
    UIButton *buyBtn = [UIButton new];
    [buyBtn setTitle:@"查看" forState:UIControlStateNormal];
    buyBtn.backgroundColor = color_red_shen;
    buyBtn.titleLabel.font = MyFontSize(22*ScaleWidth);
    buyBtn.layer.cornerRadius = 10*ScaleWidth;
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-26*ScaleWidth);
        make.width.mas_equalTo(100*ScaleWidth);
        make.height.mas_equalTo(45*ScaleHeight);
//        make.centerY.mas_equalTo(self);
    }];
  
}

@end
