//
//  GiftModel.h
//  huabi
//
//  Created by teammac3 on 2017/6/9.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "JSONModel.h"

@protocol GiftModel
@end

@interface GiftModel : JSONModel

@property(nonatomic,copy)NSString *gift_id;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *name;
@end
