//
//  GeneralizeViewController.h
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralizeViewController : UIViewController

//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;
//专区id
@property(nonatomic,copy)NSString *district_id;

//获取参数
//- (void)setUser_id:(NSInteger)user_id withToken:(NSString *)token withDistrict_id:(NSString *)district_id;

@end
