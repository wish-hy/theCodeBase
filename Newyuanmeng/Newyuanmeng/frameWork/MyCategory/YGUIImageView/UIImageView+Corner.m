//
//  UIImageView+Corner.m
//  MyTestProject
//
//  Created by 韩伟 on 15/5/21.
//  Copyright (c) 2015年 韩伟. All rights reserved.
//

#import "UIImageView+Corner.h"
#define PI 3.14159265358979323846

@implementation UIImageView (Corner) 

#pragma mark 设置圆形图片
- (UIImageView *)circleImageView
{
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
    return self;
}

#pragma mark 设置图片自适应
- (UIImageView *)autoresizingImageView
{
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds  = YES;
    return self;
}

@end
