//
//  MyGeneralizeViewController.h
//  huabi
//
//  Created by teammac3 on 2017/4/1.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VillageListModel.h"

@interface MyGeneralizeViewController : UIViewController

//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;

@property (nonatomic,strong)NSString *shouYi;  // 是否跳转收益页面

@end
