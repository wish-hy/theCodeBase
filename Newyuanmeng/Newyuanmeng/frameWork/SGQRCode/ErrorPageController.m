//
//  ErrorPageController.m
//  huabi
//
//  Created by teammac3 on 2017/4/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ErrorPageController.h"

@interface ErrorPageController ()

@end

@implementation ErrorPageController

- (void)viewWillAppear:(BOOL)animated{
    
    //时间颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建导航栏
    [self createNavigationView];
    
    [self promptMessage:@".....扫描错误，请重试....."];
    
}

#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    //    navView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 25, 25)];
    //    [backBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e61e", 50, [UIColor redColor])] forState:UIControlStateNormal];
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size:30];
    backBtn.titleLabel.font = iconfont;
    [backBtn setTitle:@"\U0000e61e" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.center = CGPointMake(ScreenWidth/2, 40);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"出错页面";
    [navView addSubview:title];
    
}

#pragma mark - 按钮事件
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//提示视图
- (void)promptMessage:(NSString *)prompt{
    
    UILabel *promptM = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    promptM.center = CGPointMake(ScreenWidth/2, 100);
    promptM.text = prompt;
    promptM.font = [UIFont systemFontOfSize:15];
//    promptM.layer.borderWidth = 1;
//    promptM.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    promptM.layer.cornerRadius = 5;
    promptM.textAlignment = NSTextAlignmentCenter;
    promptM.textColor = [UIColor blackColor];
    [self.view addSubview:promptM];
//    [UIView animateWithDuration:3 animations:^{
//        promptM.alpha = 0;
//    } completion:^(BOOL finished) {
//        [promptM removeFromSuperview];
//    }];
    
}


@end
