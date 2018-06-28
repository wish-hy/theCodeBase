//
//  UIButton+Custom.h
//  FindingSomething
//
//  Created by 韩伟 on 16/7/20.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (Custom)

@property (strong, nonatomic) NSString  *btnTitle;          // ButtonTitle
@property (strong, nonatomic) UIColor   *btnTitleColor;     // ButtonTitleColor
@property (strong, nonatomic) UIFont    *btnTitleFont;      // ButtonTitleFont
@property (strong, nonatomic) UIImage   *btnBackgroundImg;  // 背景图

// 打电话
- (void)buttonCallUpToNumber:(NSString *)number;

// 左文字右图标
- (void)setRightIconWithIcon:(NSString *)iconPath andTitleFontSize:(CGFloat)fontSize andKongWidth:(CGFloat)kongWidth;

// 右文字左图标
- (void)setLeftIconWithIcon:(NSString *)iconPath andTitleFontSize:(CGFloat)fontSize andKongWidth:(CGFloat)kongWidth;

@end
