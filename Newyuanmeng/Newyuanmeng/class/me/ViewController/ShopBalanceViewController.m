//
//  ShopBalanceViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ShopBalanceViewController.h"
#import "Newyuanmeng-Swift.h"
#import "UserBalance.h"
#import "BalanceCashViewController.h"
#import "CashBalanceRecordViewController.h"

@interface ShopBalanceViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet CornerButton *bankCardButton;
@property (weak, nonatomic) IBOutlet CornerButton *balanceButton;

@property (nonatomic,strong)NSString *balanceStr;
@end

@implementation ShopBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankCardButton.userInteractionEnabled = NO;
    self.image.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e77f", 100, [UIColor colorWithHexString:@"ef9530"])];
    [self setInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBalance) name:@"getBalance" object:nil];
}

-(void)refreshBalance
{
    [self setInfo];
}

-(void)setInfo
{
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    //    NSLog(@"%@-----%@--------%@",keys,values,CommonConfig.Token);
    [MySDKHelper postAsyncWithURL:@"/v1/huabi" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSDictionary *balanceInfo = result[@"content"];
        UserBalance *userBalance = [UserBalance mj_objectWithKeyValues:balanceInfo];
        NSString *str = [NSString stringWithFormat:@"￥%@",userBalance.customer.offline_balance];
        self.balanceStr = userBalance.customer.offline_balance;
        self.balance.text = str;
        
        if ([userBalance.customer.offline_balance floatValue] >= 100) {
            [self.bankCardButton setTitle:@"提现到银行卡" forState:UIControlStateNormal];
            self.bankCardButton.adjustsImageWhenHighlighted = NO;
            self.bankCardButton.userInteractionEnabled = YES;
        }
        else
        {
            self.bankCardButton.adjustsImageWhenHighlighted = YES;
            self.bankCardButton.userInteractionEnabled = NO;
        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//  银行卡提现
- (IBAction)CashBankCard:(id)sender {
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    BalanceCashViewController *balance = [stroy instantiateViewControllerWithIdentifier:@"BalanceCashViewController"];
     balance.isBalanceCash = NO;
    balance.balanceMoney = self.balanceStr;
    balance.isBanlanceCard = YES;
    [self.navigationController pushViewController:balance animated:YES];
    
}


//  余额提现
- (IBAction)CashBalance:(id)sender {
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    BalanceCashViewController *balance = [stroy instantiateViewControllerWithIdentifier:@"BalanceCashViewController"];
    balance.balanceMoney = self.balanceStr;
    balance.isBanlanceCard = NO;
    [self.navigationController pushViewController:balance animated:YES];
    
}

// 提现记录
- (IBAction)CarshRecord:(id)sender {
    CashBalanceRecordViewController *cashBalance = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"CashBalanceRecordViewController"];
    cashBalance.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cashBalance animated:YES];
}

@end
