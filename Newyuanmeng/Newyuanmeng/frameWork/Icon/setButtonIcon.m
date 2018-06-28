//
//  setButtonIcon.m
//  huabi
//
//  Created by teammac3 on 2017/3/28.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "setButtonIcon.h"

@implementation setButtonIcon

+(void)setButtonIcon:(id)obj withText:(NSString *)text withSize:(CGFloat)size withColor:(UIColor *)fColor withBgColor:(UIColor *)bgColor{
    
    UIButton *btn = obj;
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size:size];
    btn.titleLabel.font = iconfont;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:fColor forState:UIControlStateNormal];
    [btn setBackgroundColor:bgColor];
}

@end
