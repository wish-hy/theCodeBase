//
//  RobRedBagView.h
//  huabi
//
//  Created by hy on 2018/1/17.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OpenRedBag)(void);
typedef void (^SeeInfo)(void);
typedef void (^Close)(void);

@interface RobRedBagView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *redBagType;
@property (weak, nonatomic) IBOutlet UILabel *wish;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@property (nonatomic,copy)OpenRedBag open;
@property (nonatomic,copy)SeeInfo see;
@property (nonatomic,copy)Close close;
+ (instancetype)creatRobRedBagView;
@end
