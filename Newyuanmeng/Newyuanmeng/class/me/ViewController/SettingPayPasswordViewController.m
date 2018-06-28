//
//  SettingPayPasswordViewController.m
//  huabi
//
//  Created by teammac3 on 2018/2/8.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "SettingPayPasswordViewController.h"
#import "Newyuanmeng-Swift.h"

@interface SettingPayPasswordViewController ()
@property (nonatomic , strong) NSMutableArray *textFieldArr;
@end

@implementation SettingPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    self.title = @"支付密码";
   
    [self createUI];
    
    // Do any additional setup after loading the view from its nib.
}
- (NSMutableArray *)textFieldArr{
    if (_textFieldArr == nil) {
        _textFieldArr = [[NSMutableArray alloc] init];
    }
   return _textFieldArr;
}

- (void)createUI{
    NSArray *titleArr = @[@"当前密码",@"新密码",@"确认密码"];
    UIView *inputView = [self createInputView:titleArr];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_equalTo(20*ScaleHeight);
        make.height.mas_equalTo(40*3);
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(20*ScaleWidth);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(-20*ScaleWidth);
    }];
    
    UIView *tipView = [self createTipView];
    [self.view addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputView.mas_bottom).mas_equalTo(10*ScaleHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150*ScaleHeight);
    }];
    
    
    UIButton *button = [UIButton new];
    [button setTitle:@"确认" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.cornerRadius = 45/2;
    button.clipsToBounds = NO;
    button.layer.shadowColor = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1].CGColor;
    button.layer.shadowOffset = CGSizeMake(1, 1);
    button.layer.shadowRadius = 3;
    button.layer.shadowOpacity = 1;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:233/255.0 green:84/255.0 blue:38/255.0 alpha:1];
    [button addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipView.mas_bottom).mas_equalTo(100*ScaleHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(50*ScaleWidth);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(-50*ScaleWidth);
        make.height.mas_equalTo(45);
    }];
}



-(UIView *)createInputView:(NSArray *)titleArr{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    NSInteger height = 40;
    for (int i = 0 ; i < titleArr.count; i ++) {
        UILabel *label = [UILabel new];
        label.text = titleArr[i];
        label.textColor =  [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).mas_equalTo(20*ScaleWidth);
            make.top.mas_equalTo(view.mas_top).mas_equalTo(height*i);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(150*ScaleWidth);
        }];
        
        UITextField *textFiled = [[UITextField alloc] init];
        textFiled.font = [UIFont systemFontOfSize:14];
        textFiled.textColor = [UIColor blackColor];
        textFiled.placeholder = @"请输入";
        [view addSubview:textFiled];
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.centerY.mas_equalTo(label.mas_centerY);
            make.right.mas_equalTo(view.mas_right);
            make.height.mas_equalTo(height);
        }];
        [self.textFieldArr addObject:textFiled];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(label.mas_bottom);
            make.height.mas_equalTo(1);
            make.left.right.mas_equalTo(view);
        }];
    }
    return view;
}

- (UIView *)createTipView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [UILabel new];
    label.text = @"没有密码?";
    label.textColor =  [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:11];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).mas_equalTo(20*ScaleWidth);
        make.top.mas_equalTo(view.mas_top).mas_equalTo(40*ScaleHeight);
    }];
    
    UIButton *button = [UIButton new];
    [button setTitle:@"设置密码" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitleColor:[UIColor colorWithRed:141/255.0 green:164/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setPassWordAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label.mas_centerY);
        make.left.mas_equalTo(label.mas_right);
    }];
    
    UILabel *label1 = [UILabel new];
    label1.text = @"密码长度6位、纯数字";
    label1.textColor =  [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
    label1.font = [UIFont systemFontOfSize:9];
    [view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(label.mas_centerY);
    }];
    
    UIButton *button1 = [UIButton new];
    [button1 setTitle:@"重置密码" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:11];
    [button1 setTitleColor:[UIColor colorWithRed:141/255.0 green:164/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(reSetPassWordAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view.mas_right).mas_equalTo(-20*ScaleWidth);
        make.centerY.mas_equalTo(label.mas_centerY);
    }];
    
    
    UILabel *label2 = [UILabel new];
    label2.text = @"忘记密码?";
    label2.textColor =  [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
    label2.font = [UIFont systemFontOfSize:11];
    [view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(button1.mas_left);
       make.centerY.mas_equalTo(label.mas_centerY);
    }];
    
    UILabel *label3 = [UILabel new];
    label3.text = @"为了您的账户资金安全我们建议您设置支付密码！";
    label3.textColor =  [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
    label3.font = [UIFont systemFontOfSize:13];
    label3.numberOfLines = 0;
    [view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).mas_equalTo(30*ScaleHeight);
        make.left.mas_equalTo(view.mas_left).mas_equalTo(20*ScaleWidth);
        make.right.mas_equalTo(view.mas_right).mas_equalTo(-20*ScaleWidth);
    }];
    
    
    return view;
}

-(BOOL)checkInput{
    UITextField *txt1 = self.textFieldArr[0];
    UITextField *txt2 = self.textFieldArr[1];
    UITextField *txt3 = self.textFieldArr[2];
    if ([txt1.text isEqualToString:@""]) {
        [NoticeView showMessage:@"请输入当前密码"];
        return NO;
    }else if (txt1.text.length != 6){
        [NoticeView showMessage:@"请输入6位密码"];
        return NO;
    }
    
    if ([txt2.text isEqualToString:@""]) {
         [NoticeView showMessage:@"请输入新密码"];
        return NO;
    }else if (txt2.text.length != 6){
        [NoticeView showMessage:@"请输入6位的新密码"];
        return NO;
    }
    if (![txt3.text isEqualToString:txt2.text]) {
        [NoticeView showMessage:@"确认密码不一致"];
        return NO;
    }
    return YES;
}

#pragma mark -- 设置密码
-(void)setPassWordAction{
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    RegisterInputPhoneViewController *controller  = [stroy instantiateViewControllerWithIdentifier:@"RegisterInputPhoneViewController"];
    controller.isReset = 4;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -- 重置密码
- (void)reSetPassWordAction{
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    RegisterInputPhoneViewController *controller  = [stroy instantiateViewControllerWithIdentifier:@"RegisterInputPhoneViewController"];
    controller.isReset = 5;
     [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark -- 确认
- (void)sureAction{
    if ([self checkInput]) {
        UITextField *oldTextField = self.textFieldArr[0];
        UITextField *newTextField = self.textFieldArr[1];
        NSArray *keys = @[@"user_id",@"token",@"old_pay_pwd",@"new_pay_pwd"];
        NSArray *values = @[@(CommonConfig.UserInfoCache.userId),CommonConfig.Token,oldTextField.text,newTextField.text];
        [MySDKHelper postAsyncWithURL:@"/v1/update_paypwd" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            [NoticeView showMessage:result[@"message"]];
        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [NoticeView showMessage:error];

        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITextField *textField in self.textFieldArr) {
        [textField resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:233/255.0 green:84/255.0 blue:38/255.0 alpha:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
