//
//  SingInViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/9.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "SingInViewController.h"
#import "HYCalendarView.h"
#import "FSCalendar.h"

@interface SingInViewController ()<FSCalendarDataSource, FSCalendarDelegate>

@property (weak, nonatomic) FSCalendar *calendar;

//@property (nonatomic,strong)HYCalendarView *calendarView;
@property (nonatomic,strong)UIButton *singIn;

@property (nonatomic,strong)UILabel *days;
@property (nonatomic,strong)NSMutableArray *signArray;
@property (nonatomic,strong)NSDateComponents *comp;

@property (nonatomic,strong)UILabel *send_point;

@property (nonatomic,strong)UIView *custom;
@property (nonatomic,strong)UIImageView *imagev;

@property (nonatomic, strong) NSDictionary *signs;   // 已签到数据
@property (nonatomic, strong) UILabel *titleDate; // 标题日期
@end

@implementation SingInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _signArray = [NSMutableArray array];
   _comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    
    [self setInfoWithMonth:[NSString stringWithFormat:@"%ld",(long)[_comp month]] year:[NSString stringWithFormat:@"%ld",(long)[_comp year]]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *serialDay = [userDefaults objectForKey:@"serial_day"];
    
    [self initWithView];
    [self initWithNavgation];
//    [self setTodaySignIn];
    // 连续签到天数
    if ([serialDay isEqualToString:@""] || serialDay == nil) {
        self.days.text = @"0";
    }else{
        self.days.text = serialDay;
    }
    
    
    
}

-(void)setInfoWithMonth:(NSString *)month year:(NSString *)year
{
    NSArray *keys = [[NSArray alloc] init];
    NSArray *values = [[NSArray alloc] init];
    keys = @[@"user_id",@"token",@"y",@"m"];
    values = @[@(_user_id),_token,year,month];

    [MySDKHelper postAsyncWithURL:@"/v1/get_sign_in_data_by_ym" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {

        NSDictionary *dateDic = result[@"content"];
        NSArray *keyArr = dateDic.allKeys;

        NSMutableArray *signArry = [NSMutableArray array];

        NSMutableDictionary *signs = [NSMutableDictionary dictionary];
        for (int i = 0; i < keyArr.count; i++)
        {
            NSDictionary *date = [dateDic objectForKey:keyArr[i]];

            NSString *dateString = [NSString stringWithFormat:@"%@",[date objectForKey:@"sign"]];
//            if ([dateString isEqualToString:@"1"])
//            {
//               NSNumber *signDay = [NSNumber numberWithInt:[keyArr[i] intValue]];
//                [signArry addObject:signDay];
//            }
            [signs setObject:dateString forKey:keyArr[i]];
        }
        self.signs = signs;
        [self.calendar reloadData];
        NSLog(@"签到日期 %@",signs);
        NSString *str = [NSString stringWithFormat:@"%ld",(long)[_comp day]];
        if ([signArry containsObject:[NSNumber numberWithInt:[str intValue]]]) {
            self.singIn.selected = YES;
        }
        _signArray = signArry;
        NSLog(@"%@",_signArray);
//        self.calendarView.signArray = _signArray;
//        self.calendarView.date = [NSDate date];
    } postCancel:^(NSString *error) {
//        self.calendarView.signArray = _signArray;
//        self.calendarView.date = [NSDate date];
        [NoticeView showMessage:error];
        NSLog(@"我是错误----%@",error);

    }];
}



