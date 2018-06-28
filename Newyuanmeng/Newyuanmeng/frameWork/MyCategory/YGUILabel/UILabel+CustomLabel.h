//
//  MYLab.h
//  My_Demo1
//
//  Created by han harvey on 15/7/5.
//  Copyright (c) 2015年 han harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CustomLabel)

#pragma mark UILabel 自适应高度并且内容自动换行
+ (void)creatNewLabelAdaptHeightAndTextInfoLineWrapWithLabel:(UILabel *)label andFont:(CGFloat)font;

#pragma mark UILabel 改变部分字体的颜色
+ (void)chengeLabelTextColorWith:(UILabel *)label andText:(NSString *)text andFrom:(int)start andToLength:(int)andToLength andColor:(UIColor *)color andFontName:(NSString *)fontName andFontSize:(CGFloat) fontSize;

#pragma mark UILabel 在部分字体下加下划线
+ (void)addLabelLineAndChengeLabelTextColorWith:(UILabel *)label andFrom:(int)start andTo:(int)end andColor:(UIColor *)color andFontName:(NSString *)fontName andFontSize:(CGFloat) fontSize;

#pragma mark UILabel 自适应宽高
+ (void)creatCustomLableWidthAndHeight:(UILabel *)lab andFontSize:(double)fontSize;

#pragma mark 根据内容设置控件的自适应高
+ (void)creatCustomLableWHeight:(UILabel *)lab andFontSize:(double)fontSize;

#pragma mark 根据内容设置控件的自适应宽
+ (void)creatCustomLableWidth:(UILabel *)lab andFontSize:(double)fontSize;

+ (UILabel *)label:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font lines:(float)numberOfLines;
+ (void)setLabel:(UILabel *)label title:(NSString *)text color:(UIColor *)color fontsize:(CGFloat)size alignment:(NSTextAlignment)alignment;
/**
 *  设置行间距
 */
- (void)setLabLineSpacing:(CGFloat)spacing;

@end
