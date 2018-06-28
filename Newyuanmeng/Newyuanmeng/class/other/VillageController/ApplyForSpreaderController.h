//
//  ApplyForSpreaderController.h
//  huabi
//
//  Created by teammac3 on 2017/4/10.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyForSpreaderController : UIViewController

//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;
//id
@property(nonatomic,copy)NSString *reference_id;
@property(nonatomic,copy)NSString *invitor_role;
@end
