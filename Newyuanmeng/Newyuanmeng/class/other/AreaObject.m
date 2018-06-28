//
//  AreaObject.m
//  Wujiang
//
//  Created by zhengzeqin on 15/5/28.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//  make by 郑泽钦 分享

#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    NSString *city = self.province;
    if (![self.city isEqualToString:@""]) {
        city = [NSString stringWithFormat:@"%@ %@",city,self.city];
    }
    if (![self.area isEqualToString:@""]) {
        city = [NSString stringWithFormat:@"%@ %@",city,self.area];
    }
    city = [NSString stringWithFormat:@"%@+%@",city,self.provinceid];
    if (![self.cityid isEqualToString:@""]) {
        city = [NSString stringWithFormat:@"%@ %@",city,self.cityid];
    }
    if (![self.areaid isEqualToString:@""]) {
        city = [NSString stringWithFormat:@"%@ %@",city,self.areaid];
    }
    return city;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com