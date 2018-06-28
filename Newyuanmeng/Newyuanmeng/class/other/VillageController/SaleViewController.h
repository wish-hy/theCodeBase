//
//  SaleViewController.h
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleViewController : UIViewController

//判断加载第几个视图
@property(nonatomic,assign)NSInteger index;
//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;
//专区id
@property(nonatomic,copy)NSString *district_id;

- (void)setViewIndexTitle:(NSInteger)index;
//获取参数
- (void)setIndex:(NSInteger)index withUser_id:(NSInteger)user_id withToken:(NSString *)token withDistrict_id:(NSString *)district_id;

@end
