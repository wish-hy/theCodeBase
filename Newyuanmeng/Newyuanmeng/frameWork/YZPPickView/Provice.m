//
//  Provice.m
//  PickView
//
//  Created by mac on 16/6/23.
//  Copyright © 2016年. All rights reserved.
//

#import "Provice.h"

@implementation Provice

- (instancetype)initWithProviceDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = dic[@"code"];
        self.proID = dic[@"proID"];
        self.name = dic[@"name"];
    }
    return self;
}

@end

@implementation City

- (instancetype)initWithCityDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = dic[@"code"];
        self.proID = dic[@"proID"];
        self.name = dic[@"name"];
        self.cityID = dic[@"cityID"];
    }
    return self;
}

@end

@implementation UnCodePlace

//根据地区码返回地址信息
+ (NSMutableString *)addressWithProviceCode:(NSString*)proCode withCityCode:(NSString*)citCode{
    NSMutableString *str = [NSMutableString string];
    NSArray *cityArr = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"city" withExtension:@"plist"]];
    NSArray *provinceArr = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"province" withExtension:@"plist"]];
    for (int i=0; i<3; i++) {
        if (i==0) {
            for (NSDictionary *dic in provinceArr) {
                if ([proCode isEqual:dic[@"code"]]) {
                    [str appendString:[NSString stringWithFormat:@"%@",dic[@"name"]]];
                }
            }
            
        }else if (i==1){
            for (NSDictionary *dic in cityArr) {
                if ([citCode isEqual:dic[@"code"]]) {
                    [str appendString:dic[@"name"]];
                }
            }
        }
    }
    return str;
}

@end