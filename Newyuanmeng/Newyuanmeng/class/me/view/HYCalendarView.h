//
//  MyCalendarItem.h
//  HYCalendar
//
//  Created by nathan on 14-9-17.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCalendarTool.h"

@interface HYCalendarView : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@property (nonatomic,strong)  NSMutableArray *signArray;

//今天
@property (nonatomic,strong)  UIButton *dayButton;
@property (nonatomic, strong) UIImageView *dayIMG;
@property (nonatomic, strong) UIImageView *dayLabel;


- (void)setStyle_Today_Signed:(UIButton *)btn;
- (void)setStyle_Today:(UIButton *)btn;
- (void)setDuigouStyle_Today_Signed: (UIImageView *)imgView againLabel: (UIImageView *) againLabel;
- (void)setDuigouStyle_Today: (UIImageView *)imgView againLabel: (UIImageView *) againLabel;

@end
