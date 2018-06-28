//
//  InteDetailModel.m
//  huabi
//
//  Created by teammac3 on 2017/6/7.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "InteDetailModel.h"

@implementation InteDetailModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES; //
}

+(JSONKeyMapper *)keyMapper{
    
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"InteID"}];
}
@end
