//
//  MyManager.m
//  huabi
//
//  Created by TeamMac2 on 16/12/14.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "MyManager.h"

static MyManager *manager = nil;

@implementation MyManager

// 伪单例 和 完整的单例。 以及线程的安全。
// 一般使用伪单例就足够了 每次都用 sharedDataHandle 创建对象。
+ (MyManager *)sharedMyManager
{
    // 添加同步锁，一次只能一个线程访问。如果有多个线程访问，等待。一个访问结束后下一个。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MyManager alloc] init];
        manager.accessToken = @"";
//        manager.MainURL = @"https://www.buy-d.cn";
//        manager.ImageHost = @"https://www.buy-d.cn";
//        manager.UploadURL = @"https://www.buy-d.cn";
        manager.MainURL = @"http://www.ymlypt.com";
        manager.ImageHost = @"https://ymlypt.b0.upaiyun.com";
        manager.UploadURL = @"http://v1.api.upyun.com/ymlypt";
        manager.sessionid = @"";
    });
    return manager;
}

////重写alloc方法
//+ (instancetype)alloc {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[MyManager alloc] init];
//        manager.accessToken = @"";
//    });
//    return manager;
//}

//限制方法，类只能初始化一次
//alloc的时候调用
+ (id) allocWithZone:(struct _NSZone *)zone{
    if(manager == nil){
        manager = [super allocWithZone:zone];
    }
    return manager;
}

//拷贝方法
- (id)copyWithZone:(NSZone *)zone{
    return manager;
}



@end
