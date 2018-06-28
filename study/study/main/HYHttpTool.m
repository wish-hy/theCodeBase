//
//  HYHttpTool.m
//  study
//
//  Created by hy on 2018/4/21.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYHttpTool.h"

static AFHTTPSessionManager *manager;
static QNUploadManager *upManager;

@implementation HYHttpTool

+ (AFHTTPSessionManager *)sharedHttpSession
{
    static dispatch_once_t onctToken;
    dispatch_once(&onctToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
    });
    return manager;
}

+(void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [HYHttpTool sharedHttpSession];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            
//            if (![responseObject[@"code"] isEqualToString:@"0"]) {
//                HYLog(@"")
//            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [HYHttpTool sharedHttpSession];
//    [SVProgressHUD show];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
//            if ([responseObject[@"code"] isEqualToString:@"100"]) {
//                MyLog(@"token - 失效");
//                MyLog(@"%@",url)
//                [self loginBackInViewController];
//            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismissWithDelay:1.0];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
//        [SVProgressHUD showErrorWithStatus:@"网络超时, 请稍后再试!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismissWithDelay:1.0];
        });
    }];
}

// 七牛云
/**
 *  初始化
 *
 */
+ (QNUploadManager *)sharedUpload
{
    static dispatch_once_t onctToken;
    dispatch_once(&onctToken, ^{
        upManager = [[QNUploadManager alloc] init];
    });
    return upManager;
}

/**
 *    上传文件
 *
 *    @param path          文件路径
 *    @param key               上传到云存储的key，为nil时表示是由七牛生成
 *    token             上传需要的token, 由服务器生成
 */

+ (void)putImagePath:(NSString *)path key:(NSString *)key complete:(void (^)(id objc))complete
{
    QNUploadManager *unpmanager = [HYHttpTool sharedUpload];
    [unpmanager putFile:path key:key token:@"GKV_2UBqC8QAkdOn0FmwDDcB2N2sgfzoHjBxqcbw:chdn2rtKm2Q8TPkdL0by3YlDy34=:eyJzY29wZSI6ImltYWdlcyIsImRlYWRsaW5lIjozMzUxODY1MDMzfQ==" complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        NSLog(@"------ %@",resp);
        if (info.ok) {
            if (complete) {
                complete(key);
            }
        }else{
            HYLog(@"上传失败");
        }
        
        
        
//        HYLog(@"%@-%@-%@",info,key,resp);
    } option:nil];
}


@end
