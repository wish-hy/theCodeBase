//
//  LHDataBaseOperation.h
//  LHNetWorking
//
//  Created by zhao on 16/1/8.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^callback)();
@interface LHDataBaseOperation : NSObject

@property (nonatomic,strong) NSString* sqlPath;

- (instancetype)initWith:(NSString*)sqlPath;


//所有读操作
- (callback)writeOperationWith:(NSString*)sqlString;
//查询操作(结果已字典形式回调)
- (callback)readTabelWith:(NSString*)sqlString tableName:(NSString*)tableName success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild;
//查询操作(结果已Model形式回调)
//- (callback)readTableWith:(NSString *)sqlString tableName:(NSString *)tableName WithClass:(Class)class success:(void (^)(NSArray *))success faild:(void (^)(NSError *))faild;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com