- (void)singInBtnClick {
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSNumber *day = [NSNumber numberWithInteger:[comp day]];

//    [self setTodaySignIn];
    
    _singIn.selected = YES;
    NSLog(@"点击 签到");
    
    NSArray *keys = [[NSArray alloc] init];
    NSArray *values = [[NSArray alloc] init];
    keys = @[@"user_id",@"token"];
    values = @[@(_user_id),_token];
    [MySDKHelper postAsyncWithURL:@"/v1/sign_in" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//    NSDictionary *result = @{
//                               @"send_point":@"10",
//                               @"serial_day":@"3"
//                               };
        NSDictionary *signInfo = result[@"content"];

            NSString *sendPoint = [signInfo objectForKey:@"send_point"];
            NSString *serialDay = [signInfo objectForKey:@"serial_day"];

            [[NSUserDefaults standardUserDefaults] setObject:serialDay forKey:@"serial_day"];
            [[NSUserDefaults standardUserDefaults] setObject:sendPoint forKey:@"send_point"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"签到天数%@",serialDay);
    
        self.send_point.text = signInfo[@"send_point"];
        self.days.text = serialDay;
        
        [_signArray addObject:day];
        NSLog(@"qiandaohou---%@",_signArray);
//        self.calendarView.signArray = _signArray;
//        self.calendarView.date = [NSDate date];
        [self initWithCustom];
//        [self setTodaySignIn];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
        NSLog(@"我是错误------%@",error);

    }];
}


-(void)buttonClick
{
    [self.custom removeFromSuperview];
    [self.imagev removeFromSuperview];
}

//-(void)setTodaySignIn
//{
//    __weak typeof(HYCalendarView) *weakDemo = self.calendarView;
//    [weakDemo setStyle_Today_Signed:weakDemo.dayButton];
//    [weakDemo setDuigouStyle_Today_Signed:weakDemo.dayIMG againLabel:weakDemo.dayLabel];
//}


-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initWithCustom
{
    UIView *custom = [[UIView alloc] init];
    custom.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    custom.backgroundColor = [UIColor grayColor];
    self.custom = custom;
    custom.alpha = 0.8;
    [self.view addSubview:custom];
    
    UIImageView *imagev = [[UIImageView alloc] init];
    imagev.image = [UIImage imageNamed:@"yuanjiao_background"];
    imagev.layer.cornerRadius = 6;
    imagev.clipsToBounds = YES;
    self.imagev = imagev;
    imagev.userInteractionEnabled = YES;
    imagev.frame = CGRectMake(ScreenWidth/2-140, ScreenHeight/2-200, 280, 400);
    [self.view addSubview:imagev];
    
    UIImageView *backgro = [[UIImageView alloc] init];
    backgro.image = [UIImage imageNamed:@"qiandaojuxing"];
    backgro.frame = CGRectMake(0, 0, 280, 50);
    [imagev addSubview:backgro];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"签到成功";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.frame = CGRectMake(backgro.bounds.size.width/2-50, backgro.bounds.size.height/2-15, 100, 30);
    lab.textColor = [UIColor redColor];
    [backgro addSubview:lab];
    
    UIImageView *moneyImg = [[UIImageView alloc] init];
    moneyImg.image = [UIImage imageNamed:@"money"];
    moneyImg.frame = CGRectMake(imagev.bounds.size.width/2-120, 50, 240, 260);
    [imagev addSubview:moneyImg];
    
    //    NSString *str = @"恭喜您获得10积分，连续签到会有更多惊喜哦";
    //    NSMutableAttributedString *strs = [[NSMutableAttributedString alloc] initWithString:str];
    //    [strs addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, 3)];
    
    UIButton *click = [UIButton buttonWithType:UIButtonTypeCustom];
    [click setBackgroundImage:[UIImage imageNamed:@"sign_in_success_background"] forState:UIControlStateNormal];
    [click setTitle:@"确定" forState:UIControlStateNormal];
    click.titleLabel.textColor = [UIColor whiteColor];
    click.frame = CGRectMake(imagev.bounds.size.width/2-40, imagev.bounds.size.height-60, 80, 40);
    [click addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [imagev addSubview:click];
    
}
//上一月按钮点击事件
- (void)previousClicked:(id)sender {
    
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:previousMonth];
    NSLog(@"%ld",(long)[comp month]);
    [self setInfoWithMonth:[NSString stringWithFormat:@"%ld",(long)[comp month]] year:[NSString stringWithFormat:@"%ld",(long)[comp year]]];
    self.titleDate.text = [NSString stringWithFormat:@"%ld年%ld月",(long)[comp year],(long)[comp month]];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

//下一月按钮点击事件
- (void)nextClicked:(id)sender {
    
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:nextMonth];
    
    [self setInfoWithMonth:[NSString stringWithFormat:@"%ld",(long)[comp month]] year:[NSString stringWithFormat:@"%ld",(long)[comp year]]];
    self.titleDate.text = [NSString stringWithFormat:@"%ld年%ld月",(long)[comp year],(long)[comp month]];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}


