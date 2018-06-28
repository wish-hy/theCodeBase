
//
//  UIButton+Custom.m
//  FindingSomething
//
//  Created by 韩伟 on 16/7/20.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

@dynamic btnTitle;

@dynamic btnTitleFont;

@dynamic btnTitleColor;

@dynamic btnBackgroundImg;


// 按钮的标题
- (void)setBtnTitle:(NSString *)btnTitle
{
    [self setTitle:btnTitle forState:UIControlStateNormal];
    [self setTitle:btnTitle forState:UIControlStateHighlighted];
}

// 按钮的标题颜色
- (void)setBtnTitleColor:(UIColor *)btnTitleColor
{
    [self setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [self setTitleColor:btnTitleColor forState:UIControlStateHighlighted];
}

// 按钮的标题字体大小
- (void)setBtnTitleFont:(UIFont *)btnTitleFont
{
    [self.titleLabel setFont:btnTitleFont];
}

// 设置背景图
- (void)setBtnBackgroundImg:(UIImage *)btnBackgroundImg
{
    [self setImage:btnBackgroundImg forState:UIControlStateNormal];
    [self setImage:btnBackgroundImg forState:UIControlStateHighlighted];
}

// 打电话
- (void)buttonCallUpToNumber:(NSString *)number
{
    NSString *str = [NSString stringWithFormat:@"tel:%@", number];
    
    UIWebView *callWebView = [[UIWebView alloc]init];
    
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self addSubview:callWebView];
}

// 左文字有右图标
- (void)setRightIconWithIcon:(NSString *)iconPath andTitleFontSize:(CGFloat)fontSize andKongWidth:(CGFloat)kongWidth
{
    UILabel *lab = [[UILabel alloc] init];
    lab.text = self.titleLabel.text;
    [UILabel creatCustomLableWidthAndHeight:lab andFontSize:fontSize];
    
    UIImage *img = IMAGE(iconPath);
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:img forState:UIControlStateHighlighted];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -img.size.width-kongWidth, 0, img.size.width+kongWidth)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, lab.width+kongWidth, 0, -lab.width-kongWidth)];
}

// 右文字左图标
- (void)setLeftIconWithIcon:(NSString *)iconPath andTitleFontSize:(CGFloat)fontSize andKongWidth:(CGFloat)kongWidth
{
    UILabel *lab = [[UILabel alloc] init];
    lab.text = self.titleLabel.text;
    [UILabel creatCustomLableWidthAndHeight:lab andFontSize:fontSize];
    
    UIImage *img = IMAGE(iconPath);
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:img forState:UIControlStateHighlighted];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, img.size.width+kongWidth, 0, -img.size.width-kongWidth)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -lab.width-kongWidth, 0, lab.width+kongWidth)];
}

@end
