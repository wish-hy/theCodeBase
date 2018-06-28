//
//  UILabel+SizeToFit.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/28.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SizeToFit)

/**
 *  根据宽纵向自适应，多行
 *
 *  @param width 宽
 */
-(void)sizeToFitVerticalWithMaxWidth:(float)width;

/**
 *  根据宽横向自适应，一行
 */
-(void)sizeToFitHorizontal;

/**
 *  富文本颜色
 *
 *  @param string      要显示的字符串
 *  @param fromArray   从数组
 *  @param toArray     到数组
 *  @param colorsArray 颜色数组
 */
-(void)addAttributedWithString:(NSString *)string range:(NSRange)range color:(UIColor *)color;

@end
