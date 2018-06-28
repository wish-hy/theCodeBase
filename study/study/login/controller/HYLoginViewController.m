//
//  HYLoginViewController.m
//  study
//
//  Created by hy on 2018/5/20.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYLoginViewController.h"
#import "HYRegisterViewController.h"
#import "HYUserModel.h"

@interface HYLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation HYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registers:(id)sender {
    HYRegisterViewController *registers = storyboardWith(@"Login", @"HYRegisterViewController");
    [self presentViewController:registers animated:YES completion:nil];
}

- (IBAction)loginClick:(id)sender {
    if ([_userName.text isEqualToString:@""]) {
        [ToastManage showCenterToastWith:@"请输入用户名或账号"];
        return;
    }
    if ([_passWord.text isEqualToString:@""]) {
        [ToastManage showCenterToastWith:@"请输入密码"];
        return;
    }
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"str"] = _userName.text;
    parm[@"pwd"] = _passWord.text;
    
    [HYHttpTool POST:BaseUrl(userLogin) parameters:parm success:^(id responseObject) {
        NSDictionary *users = responseObject[@"user"];
        HYUserModel *model = [HYUserModel mj_objectWithKeyValues:users];
        [UserDefaults setObject:@"YES" forKey:isLogin];
        [UserDefaults setObject:model.userAge forKey:userAge];
        [UserDefaults setObject:model.userAttention forKey:userAttention];
        [UserDefaults setObject:model.userAuthentication forKey:userAuthentication];
        [UserDefaults setObject:model.userBirthday forKey:userBirthday];
        [UserDefaults setObject:model.userCollect forKey:userCollect];
        [UserDefaults setObject:model.userCreateDate forKey:userCreateDate];
        [UserDefaults setObject:model.userEmail forKey:userEmail];
        [UserDefaults setObject:model.userFans forKey:userFans];
        [UserDefaults setObject:model.userHeadimg forKey:userHeadimg];
        [UserDefaults setObject:model.userId forKey:userId];
        [UserDefaults setObject:model.userIntegral forKey:userIntegral];
        [UserDefaults setObject:model.userInfo forKey:userInfo];
        [UserDefaults setObject:model.userLocation forKey:userLocation];
        [UserDefaults setObject:model.userName forKey:userName];
        [UserDefaults setObject:model.userNikename forKey:userNikename];
        [UserDefaults setObject:model.userPassword forKey:userPassword];
        [UserDefaults setObject:model.userPhone forKey:userPhone];
        [UserDefaults setObject:model.userQq forKey:userQq];
        [UserDefaults setObject:model.userSex forKey:userSex];
        [UserDefaults setObject:model.userWeixin forKey:userWeixin];
        
        
        [ToastManage showCenterToastWith:@"登录成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        [ToastManage showCenterToastWith:@"登录失败"];
    }];
    
}

@end
