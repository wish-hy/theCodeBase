//
//  AuthenticationThroughViewController.m
//  huabi
//
//  Created by hy on 2017/12/29.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "AuthenticationThroughViewController.h"
#import "Newyuanmeng-Swift.h"
#import "AddNewBankViewController.h"

@interface AuthenticationThroughViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *idCard;

@end

@implementation AuthenticationThroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 [self setInfo];
    
}

-(void)setInfo
{
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    [MySDKHelper postAsyncWithURL:@"/v1/name_verified_temp" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSDictionary *verified = result[@"content"];
        if (verified[@"realname"] != nil  && ![verified[@"realname"] isKindOfClass:[NSNull class]]) {
           self.name.text = [NSString stringWithFormat:@"%@",verified[@"realname"]];
        }
        if (verified[@"id_no"] != nil && ![verified[@"id_no"] isKindOfClass:[NSNull class]]) {
            self.idCard.text =  [NSString stringWithFormat:@"%@",verified[@"id_no"]];
        }
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
}

- (IBAction)bankCard:(id)sender {
    AddNewBankViewController *addNewBank = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"AddNewBankViewController"];
    addNewBank.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addNewBank animated:YES];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
