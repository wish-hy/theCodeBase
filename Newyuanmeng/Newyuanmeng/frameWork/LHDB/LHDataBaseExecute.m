//
//  LHDataBaseExecute.m
//  LHNetWorking
//
//  Created by zhao on 16/1/8.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHDataBaseExecute.h"
#import <sqlite3.h>
#import "NSObject+LHModelOperation.h"

@interface LHDataBaseExecute()

@property (nonatomic,strong) NSString* sqlPath;

@end

@implementation LHDataBaseExecute
{
    sqlite3* db;
}

- (instancetype)initWith:(NSString*)sqlPath
{
    self = [super init];
    if (self) {
        self.sqlPath = sqlPath;
    }
    return self;
}

- (BOOL)openDB
{
    if (sqlite3_open([self.sqlPath UTF8String], &db) == SQLITE_OK) {
        return YES;
    }else{
        sqlite3_close(db);
        return NO;
    }
}


- (BOOL)writeExecuteWith:(NSString*)sqlString
{
    if (![self openDB]) {
        return NO;
    }
    char *err;
    if (sqlite3_exec(db, [sqlString UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_free(err);
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败! 错误信息%@,%@", [NSString stringWithUTF8String:err],sqlString);
        return YES;
    }else{
        sqlite3_free(err);
        sqlite3_close(db);
        return NO;
    }
}

- (void)readExecuteWith:(NSString*)sqlString tableName:(NSString*)tableName success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild
{
    if (![self openDB]) {
        NSError* error = [NSError errorWithDomain:@"" code:500 userInfo:@{@"错误信息":@"数据库打开失败"}];
        faild(error);
        return;
    }
    sqlite3_stmt * statement;
    NSMutableArray* tempArr = [NSMutableArray array];
    NSMutableArray* allKeyArray = [NSMutableArray array];
//
    NSString* keyString = [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
    if (sqlite3_prepare_v2(db, [keyString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            [allKeyArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
        }
    }
    if (sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            for (int i=0;i<allKeyArray.count;i++) {
                NSString* key = allKeyArray[i];
                [dic setValue:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)] forKey:key];
            }
            [tempArr addObject:dic];
        }
        success(tempArr);
    }else{
        NSError* error = [NSError errorWithDomain:@"" code:500 userInfo:@{@"错误信息":@"数据库查询失败"}];
        faild(error);
    }
    sqlite3_close(db);
}

//- (void)readExecuteWith:(NSString *)sqlString tableName:(NSString *)tableName WithClass:(Class)class success:(void (^)(NSArray *))success faild:(void (^)(NSError *))faild
//{
//    if (![self openDB]) {
//        NSError* error = [NSError errorWithDomain:@"" code:500 userInfo:@{@"错误信息":@"数据库打开失败"}];
//        faild(error);
//        return;
//    }
//    [self readExecuteWith:sqlString tableName:tableName success:^(NSArray *resultArray) {
//        NSMutableArray* tempArray = [NSMutableArray array];
//        for (NSDictionary* dic in resultArray) {
//            id objectModel = [class modelWithDictory:dic];
//            [tempArray addObject:objectModel];
//        }
//        success(tempArray);
//    } faild:^(NSError *error) {
//        faild(error);
//    }];
//    sqlite3_close(db);
//}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com