//
//  Provice.h
//  PickView
//
//  Created by mac on 16/6/23.
//  Copyright © 2016年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Provice : NSObject

@property(nonatomic,copy)NSString *proID;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *code;

- (instancetype)initWithProviceDic:(NSDictionary *)dic;

@end

@interface City : NSObject

@property(nonatomic,copy)NSString *proID;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *code;

@property(nonatomic,copy)NSString *cityID;

- (instancetype)initWithCityDic:(NSDictionary *)dic;

@end


@interface UnCodePlace : NSObject

//根据code码返回地址信息(不需要详细的地址信息的时候只传需要的code码；比如只需要省份只传省的code即可)
+ (NSMutableString *)addressWithProviceCode:(NSString*)proCode withCityCode:(NSString*)citCode;
@end
