//
//  PerfermenceViewController.h
//  huabi
//
//  Created by teammac3 on 2017/4/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PerfermenceViewController : UIViewController

//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;
//专区id
@property(nonatomic,copy)NSString *district_id;
@end
