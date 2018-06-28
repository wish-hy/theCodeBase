//
//  NoticeView.m
//  NineBall
//
//  Created by TeamMac2 on 16/12/7.
//  Copyright © 2016年 liutonglin. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView

+(void)showMessage:(NSString *)title
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = color_clear;
    showview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [window addSubview:showview];
    UILabel *label = [UILabel new];
    label.text = title;
    label.textColor = color_white;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = color_title_black_light;
    label.layer.cornerRadius = 10*ScaleWidth;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:32*ScaleWidth];
    [showview addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(showview);
        make.width.mas_equalTo([title getStrW:32*ScaleWidth font:32*ScaleWidth]+20*ScaleWidth);
        make.height.mas_equalTo([title getStrH:ScreenWidth-40*ScaleWidth font:32*ScaleWidth]+10*ScaleWidth);
    }];
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [showview removeFromSuperview];
    });
}

@end
