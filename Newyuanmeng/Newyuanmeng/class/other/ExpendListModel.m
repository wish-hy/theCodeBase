//
//  ExpendListModel.m
//  huabi
//
//  Created by teammac3 on 2017/4/1.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ExpendListModel.h"

@implementation ExpendListModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"district_id"}];
}

@end
