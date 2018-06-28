//
//  GiftModel.m
//  huabi
//
//  Created by teammac3 on 2017/6/9.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "GiftModel.h"

@implementation GiftModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"gift_id"}];
}

@end
