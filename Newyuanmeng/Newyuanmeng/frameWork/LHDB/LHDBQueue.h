//
//  LHDBQueue.h
//  LHNetWorking
//
//  Created by zhao on 16/1/8.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHDBQueue : NSObject
@property (nonatomic,strong) NSString* sqlPath;

+ (instancetype)instanceManager;
//所有写操作
- (void)writeOperationWith:(NSString*)sqlString;
//读操作(返回值以字典表示)
- (void)readOpeartionWith:(NSString*)sqlString tableName:(NSString*)tableName success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild;
//读操作(返回值以model表示)
//- (void)readOpeartionWith:(NSString*)sqlString tableName:(NSString*)tableName class:(Class)class success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com