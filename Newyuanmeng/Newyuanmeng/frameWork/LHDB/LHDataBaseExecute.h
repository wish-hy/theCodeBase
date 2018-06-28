//
//  LHDataBaseExecute.h
//  LHNetWorking
//
//  Created by zhao on 16/1/8.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHDataBaseExecute : NSObject

- (instancetype)initWith:(NSString*)sqlPath;

- (BOOL)writeExecuteWith:(NSString*)sqlString;

- (void)readExecuteWith:(NSString*)sqlString tableName:(NSString*)tableName success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild;

//- (void)readExecuteWith:(NSString *)sqlString tableName:(NSString *)tableName WithClass:(Class)class success:(void (^)(NSArray *))success faild:(void (^)(NSError *))faild;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com