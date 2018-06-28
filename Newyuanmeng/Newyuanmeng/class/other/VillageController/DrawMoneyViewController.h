//
//  DrawMoneyViewController.h
//  huabi
//
//  Created by teammac3 on 2017/3/28.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawMoneyViewController : UIViewController

//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;
//专区id
@property(nonatomic,copy)NSString *district_id;
//可提现金额
@property(nonatomic,copy)NSString *money;
@end
