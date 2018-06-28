//
//  CoreButton.m
//  study
//
//  Created by hy on 2018/5/23.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "CoreButton.h"

@implementation CoreButton
- (instancetype)initWithFrame:(CGRect)frame withCornerRadius:(CGFloat)cornerRadius withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = cornerRadius > 0;
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = borderWidth;
    }
    return self;
}

#pragma mark - IBInspectable

//- (void)setBorderColor:(UIColor *)borderColor {
//    self.layer.borderColor = borderColor.CGColor;
//}
//
//- (void)setBorderWidth:(CGFloat)borderWidth {
//    if (borderWidth < 0) {
//        return;
//    }
//    self.layer.borderWidth = borderWidth;
//}
//- (void)setCornerRadius:(CGFloat)cornerRadius {
//    self.layer.cornerRadius = cornerRadius;
//    self.layer.masksToBounds = cornerRadius > 0;
//}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    if (borderWidth < 0) return;
    
    self.layer.borderWidth = borderWidth;
}

/**
 *  设置边框颜色
 *
 *  @param borderColor 可视化视图传入的值
 */
- (void)setBorderColor:(UIColor *)borderColor {
    
    self.layer.borderColor = borderColor.CGColor;
}

/**
 *  设置圆角
 *
 *  @param cornerRadius 可视化视图传入的值
 */
- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

@end
