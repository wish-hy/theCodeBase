//
//  VipSecondCell.m
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "VipSecondCell.h"

@implementation VipSecondCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImageWithBtn];
    }
    return self;
}

-(void)setImageWithBtn{
    self.icon = [UIButton new];
    [self.icon addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(24*ScaleWidth);
        make.width.height.mas_equalTo(ScreenWidth/2.0-48*ScaleWidth);
        make.top.mas_equalTo(self.mas_top).mas_offset(24*ScaleWidth);
    }];
    
    self.title = [UILabel new];
    self.title.textColor = color_title_main;
    self.title.backgroundColor = color_clear;
    self.title.font = MyFontSize(22*ScaleWidth);
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.numberOfLines = 2;
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(24*ScaleWidth);
        make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(24*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-24*ScaleWidth);
    }];
    
    self.costPrice = [UILabel new];
    self.costPrice.textColor = color_red_shen;
    self.costPrice.backgroundColor = color_clear;
    self.costPrice.font = MyFontSize(22*ScaleWidth);
    self.costPrice.textAlignment = NSTextAlignmentLeft;
    self.costPrice.numberOfLines = 1;
    [self.contentView addSubview:self.costPrice];
    [self.costPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(24*ScaleWidth);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-24*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-24*ScaleWidth);
        make.height.mas_equalTo(22*ScaleWidth);
        
    }];
    
    self.price = [UILabel new];
    self.price.textColor = color_title_Gray;
    self.price.backgroundColor = color_clear;
    self.price.font = MyFontSize(22*ScaleWidth);
    self.price.textAlignment = NSTextAlignmentLeft;
    self.price.numberOfLines = 1;
    [self.contentView addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(24*ScaleWidth);
        make.bottom.mas_equalTo(self.costPrice.mas_top).mas_offset(-13*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-24*ScaleWidth);
        make.height.mas_equalTo(22*ScaleWidth);
    }];

    UIView *line1 = [UIView new];
    line1.backgroundColor = color_Bottom_Line;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(0*ScaleWidth);
        make.top.mas_equalTo(self.mas_top).mas_offset(0*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(0.5*ScaleWidth);
    }];

    UIView *line2 = [UIView new];
    line2.backgroundColor = color_Bottom_Line;
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(0*ScaleWidth);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(0*ScaleWidth);
        make.width.mas_equalTo(0.5*ScaleWidth);
    }];

    UIView *line3 = [UIView new];
    line3.backgroundColor = color_Bottom_Line;
    [self.contentView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(0*ScaleWidth);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(0.5*ScaleWidth);
    }];

    UIView *line4 = [UIView new];
    line4.backgroundColor = color_Bottom_Line;
    [self.contentView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(0*ScaleWidth);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0*ScaleWidth);
        make.left.mas_equalTo(self.mas_left).mas_offset(0*ScaleWidth);
        make.width.mas_equalTo(0.5*ScaleWidth);
    }];

}

-(void)iconClick:(UIButton *)sender
{
    if (_iconClick) {
        _iconClick(self.tag);
    }
}

-(void)setImageWithTitle:(NSString *)title image:(NSString *)image price:(NSString *)price price1:(NSString *)price1 price2:(NSString *)price2
{
    [self.icon setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image]]] forState:UIControlStateNormal];
    
    self.title.text = title;
    self.costPrice.text = [NSString stringWithFormat:@"¥%@+%@华点",price1,price2];
    self.price.text = [NSString stringWithFormat:@"¥%@",price];
}
@end
