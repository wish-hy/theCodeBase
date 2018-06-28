//
//  IntegralPriceSetModel.h
//  huabi
//
//  Created by teammac3 on 2017/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@protocol IntegralPriceSetModel


@end
@interface IntegralPriceSetModel : JSONModel

@property(nonatomic,copy)NSString *cash;
@property(nonatomic,copy)NSString *point;

@end
