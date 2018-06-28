//
//  OffLinPayMentViewController.m
//  huabi
//
//  Created by hy on 2018/1/2.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "OffLinPayMentViewController.h"
#import "Newyuanmeng-Swift.h"
#import "ChoosePayMents.h"
#import "PaySuccessViewController.h"

@interface OffLinPayMentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UIButton *payMentName;
@property (weak, nonatomic) IBOutlet UIImageView *payMentIcon;

@property (nonatomic,strong)UIView *backGround;

@property (nonatomic,strong)NSDictionary *Payinfo;
@end

@implementation OffLinPayMentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView) name:@"closeChooseView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpaySuccess) name:@"wxpaySuccess" object:nil];
}
-(void)removeView
{
    [_backGround removeFromSuperview];
}
-(void)setInfo
{
    NSArray *keys = @[@"user_id",@"seller_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_seller_id];
    [MySDKHelper postAsyncWithURL:@"/v1/seller_name" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSString *shop_name = result[@"content"][@"shop_name"];
        self.name.text = shop_name;

        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
}

- (IBAction)choosePayMent:(id)sender {
    [_money resignFirstResponder];
    UIView *backGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backGround.backgroundColor = [UIColor grayColor];
    backGround.alpha = 0.5;
    _backGround = backGround;
    [self.view addSubview:backGround];
    ChoosePayMents *choose = [ChoosePayMents creatChoosePayMentView];
    choose.isRedBag = NO;
    choose.money = _money.text;
    choose.sell_id = _seller_id;
    [self.view addSubview:choose];
    
        [choose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScreenHeight/2+50);
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];

}

- (IBAction)doPay:(id)sender {
    [_money resignFirstResponder];
    if ([_money.text isEqualToString:@""]) {
        [NoticeView showMessage:@"请输入支付金额"];
        return;
    }
//    NSLog(@"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
    
    NSArray *keys = @[@"user_id",@"payment_id",@"order_amount",@"seller_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@"18",_money.text,_seller_id];
    [MySDKHelper postAsyncWithURL:@"/v1/dopays" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        NSDictionary *Payinfo = result[@"content"];
        _Payinfo = Payinfo;
//        NSString *order_id = Payinfo[@"order_id"];
        NSLog(@"发起支付%@",Payinfo);
        
        NSDictionary *info = [NSDictionary dictionaryWithDictionary:Payinfo[@"senddata"]];
        [WXPayHelper payForWXPayWithViewController:self withAppid:[NSString stringWithFormat:@"%@",info[@"appid"]] withPartnerid:[NSString stringWithFormat:@"%@",info[@"partnerid"]] withPrepayid:[NSString stringWithFormat:@"%@",info[@"prepayid"]] withPrivateKey:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withTimeStamp:[[NSString stringWithFormat:@"%@",info[@"timestamp"]]intValue] withNonceStr:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withSign:[NSString stringWithFormat:@"%@",info[@"sign"]]];
       
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
}
-(void)wxpaySuccess
{
    PaySuccessViewController *paySuccess = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySuccessViewController"];
    paySuccess.price = _money.text;
    paySuccess.order_id = _Payinfo[@"order_id"];
    [self.navigationController pushViewController:paySuccess animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_money resignFirstResponder];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
