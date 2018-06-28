//
//  VillagePayViewController.h
//  huabi
//
//  Created by teammac3 on 2017/3/29.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VillagePayViewController : UIViewController

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *district_id;
//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;

@end
