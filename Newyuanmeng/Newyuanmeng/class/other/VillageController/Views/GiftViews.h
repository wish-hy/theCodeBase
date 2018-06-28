//
//  GiftViews.h
//  huabi
//
//  Created by teammac3 on 2017/6/9.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^giftIDBack)(NSString *);
@interface GiftViews : UIView

//数据
@property(nonatomic,strong)NSArray *modelArr;
@property(nonatomic,copy)giftIDBack block;
@end
