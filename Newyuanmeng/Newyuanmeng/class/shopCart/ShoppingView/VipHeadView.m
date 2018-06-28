//
//  VipHeadView.m
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "VipHeadView.h"

@implementation VipHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *back = [UIView new];
        back.backgroundColor = color_white;
        [self addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top).mas_offset(0);
            make.width.mas_equalTo(ScreenWidth);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        }];
        
        self.name = [UILabel new];
        self.name.textColor = color_title_main;
        self.name.backgroundColor = color_clear;
        self.name.font = MyFontSize(28*ScaleWidth);
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.numberOfLines = 0;
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(22*ScaleWidth);
            make.left.mas_equalTo(self.mas_left).mas_offset(20*ScaleWidth);
            make.height.mas_equalTo(28*ScaleWidth);
        }];
        
        self.line = [UIView new];
        self.line.backgroundColor = color_Bottom_Line;
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0*ScaleWidth);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(0.5*ScaleWidth);
        }];
        
        
    }
    return self;
}

-(void)setImagesWithTitle:(NSString *)title type:(NSInteger)type
{
    self.name.text = title;
    if (type == 0) {
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset((22)*ScaleWidth);
        }];
        self.line.hidden = YES;
    }else{
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset((26)*ScaleWidth);
        }];
        self.line.hidden = NO;
    }
    
}

@end
