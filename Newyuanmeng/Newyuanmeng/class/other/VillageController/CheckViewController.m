//
//  CheckViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "CheckViewController.h"
#import "VillageIcon.h"


@interface CheckViewController ()

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //设置字体
    [TBCityIconFont setFontName:@"iconfont"];
    //创建导航栏
    [self createNavigationView];
    
    //创建视图
    [self createContentView];
}

#pragma mark - 内容
- (void)createContentView{
    //背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    //信息
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-100, 100, 200, 200)];
    imageV.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_information,30, [UIColor lightGrayColor])];
//    imageV.backgroundColor = [UIColor greenColor];
    [bgView addSubview:imageV];
    
    //label
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-380)/2, imageV.frame.origin.y+imageV.frame.size.height, 380, 40)];
    promptLabel.text = @"您的专区申请正在审核中，请耐心等待";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:promptLabel];
    
    //返回首页
    UIButton *backHomeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 218, 40)];
    backHomeButton.center = CGPointMake(ScreenWidth/2,promptLabel.frame.origin.y+promptLabel.frame.size.height+100);
    backHomeButton.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
    [backHomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backHomeButton setTitle:@"返回首页" forState:UIControlStateNormal];
    backHomeButton.layer.cornerRadius = 8;
    [backHomeButton addTarget:self action:@selector(backHomeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backHomeButton];
    
}


#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    //    navView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 25, 25)];
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
    title.text = @"申请入驻";
    [navView addSubview:title];
    
    
}

#pragma mark - 按钮事件
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

//返回首页
- (void)backHomeBtnAction:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
