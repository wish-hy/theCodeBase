//
//  NSObject+LSSaveKit.h
//  ShoppingProject
//
//  Created by admin on 15/8/3.
//  Copyright (c) 2015年 GuanYisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LSSaveKit)
//保存
-(void)saveDateWithKey:(NSString *)key;
//取出
+(id)getSaveDateWithKey:(NSString *)key;

//发送通知
-(void)senderNotificationIndex:(NSString*)index userInfo:(NSDictionary *)dic;
//接收通知
-(void)addObserverIndex:(NSString*)index;

//接收通知事件，接受者去实现
-(void)notification:(NSNotification *)noti;

@end
