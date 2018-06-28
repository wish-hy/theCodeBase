//
//  GSaleView.h
//  huabi
//
//  Created by teammac3 on 2017/4/5.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSaleView : UIView
//user_id、token
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *token;

//获取参数
- (void)setUser_id:(NSInteger)user_id withToken:(NSString *)token;

@end
