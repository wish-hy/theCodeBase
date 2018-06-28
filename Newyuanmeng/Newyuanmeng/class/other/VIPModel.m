//
//  VIPModel.m
//  huabi
//
//  Created by teammac3 on 2017/6/3.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "VIPModel.h"

@implementation VIPModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"vip_id"}];
}
@end
