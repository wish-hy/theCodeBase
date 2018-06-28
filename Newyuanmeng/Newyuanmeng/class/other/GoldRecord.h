//
//  GoldRecord.h
//  huabi
//
//  Created by TeamMac2 on 17/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoldRecord : UIViewController


@property(nonatomic,assign)NSInteger userID;
@property(nonatomic,copy)NSString *token;

-(void)flipFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC options:(UIViewAnimationOptions)options;

@end