-(void)initWithView
{
    UIScrollView *selfview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight)];
    selfview.contentSize = CGSizeMake(ScreenWidth, 820);
    [self.view addSubview:selfview];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 250)];
    background.image = [UIImage imageNamed:@"jianbian"];
    [selfview addSubview:background];
    
    UIImageView *zhuangshi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 250)];
    zhuangshi.image = [UIImage imageNamed:@"zhuangshi"];
    [selfview addSubview:zhuangshi];
    
    UIImageView *buttonBackground = [[UIImageView alloc] init];
    buttonBackground.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.3];
    buttonBackground.layer.cornerRadius = 80;
    [selfview addSubview:buttonBackground];
    [buttonBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(background);
        make.size.mas_equalTo(CGSizeMake(160, 160));
    }];
    
    UIImageView *buttonBackground2 = [[UIImageView alloc] init];
    buttonBackground2.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.8];
    buttonBackground2.layer.cornerRadius = 70;
    [selfview addSubview:buttonBackground2];
    [buttonBackground2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(background);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];
    
    _singIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_singIn setTitle:@"签到" forState:UIControlStateNormal];
    _singIn.titleLabel.font = [UIFont systemFontOfSize:28];
    [_singIn setTitle:@"已签到" forState:UIControlStateSelected];
    [_singIn addTarget:self action:@selector(singInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_singIn setTitleColor:[UIColor colorWithHexString:@"eb2f38"] forState:UIControlStateNormal];
    [selfview addSubview:_singIn];
    [_singIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(buttonBackground.mas_centerX);
        make.centerY.mas_equalTo(buttonBackground.mas_centerY).mas_equalTo(-15);
    }];
    
    UIView *xian = [[UIView alloc] init];
    xian.backgroundColor = [UIColor colorWithHexString:@"eb8d91"];
    [selfview addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_singIn.mas_bottom).mas_equalTo(3);
        make.left.mas_equalTo(buttonBackground2.mas_left).mas_equalTo(20);
        make.right.mas_equalTo(buttonBackground2.mas_right).mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *prompting = [[UILabel alloc] init];
    prompting.text = @"连续签到";
    prompting.font = [UIFont systemFontOfSize:14];
    prompting.textAlignment = NSTextAlignmentLeft;
    prompting.textColor = [UIColor colorWithHexString:@"eb8d91"];
    [selfview addSubview:prompting];
    [prompting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xian.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(xian.mas_left).mas_equalTo(5);
        
    }];
    UILabel *prompting2 = [[UILabel alloc] init];
    prompting2.text = @"0";
    _days = prompting2;
    prompting2.font = [UIFont systemFontOfSize:20];
    prompting2.textAlignment = NSTextAlignmentCenter;
    prompting2.textColor = [UIColor colorWithHexString:@"ffbb00"];
    [selfview addSubview:prompting2];
    [prompting2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(prompting.mas_centerY);
        make.left.mas_equalTo(prompting.mas_right).mas_equalTo(3);
        
    }];
    
    UILabel *prompting3 = [[UILabel alloc] init];
    prompting3.text = @"天";
    prompting3.font = [UIFont systemFontOfSize:14];
    prompting3.textAlignment = NSTextAlignmentRight;
    prompting3.textColor = [UIColor colorWithHexString:@"eb8d91"];
    [selfview addSubview:prompting3];
    [prompting3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(prompting2.mas_centerY);
        make.right.mas_equalTo(xian.mas_right).mas_equalTo(-5);
    }];
    
    UILabel *texts = [[UILabel alloc] init];
    texts.text = @"今日签到可领取";
    texts.font = [UIFont systemFontOfSize:10];
    texts.textAlignment = NSTextAlignmentRight;
    texts.textColor = [UIColor colorWithHexString:@"ffffff"];
    //    texts.backgroundColor = [UIColor whiteColor];
    [selfview addSubview:texts];
    [texts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(buttonBackground.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(buttonBackground.mas_left).mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *text2 = [[UILabel alloc] init];
    text2.text = @"10";
    self.send_point = text2;
    text2.font = [UIFont systemFontOfSize:10];
    text2.textColor = [UIColor colorWithHexString:@"ffbb00"];
    //    text2.backgroundColor = [UIColor blueColor];
    text2.textAlignment = NSTextAlignmentCenter;
    [selfview addSubview:text2];
    [text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(buttonBackground.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(texts.mas_right);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *text3 = [[UILabel alloc] init];
    text3.text = @"积分";
    text3.textColor = [UIColor colorWithHexString:@"ffffff"];
    text3.font = [UIFont systemFontOfSize:10];
    text3.textAlignment = NSTextAlignmentLeft;
    //    text3.backgroundColor = [UIColor greenColor];
    [selfview addSubview:text3];
    [text3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(buttonBackground.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(text2.mas_right);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(15);
    }];
    UILabel *text4 = [[UILabel alloc] init];
    text4.text = @"累计签到越多，赠送越多";
    text4.textAlignment = NSTextAlignmentCenter;
    text4.textColor = [UIColor whiteColor];
    text4.font = [UIFont systemFontOfSize:9];
    [selfview addSubview:text4];
    [text4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(texts.mas_bottom).mas_equalTo(5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        //        make.width.mas_equalTo(100);
        //        make.height.mas_equalTo(10);
    }];
    
    UIView *segment = [[UIView alloc] init];
    //    segment.backgroundColor = [UIColor grayColor];
    [selfview addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(background.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *date = [[UILabel alloc] init];
//    date.text = @"2017年12月";
    self.titleDate = date;
    date.text = [NSString stringWithFormat:@"%ld年%ld月",(long)[_comp year],(long)[_comp month]];
    date.textColor = [UIColor colorWithHexString:@"696969"];
    date.font = [UIFont systemFontOfSize:18];
    date.textAlignment = NSTextAlignmentCenter;
    [selfview addSubview:date];
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(segment);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
    }];
    
    UIButton *previous = [UIButton buttonWithType:UIButtonTypeCustom];
    [previous setTitle:@"<" forState:UIControlStateNormal];
    [previous setTitleColor:[UIColor colorWithHexString:@"696969"] forState:UIControlStateNormal];
    previous.titleLabel.font = [UIFont systemFontOfSize:20];
    [previous addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [selfview addSubview:previous];
    [previous mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(date.mas_left).mas_equalTo(-10);
        make.centerY.mas_equalTo(date);

    }];

    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@">" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor colorWithHexString:@"696969"] forState:UIControlStateNormal];
    next.titleLabel.font = [UIFont systemFontOfSize:20];
    [next addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [selfview addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(date.mas_right).mas_equalTo(10);
        make.centerY.mas_equalTo(date);

    }];
    
    UIView *calendars = [[UIView alloc] init];
//        calendars.backgroundColor = [UIColor colorWithHexString:@"666666"];
    [selfview addSubview:calendars];
    [calendars mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(segment.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(400);
    }];
    
//    HYCalendarView *calendarView = [[HYCalendarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 308)];
//    self.calendarView = calendarView;
//    [calendar addSubview:calendarView];
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 308)];
    calendar.dataSource = self;
    calendar.delegate = self;
    // 设置不能翻页
