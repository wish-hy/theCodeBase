//
//  VillageViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "VillageViewController.h"
#import "VillageIcon.h"

//跳转页面
#import "ApplyForViewController.h"
#import "ExampleVillageViewController.h"
#import "VillageIntroductionViewController.h"

@interface VillageViewController ()

//按钮标题
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,weak)UIView *bgView;

//视图控制器
@property(nonatomic,strong)NSArray *controllers;

@end

@implementation VillageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建导航栏
//    [self createNavigationView];
//    //设置字体
//    [TBCityIconFont setFontName:@"iconfont"];
//    //视图控制器
//    [self addControllers];
//    //内容
//    [self createContentView];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)next:(id)sender {
        //申请入驻
        ApplyForViewController *applyVC = [[ApplyForViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
}

//#pragma mark - 内容
//- (void)createContentView{
//
//    //背景
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
//    bgView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:bgView];
//    self.bgView = bgView;
//
//    //信息
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-50, 100, 100, 100)];
//    imageV.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_information,20, [UIColor lightGrayColor])];
//    [bgView addSubview:imageV];
//
//    //label
//    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-300)/2, imageV.frame.origin.y+imageV.frame.size.height, 300, 40)];
//    promptLabel.text = @"你暂时还没有入驻专区";
//    promptLabel.textAlignment = NSTextAlignmentCenter;
//    promptLabel.font = [UIFont systemFontOfSize:14];
//    [bgView addSubview:promptLabel];
//
//    //按钮
//    _titleArr = @[@"查看示例专区",@"申请入驻",@"什么是专区?"];
//    CGFloat height = 30;
//    CGFloat spaceWidth = 10;
//    CGFloat y = promptLabel.frame.origin.y+promptLabel.frame.size.height+10;
//    for (int i = 0; i < self.titleArr.count; i++) {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 90, y+i*spaceWidth+i*height, 180, height)];
////        btn.layer.cornerRadius = 10;
//        btn.tag = 1000 + i;
////        [btn setBackgroundColor:[UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1]];
//        [btn setBackgroundColor:[UIColor colorWithRed:245/255.0 green:112/255.0 blue:79/255.0 alpha:1]];
//        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == self.titleArr.count-1) {
//            [btn setBackgroundColor:[UIColor colorWithRed:245/255.0 green:112/255.0 blue:79/255.0 alpha:1]];
//        }
//        [bgView addSubview:btn];
//    }
//
//}
//
//#pragma mark - 添加视图控制器
//- (void)addControllers{
//
//    //查看示例专区
//    ExampleVillageViewController *exampleVVC = [[ExampleVillageViewController alloc] init];
//    //申请入驻
//    ApplyForViewController *applyVC = [[ApplyForViewController alloc] init];
//    //专区简介
//    VillageIntroductionViewController *introductionVC = [[VillageIntroductionViewController alloc] init];
//
//    _controllers = @[exampleVVC,applyVC,introductionVC];
//}
//
//#pragma mark - 导航栏
//- (void)createNavigationView{
//
//    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
////    navView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:navView];
//
//    //返回按钮
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 25, 25)];
////    [backBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e61e", 50, [UIColor redColor])] forState:UIControlStateNormal];
//    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size:30];
//    backBtn.titleLabel.font = iconfont;
//    [backBtn setTitle:@"\U0000e61e" forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:backBtn];
//
//    //标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    title.center = CGPointMake(ScreenWidth/2, 40);
//    title.textAlignment = NSTextAlignmentCenter;
//    title.text = @"专区";
//    [navView addSubview:title];
//
//}
//
//#pragma mark - 按钮事件
////导航栏按钮事件
//- (void)backBtnAction:(UIButton *)btn{
//
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
////底部三个按钮事件
//- (void)bottomBtnAction:(UIButton *)btn{
//
//    NSInteger index = btn.tag - 1000;
//    self.hidesBottomBarWhenPushed = YES;
//    if (index == 0) {
//        ExampleVillageViewController *exampleVVC = self.controllers[index];
//        exampleVVC.haveVillage = NO;
//    }
//    if (index == 1) {
//        ApplyForViewController *applyVC = self.controllers[index];
//        applyVC.user_id = _user_id;
//        applyVC.token = _token;
//        applyVC.isFromHomePage = YES;
//    }
//
//    if (index == 2) {
//        VillageIntroductionViewController *IntrVC = self.controllers[index];
//        IntrVC.user_id = _user_id;
//        IntrVC.token = _token;
//    }
//    [self.navigationController pushViewController:self.controllers[index] animated:YES];
//
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //时间颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
