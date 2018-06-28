//
//  IdentityAuthenticationViewController.m
//  huabi
//
//  Created by hy on 2017/12/29.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "IdentityAuthenticationViewController.h"
#import "Newyuanmeng-Swift.h"
#import "AuthenticationThroughViewController.h"

@interface IdentityAuthenticationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *identity;
@property (weak, nonatomic) IBOutlet UIButton *propotol;
@property (weak, nonatomic) IBOutlet CornerButton *next;

@end

@implementation IdentityAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _next.userInteractionEnabled = NO;
    _next.alpha = 0.8;
}

- (IBAction)next:(id)sender {
    [self setInfo];
}

-(void)setInfo
{
    NSArray *keys = @[@"user_id",@"idcard",@"realname"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_identity.text,_name.text];
    [MySDKHelper postAsyncWithURL:@"/v1/name_verified_temp" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSString *verified = result[@"content"];
        [NoticeView showMessage:verified];
        AuthenticationThroughViewController *authent = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationThroughViewController"];
        authent.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authent animated:YES];
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.name resignFirstResponder];
    [self.identity resignFirstResponder];
}

- (IBAction)agreePropotol:(id)sender {
    if (_propotol.selected == YES) {
        _propotol.selected = NO;
        _next.userInteractionEnabled = NO;
        _next.alpha = 0.8;
    }
    else
    {
        _propotol.selected = YES;
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
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
