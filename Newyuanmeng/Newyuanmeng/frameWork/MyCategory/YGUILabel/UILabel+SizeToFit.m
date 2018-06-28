//
//  UILabel+SizeToFit.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/28.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "UILabel+SizeToFit.h"

@implementation UILabel (SizeToFit)

-(void)sizeToFitVerticalWithMaxWidth:(float)width
{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
    self.numberOfLines = 0;
    [self sizeToFit];
}

-(void)sizeToFitHorizontal
{
    self.numberOfLines = 1;
    [self sizeToFit];
}

-(void)addAttributedWithString:(NSString *)string range:(NSRange)range color:(UIColor *)color
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:range];
    self.attributedText = attributedStr;
}

@end
