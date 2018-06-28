//
//  CornerButton.h
//  tianying
//
//  Created by hy on 2017/9/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CornerButton : UIButton

@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,strong) IBInspectable UIColor *borderColor;
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;

- (instancetype)initWithFrame:(CGRect)frame withCornerRadius:(CGFloat)cornerRadius withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor *)color;

@end
