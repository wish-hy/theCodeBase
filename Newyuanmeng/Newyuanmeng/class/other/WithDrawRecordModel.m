//
//  WithDrawRecordModel.m
//  huabi
//
//  Created by teammac3 on 2017/3/31.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "WithDrawRecordModel.h"

@implementation WithDrawRecordModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"district_id"}];
}


@end
