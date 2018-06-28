//
//  RechageCenterViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/23.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "RechageCenterViewController.h"
#import "Newyuanmeng-Swift.h"

@interface RechageCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backHome;
@property (weak, nonatomic) IBOutlet UIButton *custom;
@property (weak, nonatomic) IBOutlet UIButton *vip1;
@property (weak, nonatomic) IBOutlet UIButton *vip2;
@property (weak, nonatomic) IBOutlet UIButton *vip3;
@property (weak, nonatomic) IBOutlet UIButton *agent;

// 套餐金额高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyHeight;

// 购买商家二维码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyCode;

// 商家让利高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopBenefit;

// 充值币种高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rechageCurrency;


@property (weak, nonatomic) IBOutlet UILabel *comboMoney;  // 套餐金额
@property (weak, nonatomic) IBOutlet UILabel *sendPoint;  // 赠送积分


@property (weak, nonatomic) IBOutlet UITextField *send_scale; // 让利比例

@property (weak, nonatomic) IBOutlet UILabel *serveMoney;  // 技术服务费


@property (weak, nonatomic) IBOutlet UITextField *reachageMoney;  // 充值金额



@property (nonatomic,assign)NSInteger package;

@end

@implementation RechageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backHome setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e619", 30, [UIColor whiteColor])] forState:UIControlStateNormal];
    _custom.selected = YES;
    _moneyHeight.constant = 0;
    _buyCode.constant = 0;
    _shopBenefit.constant = 0;
    _rechageCurrency.constant = 100;
    _package = 0;
    _send_scale.text = @"0";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    

}
- (IBAction)next:(id)sender {
    NSLog(@"%i",[_send_scale.text intValue]);
    if ([_reachageMoney.text isEqualToString:@""]) {
        [NoticeView showMessage:@"请输入充值金额"];
    }
    else if (_agent.selected == YES)
    {
        if ([_send_scale.text isEqualToString:@""]) {
            [NoticeView showMessage:@"请输入让利比例"];
        }
        else if ([_send_scale.text intValue] >99  )
        {
            [NoticeView showMessage:@"让利比例不能大于99"];
        }
        else if ([_send_scale.text intValue] < 2)
        {
            [NoticeView showMessage:@"让利比例不能小于2"];
        }
        else
        {
            UPAPayViewController *payControl = [UPAPayViewController alloc];
            payControl.userID = [NSString stringWithFormat:@"%ld",(long)CommonConfig.UserInfoCache.userId];
            payControl.price = _reachageMoney.text;
            payControl.token = CommonConfig.Token;
            payControl.chongzhi = YES;
            payControl.package = _package;
            payControl.base_rate = _send_scale.text;
            [self.navigationController pushViewController:payControl animated:YES];
        }
    }
    else
    {
        UPAPayViewController *payControl = [UPAPayViewController alloc];
        payControl.userID = [NSString stringWithFormat:@"%ld",(long)CommonConfig.UserInfoCache.userId];
        payControl.price = _reachageMoney.text;
        payControl.token = CommonConfig.Token;
        payControl.chongzhi = YES;
        payControl.package = _package;
        payControl.base_rate = _send_scale.text;    // 后续优化在支付界面加判断
        [self.navigationController pushViewController:payControl animated:YES];
    }
    
}

- (IBAction)customClick:(id)sender {
    _custom.selected = YES;
    _vip1.selected = NO;
    _vip2.selected = NO;
    _vip3.selected = NO;
    _agent.selected = NO;
    
    _moneyHeight.constant = 0;
    _buyCode.constant = 0;
    _shopBenefit.constant = 0;
    _rechageCurrency.constant = 100;
    _reachageMoney.text = @"0";
    _reachageMoney.userInteractionEnabled = YES;
    _package = 0;
    _send_scale.text = @"0";
}

- (IBAction)vip1Click:(id)sender {
    _custom.selected = NO;
    _vip1.selected = YES;
    _vip2.selected = NO;
    _vip3.selected = NO;
    _agent.selected = NO;
    _moneyHeight.constant = 100;
    _buyCode.constant = 0;
    _shopBenefit.constant = 0;
    _rechageCurrency.constant = 100;
    _comboMoney.text = @"￥500";
    _sendPoint.text = @"500";
    _reachageMoney.text = @"500";
    _reachageMoney.userInteractionEnabled = NO;
    _package = 1;
    _send_scale.text = @"0";
}
- (IBAction)vip2Click:(id)sender {
    _custom.selected = NO;
    _vip1.selected = NO;
    _vip2.selected = YES;
    _vip3.selected = NO;
    _agent.selected = NO;
    _moneyHeight.constant = 100;
    _buyCode.constant = 0;
    _shopBenefit.constant = 0;
    _rechageCurrency.constant = 100;
    _comboMoney.text = @"￥1000";
    _sendPoint.text = @"1000";
    _reachageMoney.text = @"1000";
    _reachageMoney.userInteractionEnabled = NO;
    _package = 2;
    _send_scale.text = @"0";
}
- (IBAction)vip3Click:(id)sender {
    _custom.selected = NO;
    _vip1.selected = NO;
    _vip2.selected = NO;
    _vip3.selected = YES;
    _agent.selected = NO;
    _moneyHeight.constant = 100;
    _buyCode.constant = 0;
    _shopBenefit.constant = 0;
    _rechageCurrency.constant = 100;
    _comboMoney.text = @"￥2000";
    _sendPoint.text = @"2000";
    _reachageMoney.text = @"2000";
    _reachageMoney.userInteractionEnabled = NO;
    _package = 3;
    _send_scale.text = @"0";
}
- (IBAction)agentClick:(id)sender {
    _custom.selected = NO;
    _vip1.selected = NO;
    _vip2.selected = NO;
    _vip3.selected = NO;
    _agent.selected = YES;
    _moneyHeight.constant = 100;
    _buyCode.constant = 100;
    _shopBenefit.constant = 100;
    _rechageCurrency.constant = 0;
    _reachageMoney.userInteractionEnabled = NO;
    _comboMoney.text = @"￥3600";
    _sendPoint.text = @"3600";
    _package = 4;
    _reachageMoney.text = _comboMoney.text;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_send_scale resignFirstResponder];
    [_reachageMoney resignFirstResponder];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backHome:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
}

//- (void)keyboardWillChangeFrame:(NSNotification *)note{
//    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    self.viewToBottm.constant = ScreenHeight - frame.origin.y;
//    [UIView animateWithDuration:duration animations:^{
//        [self.view layoutIfNeeded];
//    }]; // textfield为xib创建，self.viewToBottm.constant为textfield距离view底部的距离
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
