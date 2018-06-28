//
//  HYItemTool.h
//  study
//
//  Created by hy on 2018/3/28.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYItemTool : NSObject

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

// 返回按钮自定义
+ (UIBarButtonItem *)backButtonWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;


+ (UIBarButtonItem *)itemButtonWithTitle:(NSString *)title highTitle:(NSString *)highTitle target:(id)target action:(SEL)action;
@end
