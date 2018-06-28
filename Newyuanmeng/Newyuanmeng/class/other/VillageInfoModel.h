//
//  VillageInfoModel.h
//  huabi
//
//  Created by teammac3 on 2017/4/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"
#import "GiftModel.h"

@interface VillageInfoModel : JSONModel

@property(nonatomic,copy)NSString *promoter_fee;
@property(nonatomic,assign)NSInteger refrence;
@property(nonatomic,copy)NSString *invitor_role;
@property(nonatomic,strong)NSDictionary *district_info;
@property(nonatomic,strong)NSArray<GiftModel>*gift_list;
@end
