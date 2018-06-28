//
//  CoreButton.h
//  study
//
//  Created by hy on 2018/5/23.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CoreButton : UIButton

@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,strong) IBInspectable UIColor *borderColor;
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;

- (instancetype)initWithFrame:(CGRect)frame withCornerRadius:(CGFloat)cornerRadius withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor *)color;

@end
