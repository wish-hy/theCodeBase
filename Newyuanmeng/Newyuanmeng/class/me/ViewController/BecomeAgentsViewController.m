//
//  BecomeAgentsViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "BecomeAgentsViewController.h"
#import "Newyuanmeng-Swift.h"

@interface BecomeAgentsViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *actibateButton;

@end

@implementation BecomeAgentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.code.delegate = self;
}

- (IBAction)activateButton:(id)sender {
    if (_code.text.length  == 0) {
        [NoticeView showMessage:@"请输入激活码"];
    }
    else
    {
        NSArray *keys = @[@"user_id",@"code"];
        NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_code.text];
        NSLog(@"%@-----%@--------%@",keys,values,CommonConfig.Token);
        [SVProgressHUD showWithStatus:@"正在激活"];
        [MySDKHelper postAsyncWithURL:@"/v1/input_code" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            NSLog(@"登录信息请求成功%@",result);
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadImageNotification" object:nil];
            [NoticeView showMessage:result[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            [NoticeView showMessage:error];
            
        }];
    }
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_code resignFirstResponder];
}

- (IBAction)backClick:(id)sender {
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
