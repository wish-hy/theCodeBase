//
//  NSObject+LSSaveKit.m
//  ShoppingProject
//
//  Created by admin on 15/8/3.
//  Copyright (c) 2015年 GuanYisoft. All rights reserved.
//

#import "NSObject+LSSaveKit.h"
#define LSNotificationID @"LSNotificationID"


@implementation NSObject (LSSaveKit)

-(void)saveDateWithKey:(NSString *)key
{

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self forKey:key];
    
}

+(id)getSaveDateWithKey:(NSString *)key
{
   NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:key];
}

-(void)senderNotificationIndex:(NSString*)index userInfo:(NSDictionary *)dic{
    
   [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@%@",LSNotificationID,index] object:nil userInfo:dic];
}

-(void)addObserverIndex:(NSString*)index
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:[NSString stringWithFormat:@"%@%@",LSNotificationID,index] object:nil];
}

-(void)notification:(NSNotification *)noti
{
   
}
@end
