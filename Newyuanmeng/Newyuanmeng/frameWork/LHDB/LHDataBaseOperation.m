//
//  LHDataBaseOperation.m
//  LHNetWorking
//
//  Created by zhao on 16/1/8.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHDataBaseOperation.h"
#import <sqlite3.h>
#import "LHDataBaseExecute.h"

typedef void(^callback)();
@interface LHDataBaseOperation()

@property (nonatomic,strong) LHDataBaseExecute* execute;

@end
@implementation LHDataBaseOperation

- (instancetype)initWith:(NSString*)sqlPath
{
    self = [super init];
    if (self) {
        self.sqlPath = sqlPath;
    }
    return self;
}

- (LHDataBaseExecute*)execute
{
    if (!_execute) {
        _execute = [[LHDataBaseExecute alloc] initWith:self.sqlPath];
    }
    return _execute;
}

//执行sql语句
- (callback)writeOperationWith:(NSString*)sqlString
{

    callback callback = ^(){
        [self.execute writeExecuteWith:sqlString];
    };
    return callback;
}

- (callback)readTabelWith:(NSString*)sqlString tableName:(NSString*)tableName success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild
{
    return ^(){
        [self.execute readExecuteWith:sqlString tableName:tableName success:success faild:faild];
    };
}

//- (callback)readTableWith:(NSString *)sqlString tableName:(NSString *)tableName WithClass:(Class)class success:(void (^)(NSArray *))success faild:(void (^)(NSError *))faild
//{
//    return ^(){
//        [self.execute readExecuteWith:sqlString tableName:tableName WithClass:class success:success faild:faild];
//    };
//}

//查询操作

//- (void)seleteTabelWith:(NSString*)sqlString tableName:(NSString*)tableName success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild
//{
//    [self readTabelWith:sqlString tableName:tableName success:success faild:faild];
//}
//
//- (void)seleteTableWith:(NSString *)sqlString tableName:(NSString *)tableName WithClass:(Class)class success:(void (^)(NSArray * resultArray))success faild:(void (^)(NSError * error))faild
//{
//    [self readTableWith:sqlString tableName:tableName WithClass:class success:success faild:faild];
//}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com