//
//  NSDate+Tools.h
//  DreamGuest
//
//  Created by 韩伟 on 15/5/27.
//  Copyright (c) 2015年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tools)

#pragma mark 初始化当前日期
+ (NSString *)initNowDate;

#pragma mark 初始化当前时间
+ (NSString *)initNowTime;

#pragma mark 初始化当前时间（日期＋时间）
+ (NSString *)initNowDateTime;

#pragma mark 将 NSString 类型的时间转化为 NSDate
+ (NSDate *)stringToDate:(NSString *) strDate;

#pragma mark 将 NSDate 转 NSString
+ (NSString *)dateToString:(NSDate *) date;

#pragma mark 将 NSDate 转 NSString
+ (NSString *)dateToStringDate:(NSDate *) date;

#pragma mark 将 NSDate 转 NSString
+ (NSString *)dateToStringTime:(NSDate *) date;

@end
