//
//  LHDBQueue.m
//  LHNetWorking
//
//  Created by zhao on 16/1/8.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHDBQueue.h"
#import "LHDataBaseOperation.h"

#define LHQUEUE "LHQUEUE"

@interface LHDBQueue()

@property (nonatomic,strong) dispatch_queue_t mainQueue;
@property (nonatomic,strong) LHDataBaseOperation* opeartion;

@end

@implementation LHDBQueue

+ (instancetype)instanceManager
{
    static LHDBQueue* queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[self alloc] init];
        queue.mainQueue = dispatch_queue_create(LHQUEUE,DISPATCH_QUEUE_SERIAL);;
    });
    return queue;
}

- (void)setSqlPath:(NSString *)sqlPath
{
    self.opeartion = [[LHDataBaseOperation alloc] initWith:sqlPath];
    _sqlPath = sqlPath;
}


- (void)writeOperationWith:(NSString*)sqlString
{
    dispatch_sync(self.mainQueue, [self.opeartion writeOperationWith:sqlString]);
}

- (void)readOpeartionWith:(NSString*)sqlString tableName:(NSString*)tableName success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild
{
    dispatch_sync(self.mainQueue, [self.opeartion readTabelWith:sqlString tableName:tableName success:success faild:faild]);
}

//- (void)readOpeartionWith:(NSString*)sqlString tableName:(NSString*)tableName class:(Class)class success:(void(^)(NSArray* resultArray))success faild:(void(^)(NSError* error))faild
//{
//    dispatch_sync(self.mainQueue, [self.opeartion readTableWith:sqlString tableName:tableName WithClass:class success:success faild:faild]);
//}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com