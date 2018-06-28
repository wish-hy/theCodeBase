//
//  IntegralListModel.h
//  huabi
//
//  Created by teammac3 on 2017/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"
#import "IntegralPriceSetModel.h"

@interface IntegralListModel : JSONModel

@property(nonatomic,assign)NSInteger list_id;
@property(nonatomic,strong)NSArray<IntegralPriceSetModel>*price_set;
@property(nonatomic,copy)NSString *is_adjustable;
@property(nonatomic,copy)NSString *listorder;
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *sell_price;
@property(nonatomic,copy)NSString *subtitle;
@end
