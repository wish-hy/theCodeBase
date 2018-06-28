//
//  CoreImageView.h
//  huabi
//
//  Created by huangyang on 2017/11/20.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CoreImageView : UIImageView

@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,strong) IBInspectable UIColor *borderColor;
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;

- (instancetype)initWithFrame:(CGRect)frame withCornerRadius:(CGFloat)cornerRadius withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor *)color;

@end
