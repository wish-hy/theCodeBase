//
//  NSDate+Tools.m
//  DreamGuest
//
//  Created by 韩伟 on 15/5/27.
//  Copyright (c) 2015年 韩伟. All rights reserved.
//

#import "NSDate+Tools.h"

@implementation NSDate (Tools)

#pragma mark 初始化当前日期 yyyy-MM-dd
+ (NSString *)initNowDate
{
    // 获得当前时间
    NSDate *dateToday = [NSDate date];
    
    // 时间格式化
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"yyyy-MM-dd"];
    
    // 转化为 NSString
    return [ndf stringFromDate:dateToday];
}

#pragma mark 初始化当前时间 HH:mm:ss
+ (NSString *)initNowTime
{
    // 获得当前时间
    NSDate *dateToday = [NSDate date];
    
    // 时间格式化
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"HH:mm:ss"];
    
    // 转化为 NSString
    return [ndf stringFromDate:dateToday];
}

#pragma mark 初始化当前时间（日期＋时间） yyyy-MM-dd HH:mm:ss
+ (NSString *)initNowDateTime
{
    // 获得当前时间
    NSDate *dateToday = [NSDate date];
    
    // 时间格式化
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //本地化
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [ndf setLocale:locale];

    // 转化为 NSString
    return [ndf stringFromDate:dateToday];
}

#pragma mark 将 NSString 类型的时间转化为 NSDate
+ (NSDate *)stringToDate:(NSString *)strDate
{
    // 时间格式化
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 本地化
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:locale];
    
    // 转化为NSDate
    return [df dateFromString:strDate];
}

#pragma mark 将 NSDate 转 NSString
+(NSString *)dateToString:(NSDate *)date
{
    //转换时间格式
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *s1 = [df stringFromDate:date];
    return s1;
}

#pragma mark 将 NSDate 转 NSString
+(NSString *)dateToStringDate:(NSDate *)date
{
    //转换时间格式
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *s1 = [df stringFromDate:date];
    return s1;
}

#pragma mark 将 NSDate 转 NSString
+(NSString *)dateToStringTime:(NSDate *)date
{
    //转换时间格式
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"HH:mm:ss"];
    NSString *s1 = [df stringFromDate:date];
    return s1;
}

@end