//    calendar.pagingEnabled = NO;
    calendar.scrollEnabled = NO;
    calendar.headerHeight = 0;
    calendar.calendarHeaderView.hidden = YES;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;  // 设置周次为一,二
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    calendar.locale = locale;
    calendar.today = nil;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    calendar.backgroundColor = [UIColor whiteColor];
    [calendars addSubview:calendar];
    self.calendar = calendar;
    
    
    UILabel *fengexian = [[UILabel alloc] init];
    fengexian.backgroundColor = [UIColor colorWithHexString:@"cacaca"];
    fengexian.alpha = 0.4;
    [selfview addSubview:fengexian];
    [fengexian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(calendar.mas_bottom).mas_equalTo(15);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e65b", 30, [UIColor colorWithHexString:@"ff3d3d"])];
    [selfview addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(15);
        make.top.mas_equalTo(fengexian.mas_bottom).mas_equalTo(10);
    }];
    
    UILabel *qiandaoGuiZe = [[UILabel alloc] init];
    qiandaoGuiZe.text = @"签到规则";
    qiandaoGuiZe.textColor = [UIColor colorWithHexString:@"696969"];
    qiandaoGuiZe.font = [UIFont systemFontOfSize:18];
    [selfview addSubview:qiandaoGuiZe];
    [qiandaoGuiZe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(img.mas_centerY);
        make.left.mas_equalTo(img.mas_right);
    }];
    
    UIImageView *dian = [[UIImageView alloc] init];
    dian.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e602", 5, [UIColor colorWithHexString:@"ffbb00"])];
    [selfview addSubview:dian];
    [dian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_left).mas_equalTo(5);
        make.top.mas_equalTo(img.mas_bottom).mas_equalTo(15);
    }];
    
    UIImageView *dian2 = [[UIImageView alloc] init];
    dian2.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e602", 5, [UIColor colorWithHexString:@"ffbb00"])];
    [selfview addSubview:dian2];
    [dian2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_left).mas_equalTo(5);
        make.top.mas_equalTo(dian.mas_bottom).mas_equalTo(15);
    }];
    
    UIImageView *dian3 = [[UIImageView alloc] init];
    dian3.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e602", 5, [UIColor colorWithHexString:@"ffbb00"])];
    [selfview addSubview:dian3];
    [dian3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_left).mas_equalTo(5);
        make.top.mas_equalTo(dian2.mas_bottom).mas_equalTo(15);
    }];
    
    UILabel *guiZe1 = [[UILabel alloc] init];
    guiZe1.textColor = [UIColor colorWithHexString:@"919191"];
    guiZe1.font = [UIFont systemFontOfSize:12];
    guiZe1.text = @"1、每日签到可获取10积分";
    [selfview addSubview:guiZe1];
    [guiZe1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(dian.mas_right).mas_equalTo(3);
    }];
    
    UILabel *guiZe2 = [[UILabel alloc] init];
    guiZe2.text = @"2、累计签到越多，赠送越多";
    guiZe2.textColor = [UIColor colorWithHexString:@"919191"];
    guiZe2.font = [UIFont systemFontOfSize:12];
    [selfview addSubview:guiZe2];
    [guiZe2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dian.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(dian.mas_right).mas_equalTo(3);
    }];
    
    UILabel *guiZe3 = [[UILabel alloc] init];
    guiZe3.textColor = [UIColor colorWithHexString:@"919191"];
    guiZe3.font = [UIFont systemFontOfSize:12];
    guiZe3.text = @"3、如签到中断，从初始值重新计算";
    [selfview addSubview:guiZe3];
    [guiZe3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dian2.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(dian.mas_right).mas_equalTo(3);
    }];
}

-(void)initWithNavgation
{
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"每日签到";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(ScreenWidth/2 - 60, 25, 120, 30);
    [view addSubview:label];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e657", 30, [UIColor blackColor])] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [back sizeToFit];
    back.frame = CGRectMake(5, 20, 30, 30);
    [view addSubview:back];
    
}

#pragma mark - calendar代理
//  签到控制
-(UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date
{
    // 获取date格式时间的年  月  日
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    // 格式化时间日期
//    [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle]
    
    NSString *day = [NSString stringWithFormat:@"%ld",(long)[comp day]];
    
    NSString *status = [self.signs objectForKey:day];
    
    UIImage *img = [UIImage imageNamed:@""];
    if ([status isEqualToString:@"-1"]) {
        img = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e65e", 16, [UIColor colorWithHexString:@"eb2f38"])];
    }else if ([status isEqualToString:@"1"]){
         img = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e65c", 14, [UIColor orangeColor])];
    }else{
       img = [UIImage imageNamed:@""];
    }
    
    return img;
}

// 是否允许通过点击选择指定日期
-(BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}


@end
