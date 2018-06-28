//
//  GoldWithdrawals.m
//  huabi
//
//  Created by TeamMac2 on 17/4/6.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "GoldWithdrawals.h"
#import "Withdrawals.h"
#import "YZPPickView.h"
@interface GoldWithdrawals ()<UITextFieldDelegate>
{
    UIButton *backBtn;
    UILabel *title;
}

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *cardLabel;
@property(nonatomic,strong)UILabel *bankLabel;
@property(nonatomic,strong)UILabel *LocationLabel;
@property(nonatomic,strong)UILabel *goldLabel;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UILabel *unit; //!<单位：元

@property(nonatomic,strong)UITextField *nameTextF;
@property(nonatomic,strong)UITextField *cardTextF;
@property(nonatomic,strong)UITextField *bankTextF;
@property(nonatomic,strong)UITextField *goldTextF;

@property(nonatomic,strong)UIButton *addressBtn;//选择开户所在地
@property(nonatomic,strong)UIButton *submitBtn;
@property(nonatomic,strong)UIButton *goBackBtn;

@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *counterFee;//!<手续费

//@property(nonatomic,strong)UIView *addressView;
//@property(nonatomic,assign)BOOL isClick;
//@property(nonatomic,copy)NSString *addressStr;
//@property(nonatomic,strong)NSMutableDictionary *mutDic;



@end

@implementation GoldWithdrawals
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.province = @" ";
    self.city = @" ";
    self.nameTextF.delegate = self;
    self.cardTextF.delegate = self;
    self.bankTextF.delegate = self;
    self.goldTextF.delegate = self;
    [self getCounterFee];
    [self createUI];
    
    
    
}


//-(NSMutableDictionary *)mutDic
//{
//    if (_mutDic == nil) {
//        _mutDic = [NSMutableDictionary dictionary];
//    }
//    return _mutDic;
//}


-(void)getCounterFee
{
    NSString *url = @"/v1/get_withdraw_set";
    [MySDKHelper postAsyncWithURL:url withParamBodyKey:@[@"type"] withParamBodyValue:@[@"balance"] needToken:self.token postSucceed:^(NSDictionary *result) {
        NSLog(@"获得手续费数据:");
        NSLog(@"%@",result);
        self.counterFee = result[@"content"][@"withdraw_fee_rate"];
        self.tipLabel.text = [NSString stringWithFormat:@"提现需要交纳%@%%的手续费，此费用由银行收取，请悉知。",self.counterFee];
        //        [weakSelf.tableV reloadData];
        
    } postCancel:^(NSString *error) {
        NSLog(@"错误信息:%@",error);
    }];

}

