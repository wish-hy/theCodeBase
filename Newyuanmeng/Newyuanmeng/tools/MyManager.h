//
//  MyManager.h
//  huabi
//
//  Created by TeamMac2 on 16/12/14.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManager : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *MainURL;
@property (nonatomic, copy) NSString *ImageHost;
@property (nonatomic, copy) NSString *UploadURL;
@property (nonatomic, copy) NSString *sessionid;

+(MyManager *)sharedMyManager; // 创建单例对象的方法。类方法 命名规则： shared + 类名
//+ (instancetype)alloc;
@end
