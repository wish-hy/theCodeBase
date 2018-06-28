//
//  YGTools.m
//  FindingSomething
//
//  Created by 韩伟 on 16/5/12.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YGTools.h"

@implementation YGTools

+ (instancetype)sharedInstance
{
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    
    return _sharedInstance;
}

// 获取app名称
- (NSString *)getAppName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

// 获取app版本
- (NSString *)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

// 移除所有子视图
- (void)removeAllSubViews:(UIView *)faView
{
    for(UIView *view in [faView subviews])
    {
        [view removeFromSuperview];
    }
}

@end
