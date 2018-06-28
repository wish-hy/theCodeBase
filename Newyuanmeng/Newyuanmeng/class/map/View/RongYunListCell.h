//
//  RongYunListCell.h
//  huabi
//
//  Created by hy on 2018/2/1.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RongYunListCell : RCConversationBaseCell
@property (weak, nonatomic) IBOutlet CoreImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *log;

@end
