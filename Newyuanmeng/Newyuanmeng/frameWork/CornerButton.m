//
//  CornerButton.m
//  tianying
//
//  Created by hy on 2017/9/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CornerButton.h"

@implementation CornerButton

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

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth < 0) {
        return;
    }
    self.layer.borderWidth = borderWidth;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

@end
