//
//  MyInvitePModel.h
//  huabi
//
//  Created by teammac3 on 2017/6/2.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface MyInvitePModel : JSONModel
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *create_date;
@property(nonatomic,copy)NSString *role_type;

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *createtime;
@end
