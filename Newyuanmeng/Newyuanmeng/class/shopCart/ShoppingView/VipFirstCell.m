//
//  VipFirstCell.m
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "VipFirstCell.h"

@implementation VipFirstCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canBuy = YES;
        [self setImageWithBtn];
    } 
    return self;
}

-(void)setImageWithBtn{
    self.icon = [UIButton new];
    [self.icon addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(20*ScaleWidth);
        make.width.height.mas_equalTo(204*ScaleWidth);
        make.top.mas_equalTo(self.mas_top).mas_offset(0*ScaleWidth);
    }];
    
    self.title = [UILabel new];
    self.title.textColor = color_title_main;
    self.title.backgroundColor = color_clear;
    self.title.font = MyFontSize(22*ScaleWidth);
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.numberOfLines = 1;
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(20*ScaleWidth);
        make.top.mas_equalTo(self.mas_top).mas_offset(10*ScaleWidth);
        make.height.mas_equalTo(22*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20*ScaleWidth);
    }];
    
    self.price = [UILabel new];
    self.price.textColor = color_red_shen;
    self.price.backgroundColor = color_clear;
    self.price.font = MyFontSize(26*ScaleWidth);
    self.price.textAlignment = NSTextAlignmentLeft;
    self.price.numberOfLines = 1;
    [self.contentView addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(20*ScaleWidth);
        make.top.mas_equalTo(self.title.mas_bottom).mas_offset(34*ScaleWidth);
        make.height.mas_equalTo(26*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20*ScaleWidth);
    }];
    
    
    self.buyBack = [UIView new];
    self.buyBack.backgroundColor = color_red_shen;
    self.buyBack.layer.cornerRadius = 10*ScaleWidth;
    self.buyBack.layer.masksToBounds = YES;
    [self.contentView addSubview:self.buyBack];
    [self.buyBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(20*ScaleWidth);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-26*ScaleWidth);
        make.height.mas_equalTo(88*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20*ScaleWidth);
    }];
    
    self.buy = [UILabel new];
    self.buy.textColor = color_white;
    self.buy.backgroundColor = color_clear;
    self.buy.font = MyFontSize(26*ScaleWidth);
    self.buy.textAlignment = NSTextAlignmentCenter;
    self.buy.numberOfLines = 1;
    [self.buyBack addSubview:self.buy];
    [self.buy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buyBack.mas_top).mas_offset(16*ScaleWidth);
        make.height.mas_equalTo(26*ScaleWidth);
        make.centerX.mas_equalTo(self.buyBack);
    }];
    
    self.count = [UILabel new];
    self.count.textColor = color_white;
    self.count.backgroundColor = color_clear;
    self.count.font = MyFontSize(22*ScaleWidth);
    self.count.textAlignment = NSTextAlignmentCenter;
    self.count.numberOfLines = 1;
    [self.buyBack addSubview:self.count];
    [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buyBack.mas_bottom).mas_offset(-14*ScaleWidth);
        make.height.mas_equalTo(22*ScaleWidth);
        make.centerX.mas_equalTo(self.buyBack);
    }];
    
    UIButton *buyBtn = [UIButton new];
    [buyBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyBack addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.buyBack);
        make.width.height.mas_equalTo(self.buyBack);

    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = color_Bottom_Line;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(1*ScaleWidth);
    }];

}

-(void)buyClick:(UIButton *)sender
{
    if (self.canBuy) {
        if (_buyClick) {
            _buyClick(self.tag);
        }
    }
}

-(void)iconClick:(UIButton *)sender
{
    if (_iconClick) {
        _iconClick(self.tag);
    }
}

-(void)setImageWithTitle:(NSString *)title image:(NSString *)image price1:(NSString *)price1 price2:(NSString *)price2 count:(NSInteger)count
{
    [self.icon setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image]]] forState:UIControlStateNormal];
    
    self.title.text = title;
    self.price.text = [NSString stringWithFormat:@"¥%@+%@华点",price1,price2];
    self.count.text = [NSString stringWithFormat:@"剩余%ld件",(long)count];
    if (count == 0) {
        self.buy.text = @"已售完";
        self.buyBack.backgroundColor = color_background;
        self.canBuy = NO;
    }else{
        self.buy.text = @"立即购买";
        self.buyBack.backgroundColor = color_red_shen;
        self.canBuy = YES;
    }
}

@end
