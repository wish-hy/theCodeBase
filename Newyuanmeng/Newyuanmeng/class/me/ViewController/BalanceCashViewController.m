//
//  BalanceCashViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/26.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "BalanceCashViewController.h"
#import "Newyuanmeng-Swift.h"
#import "BankInfo.h"
#import "AddNewBankViewController.h"
#import "ChooseBankViewController.h"
#import "IdentityAuthenticationViewController.h"


@interface BalanceCashViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
//@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *discription;
@property (weak, nonatomic) IBOutlet UIView *bankChoose;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@property (nonatomic,strong)NSArray *userBankInfo;

@property (weak, nonatomic) IBOutlet CornerButton *next;
    
@property (nonatomic,strong)NSString *bankID;


@end

@implementation BalanceCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _balance.text = _balanceMoney;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refershBank:) name:@"bankID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBankInfo) name:@"unbundling" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBankInfo) name:@"refershBank" object:nil];
    if (_isBanlanceCard) {
        NSLog(@"银行卡");
//        self.name.userInteractionEnabled = YES;
        self.discription.userInteractionEnabled = YES;
        self.bankChoose.userInteractionEnabled = YES;
        self.width.constant = 120;
        
        [self.next setTitle:@"提现金额不小于100" forState:UIControlStateHighlighted];
        [self.next setTitle:@"确认提现" forState:UIControlStateNormal];
        self.next.userInteractionEnabled = NO;
        self.next.alpha = 0.7;
        self.next.highlighted = YES;
        [self getBankInfo];
    }
    else
    {
        self.width.constant = 60;
        self.image.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e77f", 40, [UIColor colorWithHexString:@"ef9530"])];
        [self.next setTitle:@"确认提现" forState:UIControlStateNormal];
        self.next.highlighted = NO;
        self.next.userInteractionEnabled = YES;
    }
}

//-(void)getBankInfo
//{
//
//    //  加载银行卡信息
//    NSArray *keys = @[@"user_id"];
//    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
//
//    [MySDKHelper postAsyncWithURL:@"/v1/bankcard_list" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
//        //        NSLog(@"%@",result);
//        NSMutableArray *bankInfo = [BankInfo mj_objectArrayWithKeyValuesArray:result[@"content"]];
//
//
//    } postCancel:^(NSString *error) {
//        NSLog(@"%@",error);
//        [NoticeView showMessage:error];
//    }];
//}

    // 监听textView值得改变
- (IBAction)textValueChange:(UITextField *)sender {
    if (_isBanlanceCard) {
        if ([self.money.text intValue] >= 100)
        {
              self.next.highlighted = NO;
            self.next.alpha = 1.0;
            self.next.userInteractionEnabled = YES;
        }
        else
        {
            self.next.alpha = 0.7;
            self.next.highlighted = YES;
            self.next.userInteractionEnabled = NO;

        }
    }
    
}
    
    //  更新银行卡信息
-(void)refershBank:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo[@"bank"];
    self.bankID = dic[@"bank_id"];
    self.discription.text = dic[@"bank_name"];
    [self.image sd_setImageWithURL:[NSURL URLWithString:dic[@"bank_img"]]];
}
    
-(void)chooseBank
{
    NSLog(@"选择银行卡");
    ChooseBankViewController *chooseBank = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseBankViewController"];
    chooseBank.bankInfo = [self.userBankInfo mutableCopy];
    chooseBank.hidesBottomBarWhenPushed = YES;
    chooseBank.ID = self.bankID;
    [self.navigationController pushViewController:chooseBank animated:YES];
}

-(void)addBank
{
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    [MySDKHelper postAsyncWithURL:@"/v1/name_verified" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSDictionary *verified = result[@"content"];
        if ([verified[@"verified"] isEqualToString:@"1"])
        {
            NSLog(@"添加银行卡");
            AddNewBankViewController *addNewBank = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"AddNewBankViewController"];
            addNewBank.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addNewBank animated:YES];
        }
        else
        {
            NSLog(@"身份未验证");
            IdentityAuthenticationViewController *ident = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"IdentityAuthenticationViewController"];
            ident.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ident animated:YES];
        }
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
}

    
-(void)getBankInfo
{
    //  加载银行卡信息
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    // 跳转银行卡列表事件
    UITapGestureRecognizer *bankChoos = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBank)];
    // 跳转添加银行卡界面事件
    UITapGestureRecognizer *addBanks = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBank)];
    
    [MySDKHelper postAsyncWithURL:@"/v1/bankcard_list" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
//        NSLog(@"%@",result);
         NSArray *bankInfo = [BankInfo mj_objectArrayWithKeyValuesArray:result[@"content"]];
        if (bankInfo.count == 0)
        {
            self.width.constant = 0;
            self.discription.text = @"点击绑定银行卡";
            [self.bankChoose addGestureRecognizer:addBanks];
        }
        else
        {
           self.width.constant = 120;
            self.userBankInfo = bankInfo;
            BankInfo *userBank = [bankInfo firstObject];
            self.discription.text = userBank.name;
            [self.image sd_setImageWithURL:[NSURL URLWithString:userBank.logo]];
            [self.bankChoose addGestureRecognizer:bankChoos];
            self.bankID = userBank.id;
        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
}

- (IBAction)balanceAllCash:(id)sender {
    if ([_balance.text intValue] >= 100)
        {
            _money.text = _balance.text;
            self.next.highlighted = NO;
            self.next.alpha = 1.0;
            self.next.userInteractionEnabled = YES;
        }
        else
        {
            [NoticeView showMessage:@"您的可用余额小于可提现金额!"];
        }
}

- (IBAction)next:(id)sender {

    if (_isBanlanceCard) {
        NSLog(@"银行卡提现");
        if (_isBalanceCash)
        {
            NSArray *keys = @[@"user_id",@"amount",@"id"];
            NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_money.text,_bankID];
            [MySDKHelper postAsyncWithURL:@"/v1/balance_withdraw" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
                
                [NoticeView showMessage: result[@"message"]];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getBalance" object:nil userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            } postCancel:^(NSString *error) {
                NSLog(@"%@",error);
                [NoticeView showMessage:error];
            }];
        }else{
            
            NSArray *keys = @[@"user_id",@"amount",@"bankcard_id"];
            NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_money.text,_bankID];
            NSLog(@"银行卡id ----------- %@",_bankID);
            [MySDKHelper postAsyncWithURL:@"/v1/offline_balance_withdraw" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
                
                [NoticeView showMessage: result[@"message"]];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getBalance" object:nil userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            } postCancel:^(NSString *error) {
                NSLog(@"%@",error);
                [NoticeView showMessage:error];
            }];
        }
        
    }
    else
    {
        NSArray *keys = @[@"user_id",@"amount"];
        NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_money.text];
        
        [MySDKHelper postAsyncWithURL:@"/v1/get_merchant_balance" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            
            [NoticeView showMessage: result[@"message"]];
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getBalance" object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [NoticeView showMessage:error];
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.money resignFirstResponder];
}
    
- (IBAction)backButton:(id)sender {
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

@end
