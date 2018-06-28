//
//  MyCalendarItem.m
//  HYCalendar
//
//  Created by nathan on 14-9-17.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import "HYCalendarView.h"
#import "AppColor.h"
#import "NSString+Color.h"

@implementation HYCalendarView
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
    NSMutableArray *_duigouArray;
    NSMutableArray *_againDuigouArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
        _duigouArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            [self addSubview:imgView];
            [_duigouArray addObject:imgView];
        }
        
        _againDuigouArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIImageView *againLabel = [[UIImageView alloc] init];
            [self addSubview:againLabel];
            [_againDuigouArray addObject:againLabel];
        }
    }
    return self;
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{

    CGFloat itemW     = ScreenWidth/7;
    CGFloat itemH     = 46;
    
    // 1.year month
//    UILabel *headlabel = [[UILabel alloc] init];
//    headlabel.text     = [NSString stringWithFormat:@"%li-%li",[HYCalendarTool year:date],[HYCalendarTool month:date]];
//    headlabel.font     = [UIFont systemFontOfSize:14];
//    headlabel.frame           = CGRectMake(0, 0, self.frame.size.width, itemH);
//    headlabel.textAlignment   = NSTextAlignmentCenter;
//    [self addSubview:headlabel];
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor whiteColor];
    weekBg.frame = CGRectMake(0, 0, ScreenWidth, 27);
    [self addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = COLOR_IMGBOARD_;
        week.textColor       = COLOR_FONT_;
        [weekBg addSubview:week];
    }
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 0;
//        dayButton.layer.borderColor = [@"d2d0d1" colorFromRGBcode].CGColor;
//        dayButton.layer.borderWidth = 0.3;
        [dayButton setTitleColor:COLOR_FONT_ forState:UIControlStateNormal];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *dayIMG = _duigouArray[i];
        dayIMG.frame = CGRectMake(x+19, y+26, 16, 16);
        dayIMG.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e65c", 16, [UIColor colorWithHexString:@"ffbb08"])];
//        selectedIMG.hidden = true;
        
        UIImageView *dayLabel = _againDuigouArray[i];
        dayLabel.frame = CGRectMake(x+19, y+26, 16, 16);
//        dayLabel.text = @"补签";
//        dayLabel.textColor = [@"f75e6a" colorFromRGBcode];
//        dayLabel.font = [UIFont systemFontOfSize:10];
//        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e65e", 16, [UIColor colorWithHexString:@"eb2f38"])];
        
        NSInteger daysInLastMonth = [HYCalendarTool totaldaysInMonth:[HYCalendarTool lastMonth:date]];
        NSInteger daysInThisMonth = [HYCalendarTool totaldaysInMonth:date];
        NSInteger firstWeekday    = [HYCalendarTool firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            [self setDuigouStyle_BeyondThisMonth:dayIMG againLabel:dayLabel];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            [self setDuigouStyle_BeyondThisMonth:dayIMG againLabel:dayLabel];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
            [self setDuigouStyle_AfterToday:dayIMG againLabel:dayLabel];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        
        // this month
        if ([HYCalendarTool month:date] == [HYCalendarTool month:[NSDate date]]) {
            
            NSInteger todayIndex = [HYCalendarTool day:date] + firstWeekday - 1;
//            NSLog(@"todayIndex %ld",todayIndex);
            if (i <= todayIndex && i >= firstWeekday) {
                [self setStyle_BeforeToday:dayButton];
                [self setDuigouStyle_BeforeToday:dayIMG againLabel:dayLabel];
                [self setSign:i andBtn:dayButton imageView:dayIMG againLabel:dayLabel];
            }
//            else if(i ==  todayIndex){
//                [self setStyle_Today:dayButton];
//                [self setDuigouStyle_Today:dayIMG againLabel:dayLabel];
//                _dayButton = dayButton;
//                _dayIMG = dayIMG;
//                _dayLabel = dayLabel;
//            }
        }
    }
}


#pragma mark 设置已经签到
- (void)setSign:(int)i andBtn:(UIButton*)dayButton imageView: (UIImageView *)imgView againLabel: (UIImageView *) againLabel {
    [_signArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int now = i-4+1;
        int now2 = [obj intValue];
        if (now2 == now) {
            [self setStyle_SignEd:dayButton];
            [self setDuigouStyle_SignEd:imgView againLabel:againLabel];
        }
    }];
}


#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    _selectButton.selected = NO;
    dayBtn.selected = YES;
    _selectButton = dayBtn;
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
}


#pragma mark - date button style
//设置不是本月的日期字体颜色   ---白色  看不到
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 0;
}

- (void)setDuigouStyle_BeyondThisMonth: (UIImageView *)imgView againLabel: (UIImageView *) againLabel {
    imgView.hidden = true;
    againLabel.hidden = true;
}

//这个月 今日之前的日期style
- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:COLOR_FONT_ forState:UIControlStateNormal];
}

- (void)setDuigouStyle_BeforeToday: (UIImageView *)imgView againLabel: (UIImageView *) againLabel {
    imgView.hidden = YES;
    againLabel.hidden = NO;
}


//今日已签到
- (void)setStyle_Today_Signed:(UIButton *)btn
{
    btn.enabled = YES;
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_RED_ forState:UIControlStateSelected];
    [btn setBackgroundColor:COLOR_WHITE_];
}

- (void)setDuigouStyle_Today_Signed: (UIImageView *)imgView againLabel: (UILabel *) againLabel {
    imgView.hidden = NO;
    againLabel.hidden = YES;
}

//今日没签到
- (void)setStyle_Today:(UIButton *)btn
{
     btn.enabled = YES;
}
- (void)setDuigouStyle_Today: (UIImageView *)imgView againLabel: (UIImageView *) againLabel {
    imgView.hidden = YES;
    againLabel.hidden = NO;
    againLabel.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e65e", 16, [UIColor colorWithHexString:@"eb2f38"])];
}

//这个月 今天之后的日期style
- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = NO;
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setDuigouStyle_AfterToday: (UIImageView *)imgView againLabel: (UIImageView *) againLabel {
    imgView.hidden = YES;
    againLabel.hidden = YES;
}


//已经签过的 日期style
- (void)setStyle_SignEd:(UIButton *)btn
{
    btn.enabled = YES;
}

- (void)setDuigouStyle_SignEd: (UIImageView *)imgView againLabel: (UIImageView *) againLabel {
    imgView.hidden = NO;
    againLabel.hidden = YES;
}

@end