-(void)createUI
{
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 - 40, 25, 80, 25)];
    [title setTintColor:[UIColor blackColor]];
    [title setText:@"余额提现"];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:title];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 25, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"ic_back-1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight * 0.15, 40, 20)];
    self.nameLabel.text = @"姓名";
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.nameLabel];
    
    self.nameTextF = [[UITextField alloc] initWithFrame:CGRectMake(60, ScreenHeight * 0.15, 200, 20)];
    self.nameTextF.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextF.placeholder = @"收款人姓名";
    self.nameTextF.font = [UIFont systemFontOfSize:15];
    self.nameTextF.tintColor = [UIColor grayColor];
    [self.view addSubview:self.nameTextF];
    
    self.cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight * 0.25, 40, 20)];
    self.cardLabel.text = @"卡号";
    self.cardLabel.font = [UIFont systemFontOfSize:15];
    self.cardLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.cardLabel];
    
    self.cardTextF = [[UITextField alloc] initWithFrame:CGRectMake(60, ScreenHeight * 0.25, 200, 20)];
    self.cardTextF.borderStyle = UITextBorderStyleRoundedRect;
    self.cardTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.cardTextF.placeholder = @"收款人储蓄卡号";
    self.cardTextF.font = [UIFont systemFontOfSize:15];
    self.cardTextF.tintColor = [UIColor grayColor];
    [self.view addSubview:self.cardTextF];
    
    self.bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight * 0.35, 40, 20)];
    self.bankLabel.text = @"银行";
    self.bankLabel.font = [UIFont systemFontOfSize:15];
    self.bankLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.bankLabel];
    
    self.bankTextF = [[UITextField alloc] initWithFrame:CGRectMake(60, ScreenHeight * 0.35, 200, 20)];
    self.bankTextF.borderStyle = UITextBorderStyleRoundedRect;
    self.bankTextF.placeholder = @"请填写申请提现的银行";
    self.bankTextF.font = [UIFont systemFontOfSize:15];
    self.bankTextF.tintColor = [UIColor grayColor];
    [self.view addSubview:self.bankTextF];
    
    self.LocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight * 0.45, 100, 20)];
    self.LocationLabel.text = @"开户行所在地";
    self.LocationLabel.font = [UIFont systemFontOfSize:15];
    self.LocationLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.LocationLabel];
    
    self.addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addressBtn.frame = CGRectMake(self.LocationLabel.frame.size.width + 20, ScreenHeight * 0.45, 140, 20);
    [self.addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addressBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.addressBtn.btnTitleFont = [UIFont systemFontOfSize:15];
    self.addressBtn.backgroundColor = [UIColor whiteColor];
    [self.addressBtn addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addressBtn];
    
    self.goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight * 0.55, 40, 20)];
    self.goldLabel.text = @"金额";
    self.goldLabel.font = [UIFont systemFontOfSize:15];
    self.goldLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.goldLabel];
    
    self.goldTextF = [[UITextField alloc] initWithFrame:CGRectMake(60, ScreenHeight * 0.55, 200, 20)];
    self.goldTextF.borderStyle = UITextBorderStyleRoundedRect;
    self.goldTextF.keyboardType = UIKeyboardTypeDecimalPad;
    self.goldTextF.textColor = [UIColor redColor];
    self.goldTextF.tintColor = [UIColor redColor];
    self.goldTextF.textAlignment = NSTextAlignmentCenter;
    self.goldTextF.font = [UIFont systemFontOfSize:15];
    self.goldTextF.clearsOnBeginEditing = YES;
    [self.view addSubview:self.goldTextF];
    
    self.unit = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 40, ScreenHeight * 0.55, 30, 20)];
    self.unit.text = @"元";
    self.unit.textColor = [UIColor redColor];
    self.unit.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.unit];
    [self.unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goldTextF).mas_offset(80*ScaleWidth);
        make.centerY.mas_equalTo(self.goldLabel);
        make.width.mas_equalTo(60*ScaleWidth);
        make.height.mas_equalTo(40*ScaleWidth);
    }];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, ScreenHeight * 0.58, ScreenWidth - 20, 60)];
//    self.tipLabel.text = [NSString stringWithFormat:@"提现需要交纳%@%的手续费，此费用由银行收取,请悉知。",self.counterFee];
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.tipLabel];
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(15, ScreenHeight * 0.7, ScreenWidth * 0.9, ScreenWidth * 0.09);
    [self.submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    self.submitBtn.btnTitleFont = [UIFont systemFontOfSize:15];
    self.submitBtn.layer.cornerRadius = 10;
    self.submitBtn.backgroundColor = [UIColor redColor];
    [self.submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20*ScaleWidth);
        make.right.mas_equalTo(self.view).mas_offset(20*-(ScaleWidth));
        make.top.mas_equalTo(self.tipLabel).mas_offset(ScreenHeight * 0.7 - ScreenHeight * 0.58);
        make.width.mas_equalTo(ScreenWidth * 0.9);
        make.height.mas_equalTo(ScreenWidth * 0.09);
    }];
    
    self.goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goBackBtn.frame = CGRectMake(15, ScreenHeight * 0.7 + self.submitBtn.frame.size.height + 20, ScreenWidth * 0.9, ScreenWidth * 0.09);
    [self.goBackBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.goBackBtn.btnTitleFont = [UIFont systemFontOfSize:15];
    self.goBackBtn.layer.cornerRadius = 10;
    self.goBackBtn.btnTitleColor = [UIColor grayColor];
    self.goBackBtn.backgroundColor = [UIColor whiteColor];
    [self.goBackBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [self.goBackBtn.layer setBorderWidth:1];
    [self.goBackBtn.layer setMasksToBounds:YES];
    [self.goBackBtn addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goBackBtn];
    [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20*ScaleWidth);
        make.right.mas_equalTo(self.view).mas_offset(20*-(ScaleWidth));
        make.top.mas_equalTo(self.submitBtn).mas_offset(ScreenHeight * 0.7 + self.submitBtn.frame.size.height + 20 - ScreenHeight * 0.7);
        make.width.mas_equalTo(ScreenWidth * 0.9);
        make.height.mas_equalTo(ScreenWidth * 0.09);
    }];
}

