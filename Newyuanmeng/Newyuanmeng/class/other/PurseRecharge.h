//
//  PurseRecharge.h
//  huabi
//
//  Created by TeamMac2 on 17/3/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurseRecharge : UIViewController
//VIP充值传参
@property(nonatomic,assign)BOOL isVIPPage;
@property(nonatomic,copy)NSString *sellPrice;
@property(nonatomic,copy)NSString *goodid;
@property(nonatomic,assign)NSInteger userID;
@property(nonatomic,copy)NSString *token;

//-(void)flipFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC options:(UIViewAnimationOptions)options;


@end
