//
//  PurseViewController.m
//  huabi
//
//  Created by huangyang on 2017/11/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "PurseViewController.h"
#import "InteDetailController.h"
#import "Newyuanmeng-Swift.h"
#import "PurseRecharge.h"
#import "GoldRecord.h"
#import "Withdrawals.h"
#import "UserBalance.h"
#import "RechageCenterViewController.h"


@interface PurseViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *rechargeCenterImg;
@property (weak, nonatomic) IBOutlet UIImageView *balanceImg;
@property (weak, nonatomic) IBOutlet UIImageView *balanceWithdrawalImg;

@property (weak, nonatomic) IBOutlet UILabel *remainingPoints;  // 剩余积分
@property (weak, nonatomic) IBOutlet UILabel *yuE;  // 今日消费
@property (weak, nonatomic) IBOutlet UILabel *bance;  //余额


@property (weak, nonatomic) IBOutlet UIView *rechargeCenter;
@property (weak, nonatomic) IBOutlet UIView *balanceCenter;
@property (weak, nonatomic) IBOutlet UIView *takeBalance;

@property (weak, nonatomic) IBOutlet UIButton *back;

@end

@implementation PurseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBalance) name:@"getBalance" object:nil];
    if ([self.isShow isEqualToString:@"1"])
    {
        self.back.hidden = NO;
    }
    else
    {
        self.back.hidden = YES;
    }
    
    self.remainingPoints.userInteractionEnabled = YES;
    UITapGestureRecognizer *point = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pointClick)];
    [self.remainingPoints addGestureRecognizer:point];
    
    self.rechargeCenter.userInteractionEnabled = YES;
    UITapGestureRecognizer *recharg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rechargeClick)];
    [self.rechargeCenter addGestureRecognizer:recharg];
    
    self.balanceCenter.userInteractionEnabled = YES;
    UITapGestureRecognizer *balanceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balanceClick)];
    [self.balanceCenter addGestureRecognizer:balanceTap];
    
    self.takeBalance.userInteractionEnabled = YES;
    UITapGestureRecognizer *takeBalanceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeBalanceClick)];
    [self.takeBalance addGestureRecognizer:takeBalanceTap];
    
    [self requestInfo];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refershInfo) name:@"DownloadImageNotification" object:nil];
}

-(void)refershInfo
{
    NSLog(@"刷新数据");
    [self requestInfo];
}
-(void)refreshBalance
{
    NSLog(@"接收通知刷新钱袋余额");
    [self requestInfo];
}

- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pointClick  // 积分明细
{
    
    InteDetailController *intedetaill = [[InteDetailController alloc] init];
    intedetaill.user_id = CommonConfig.UserInfoCache.userId;
    intedetaill.token = CommonConfig.Token;
    intedetaill.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:intedetaill animated:YES];
}

-(void)rechargeClick  // 充值中心
{
//    PurseRecharge *purse = [[PurseRecharge alloc] init];
//    purse.userID = CommonConfig.UserInfoCache.userId;
//    purse.token = CommonConfig.Token;
//    [self.navigationController pushViewController:purse animated:YES];
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    RechageCenterViewController *rechageCenter = [stroy instantiateViewControllerWithIdentifier:@"RechageCenterViewController"];
    rechageCenter.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechageCenter animated:YES];
    
}

-(void)balanceClick  // 余额记录
{
    GoldRecord *balance = [[GoldRecord alloc] init];
    balance.userID = CommonConfig.UserInfoCache.userId;
    balance.token = CommonConfig.Token;
    [self.navigationController pushViewController:balance animated:YES];
}

-(void)takeBalanceClick // 余额提现
{
    Withdrawals *withd = [[Withdrawals alloc] init];
    withd.userID = CommonConfig.UserInfoCache.userId;
    withd.token = CommonConfig.Token;
    withd.goldNumber = self.bance.text;
    withd.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:withd animated:YES];
}

-(void)requestInfo
{
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
//    NSLog(@"%@-----%@--------%@",keys,values,CommonConfig.Token);
    [MySDKHelper postAsyncWithURL:@"/v1/huabi" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSLog(@"积分信息请求成功%@",result);
        NSDictionary *balanceInfo = result[@"content"];
        UserBalance *userBalance = [UserBalance mj_objectWithKeyValues:balanceInfo];
        NSString *str = [NSString stringWithFormat:@"%ld",(long)userBalance.order.todayamount];
        NSLog(@"%@",str);
        
        

        self.remainingPoints.text = userBalance.customer.point_coin;
        self.yuE.text = [NSString stringWithFormat:@"%ld",(long)userBalance.order.todayamount];
        self.bance.text = userBalance.customer.balance;
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];
}


-(void)initImage
{
    [TBCityIconFont setFontName:@"iconfont"];
    _rechargeCenterImg.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e676", 20, [UIColor whiteColor])];
    _rechargeCenterImg.backgroundColor = [UIColor colorWithHexString:@"5b9sff"];
    
    _balanceImg.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e698", 20, [UIColor whiteColor])];
    _balanceImg.backgroundColor = [UIColor colorWithHexString:@"f5634a"];
    
    _balanceWithdrawalImg.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e685", 20, [UIColor whiteColor])];
    _balanceWithdrawalImg.backgroundColor = [UIColor colorWithHexString:@"ff9c5b"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
