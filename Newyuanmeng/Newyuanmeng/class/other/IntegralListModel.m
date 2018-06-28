//
//  IntegralListModel.m
//  huabi
//
//  Created by teammac3 on 2017/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "IntegralListModel.h"

@implementation IntegralListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"list_id"}];
}
@end
