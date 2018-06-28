//
//  ApplyForViewController.h
//  huabi
//
//  Created by teammac3 on 2017/3/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyForViewController : UIViewController

//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;
//判断是否从首页跳转过来的
@property(nonatomic,assign)BOOL isFromHomePage;

@end
