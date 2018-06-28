//
//  ExpendListModel.h
//  huabi
//
//  Created by teammac3 on 2017/4/1.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@interface ExpendListModel : JSONModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *linkman;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *avatar;

@end
