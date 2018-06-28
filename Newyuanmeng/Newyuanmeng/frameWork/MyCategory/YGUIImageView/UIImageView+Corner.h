//
//  UIImageView+Corner.h
//  MyTestProject
//
//  Created by 韩伟 on 15/5/21.
//  Copyright (c) 2015年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Corner)

#pragma mark 设置圆形图片
- (UIImageView *)circleImageView;

#pragma mark 设置图片自适应
- (UIImageView *)autoresizingImageView;

@end
