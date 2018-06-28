//
//  AddNewBankViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "AddNewBankViewController.h"
#import "Newyuanmeng-Swift.h"
#import "BalanceCashViewController.h"

@interface AddNewBankViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *bankID;
@property (weak, nonatomic) IBOutlet UITextField *idCard;
@property (weak, nonatomic) IBOutlet CornerButton *next;

@property (weak, nonatomic) IBOutlet UIButton *agreeProcotol;
@end

@implementation AddNewBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _next.userInteractionEnabled = NO;
    _next.alpha = 0.8;
}

- (IBAction)next:(id)sender {

    NSArray *keys = @[@"user_id",@"bankcard",@"idcard",@"realname"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_bankID.text,_idCard.text,_name.text];
    [MySDKHelper postAsyncWithURL:@"/v1/bind_card_temp" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSString *verified = result[@"content"];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refershBank" object:nil userInfo:nil];
        
        [NoticeView showMessage:verified];
        [self.navigationController popViewControllerAnimated:YES];
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];

 
}
- (IBAction)procotol:(id)sender {
    if (_agreeProcotol.selected == YES) {
        _agreeProcotol.selected = NO;
        _next.userInteractionEnabled = NO;
        _next.alpha = 0.8;
    }
    else
    {
        _agreeProcotol.selected = YES;
        _next.userInteractionEnabled = YES;
        _next.alpha = 1;
    }
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
    for (id controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BalanceCashViewController class]]) {
           BalanceCashViewController *controller1 = (BalanceCashViewController *)controller;
            [self.navigationController popToViewController:controller1 animated:YES];
        }
    }
   
}
@end
