//
//  NSObject+LHModelOperation.m
//  eproject
//
//  Created by zhao on 16/1/7.
//  Copyright © 2016年 com.ejiandu. All rights reserved.
//

#import "NSObject+LHModelOperation.h"
#import <objc/runtime.h>


@implementation NSObject (LHModelOperation)
- (NSArray*)getAllPropertyName//runtime获取model所有属性
{
    NSMutableArray* nameArray = [NSMutableArray array];
    unsigned int count = 0;
    objc_property_t *property_t = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        objc_property_t propert = property_t[i];
        const char * propertyName = property_getName(propert);
        [nameArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(property_t);
    return nameArray;
}
//创建get方法
- (SEL)createGetSelectorWith:(NSString*)propertyName
{
    return NSSelectorFromString(propertyName);
}
//创建set方法
- (SEL)createSetSEL:(NSString*)propertyName
{
    NSString* firstString = [propertyName substringToIndex:1].uppercaseString;
    propertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
    propertyName = [NSString stringWithFormat:@"set%@:",propertyName];
    return NSSelectorFromString(propertyName);
}
//执行get方法
- (id)getResultWithPropertName:(NSString*)propertyName
{
    SEL getSel = [self createGetSelectorWith:propertyName];
    if ([self respondsToSelector:getSel]) {
        //获取类和方法签名
        NSMethodSignature* signature = [self methodSignatureForSelector:getSel];
       const char * returnType = [signature methodReturnType];
        //获取调用对象
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:getSel];
        [invocation invoke];
        if (!memcmp(returnType, "@", 1)) {
            NSObject *__unsafe_unretained returnValue = nil;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        }else if (!memcmp(returnType, "i", 1)||!memcmp(returnType, "q", 1)||!memcmp(returnType, "Q", 1)){
            int returnValue = 0;
            [invocation getReturnValue:&returnValue];
            return [NSString stringWithFormat:@"%d",returnValue];
        }else if(!memcmp(returnType, "f", 1)){
            float returnValue = 0.0;
            [invocation getReturnValue:&returnValue];
            return [NSString stringWithFormat:@"%g",returnValue];
        }else if (!memcmp(returnType, "d", 1)) {
            double retureVaule = 0.0;
            [invocation getReturnValue:&retureVaule];
            return [NSString stringWithFormat:@"%g",retureVaule];
        }
        
    }
    return nil;
}

//mode转字典
- (NSDictionary*)getDic
{
    NSArray* nameArray = [self getAllPropertyName];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for (NSString* propertyName in nameArray) {
        id value = [self getResultWithPropertName:propertyName];
        [dic setValue:value forKey:propertyName];
    }
    return dic;
}

//字典转model
+ (id)modelWithDictory:(NSDictionary*)dic
{
    id model = [[self alloc] init];
    NSArray* nameArray = dic.allKeys;
    for (int i=0; i < nameArray.count; i++) {
       SEL setSel = [model createSetSEL:nameArray[i]];
        if ([model respondsToSelector:setSel]) {
            
            NSMethodSignature* signature = [model methodSignatureForSelector:setSel];
            const char* c = [signature getArgumentTypeAtIndex:2];
            if (!memcmp(c, "@", 1)) {
                IMP imp = [model methodForSelector:setSel];
                void (*func) (id,SEL,id) = (void*)imp;
                func(model, setSel,dic[nameArray[i]]);
            }else if (!memcmp(c, "i", 1)||!memcmp(c, "q", 1)||!memcmp(c, "Q", 1)){
                int value = [dic[nameArray[i]] intValue];
                IMP imp = [model methodForSelector:setSel];
                void (*func) (id,SEL,int) = (void*)imp;
                func(model, setSel,value);
            }else if(!memcmp(c, "f", 1)){
                float value = [dic[nameArray[i]] floatValue];
                IMP imp = [model methodForSelector:setSel];
                void (*func) (id,SEL,float) = (void*)imp;
                func(model, setSel,value);
            }else if (!memcmp(c, "d", 1)) {
                double value = [dic[nameArray[i]] doubleValue];
                IMP imp = [model methodForSelector:setSel];
                void (*func) (id,SEL,double) = (void*)imp;
                func(model, setSel,value);
            }
        }
    }
    return model;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com