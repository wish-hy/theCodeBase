//
//  recordModel.h
//  huabi
//
//  Created by TeamMac2 on 17/4/7.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface recordModel : JSONModel

@property(nonatomic,copy)NSString *withdraw_no;//!<单号
@property(nonatomic,copy)NSString *amount;//!<金额
@property(nonatomic,copy)NSString *card_no;//!<卡号
@property(nonatomic,copy)NSString *status;//<提现进度
@property(nonatomic,copy)NSString *apply_date;//!<申请时间
@property(nonatomic,copy)NSString *note;//!<备注

@end
