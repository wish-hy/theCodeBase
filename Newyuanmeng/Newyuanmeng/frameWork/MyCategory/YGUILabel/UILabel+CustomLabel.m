//
//  MYLab.m
//  My_Demo1
//
//  Created by han harvey on 15/7/5.
//  Copyright (c) 2015年 han harvey. All rights reserved.
//

#import "UILabel+CustomLabel.h"

@implementation UILabel (CustomLabel)

#pragma mark UILabel 自适应高度并且内容自动换行
+ (void)creatNewLabelAdaptHeightAndTextInfoLineWrapWithLabel:(UILabel *)label andFont:(CGFloat)font
{
    // 清空背景颜色
    label.backgroundColor = [UIColor clearColor];
    // 文字居中显示
    label.textAlignment = NSTextAlignmentLeft;
    // 自动折行设置
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:FontName size:font];
    
    // 自适应高度
    CGRect txtFrame = label.frame;
    
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width,
                             txtFrame.size.height =[label.text boundingRectWithSize:
                                                    CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                         attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil].size.height);
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, txtFrame.size.height);
}

#pragma mark UILabel 改变部分字体的颜色
+ (void)chengeLabelTextColorWith:(UILabel *)label andText:(NSString *)text andFrom:(int)start andToLength:(int)andToLength andColor:(UIColor *)color andFontName:(NSString *)fontName andFontSize:(CGFloat) fontSize
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(start, andToLength)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:fontName size:fontSize] range:NSMakeRange(start, andToLength)];

    label.attributedText = str;
}

#pragma mark UILabel 改变部分字体的颜色并在字体下加下划线
+ (void)addLabelLineAndChengeLabelTextColorWith:(UILabel *)label andFrom:(int)start andTo:(int)end andColor:(UIColor *)color andFontName:(NSString *)fontName andFontSize:(CGFloat) fontSize
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
    NSRange strRange = {start, end};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(start, end)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:fontName size:fontSize] range:NSMakeRange(start, end)];
    [label setAttributedText:str];
    
}

#pragma mark UILabel 自适应宽高
+ (void)creatCustomLableWidthAndHeight:(UILabel *)lab andFontSize:(double)fontSize
{
    NSString *str = [NSString stringWithFormat:@"%@",lab.text];
    [lab setText:str];
    [lab setNumberOfLines:0];
    [lab.layer setBorderWidth:0];
    [lab setLineBreakMode:NSLineBreakByCharWrapping];
    UIFont *font = [UIFont fontWithName:FontName size:fontSize];
    [lab setFont:font];
    CGSize size = CGSizeMake(1000, 1500);
//    CGSize labSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil].size;
    
    CGRect frame = [lab frame];
    frame.size.height = ceil(labSize.height);
    frame.size.width = ceil(labSize.width);
    [lab setFrame:frame];
}

#pragma mark 根据内容设置控件的自适应高
+ (void)creatCustomLableWHeight:(UILabel *)lab andFontSize:(double)fontSize
{
    [lab setTextColor:[UIColor grayColor]];
    NSString *str = [NSString stringWithFormat:@"%@",lab.text];
    [lab setText:str];
    [lab setTextAlignment:NSTextAlignmentLeft];
    [lab setNumberOfLines:0];
    [lab.layer setBorderWidth:0];
    
    [lab setLineBreakMode:NSLineBreakByCharWrapping];
    
    
    UIFont *font = [UIFont fontWithName:FontName size:fontSize];
    [lab setFont:font];
    
    CGSize size = CGSizeMake(lab.frame.size.width, 500);
    CGSize labSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    CGRect frame = [lab frame];
    frame.size.height = labSize.height;
    [lab setFrame:frame];
}

#pragma mark 根据内容设置控件的自适应宽
+ (void)creatCustomLableWidth:(UILabel *)lab andFontSize:(double)fontSize
{
    [lab setTextColor:[UIColor grayColor]];
    NSString *str = [NSString stringWithFormat:@"%@",lab.text];
    [lab setText:str];
    [lab setTextAlignment:NSTextAlignmentLeft];
    [lab setNumberOfLines:0];
    [lab.layer setBorderWidth:0];
    
    [lab setLineBreakMode:NSLineBreakByCharWrapping];
    
    UIFont *font = [UIFont fontWithName:FontName size:fontSize];
    [lab setFont:font];
    
    CGSize size = CGSizeMake(lab.frame.size.width, 500);
    CGSize labSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    CGRect frame = [lab frame];
    frame.size.width = labSize.width;
    [lab setFrame:frame];
}

+ (UILabel *)label:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font lines:(float)numberOfLines{
    UILabel *label = [UILabel new];
    if (text != nil) {
        label.text = text;
    }
    if (color != nil) {
        label.textColor = color;
    }
    label.font = [UIFont fontWithName:FontName size:font];
    label.numberOfLines = numberOfLines;
    
    return label;
}


/**
 *  设置行间距
 */
- (void)setLabLineSpacing:(CGFloat)spacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:spacing];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

+ (void)setLabel:(UILabel *)label title:(NSString *)text color:(UIColor *)color fontsize:(CGFloat)size alignment:(NSTextAlignment)alignment{
    
    label.text = text;
    label.textColor = color;
    label.font = MyFontSize(size);
    label.textAlignment = alignment;
    label.numberOfLines = 0;
}
@end
