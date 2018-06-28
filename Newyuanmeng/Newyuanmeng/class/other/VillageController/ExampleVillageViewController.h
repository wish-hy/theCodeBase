//
//  ExampleVillageViewController.h
//  huabi
//
//  Created by teammac3 on 2017/3/28.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VillageListModel.h"

@interface ExampleVillageViewController : UIViewController

//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;
//专区id
@property(nonatomic,copy)VillageListModel *model;

//判断是否有专区
@property(nonatomic,assign)BOOL haveVillage;

//获取
//- (void)setUser_id:(NSInteger)user_id withToken:(NSString *)token withDistrict_id:(NSString *)dostroct_id;

@end