#pragma mark 点击事件
-(void)submitClick:(UIButton *)sender
{
    
    NSArray *keys = [NSArray array];
    NSArray *values = [NSArray array];
    NSString *url = @"/v1/balance_withdraw";
    keys = @[@"user_id",@"token",@"name",@"bank",@"province",@"city",@"card_no",@"amount"];

    values = @[@(self.userID),self.token,self.nameTextF.text,self.bankTextF.text,self.province,self.city,self.cardTextF.text,self.goldTextF.text];

   if(self.nameTextF.text <=0 || self.bankTextF.text.length <= 0 || self.cardTextF.text.length < 16 || self.goldTextF.text.length <= 0 || [self.province isEqualToString:@" "] || [self.city isEqualToString:@" "]) {
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"填入信息有误，请填写正确的信息。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alerV show];
   }else{

        //    __weak typeof(self) weakSelf = self;
        [MySDKHelper postAsyncWithURL:url withParamBodyKey:keys withParamBodyValue:values needToken:self.token postSucceed:^(NSDictionary *result) {
            NSLog(@"解析数据成功,数据如下:");
            NSLog(@"%@",result);
            
            UIAlertView *successAler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交申请成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [successAler show];
            
            [self.navigationController popViewControllerAnimated:YES];
            //        [weakSelf.tableV reloadData];
            
        } postCancel:^(NSString *error) {
            NSLog(@"错误信息:%@",error);
            UIAlertView *errorAler = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [errorAler show];
        }];
    
   }


}

-(void)gotoBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addressClick:(UIButton *)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//    self.isClick = YES;
//    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    self.addressView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [self.view addSubview:self.addressView];
//    
//    
//    YZPPickView *pickView = [[YZPPickView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 200)];
//    pickView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
//    pickView.backgroundColor = [UIColor whiteColor];
//    pickView.delegate = self;
//    pickView.hasDefaul = YES;
//    [self.addressView addSubview:pickView];
//    
//    NSArray *btnArr = @[@"取消",@"确定"];
//    for (int i = 0; i < btnArr.count; i++) {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+i*(pickView.frame.size.width/2),pickView.frame.origin.y+ pickView.frame.size.height-40, pickView.frame.size.width/2, 40)];
//        if (i == 0) {
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        }else{
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        }
//        [btn setTitle:btnArr[i] forState:UIControlStateNormal];
//        btn.tag = 2000 + i;
//        [btn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.addressView addSubview:btn];
//    }
    
    [MySDKHelper getCityName:^(NSString *city) {
        
        //分割字符串
        NSArray *arr = [city componentsSeparatedByString:@"+"];
        [self.addressBtn setTitle:arr[0] forState:UIControlStateNormal];
        NSLog(@"%@",arr[0]);
        NSString *str = arr[0];
        NSArray *arr1 = [str componentsSeparatedByString:@" "];
        self.province = arr1[0];
        self.city = arr1[1];
    }];
}

//-(void)addressBtnAction:(UIButton *)sender
//{
//    if (sender.tag-2000) {
////        self.addressBtn.titleLabel.text = self.addressStr;
//        [self.addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
//        self.addressBtn.layer.cornerRadius = 5;
//        [self.addressBtn.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
//        [self.addressBtn.layer setBorderWidth:1];
//        [self.addressBtn.layer setMasksToBounds:YES];
//        NSArray *strArr = [self.addressStr componentsSeparatedByString:@" "];
//        [self.mutDic setValue:strArr[0] forKey:@"province"];
//        [self.mutDic setValue:strArr[1] forKey:@"city"];
//        NSLog(@"111111%@",strArr);
//    }
//    [self.addressView removeFromSuperview];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//    if (self.isClick == YES) {
//        [self.addressView removeFromSuperview];
//    }
//    self.isClick = NO;//yes就删除视图 
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//#pragma mark YZPPickViewDelegate
//- (void)didSelectPickView:(Provice*)provice city:(City *)city {
//    
////    [self.addressBtn setTitle:[NSString stringWithFormat:@"%@ %@",provice.name,city.name] forState:UIControlStateNormal];
//    self.addressStr = [NSString stringWithFormat:@"%@ %@",provice.name,city.name];
//}

#pragma clang diagnostic pop

@end
