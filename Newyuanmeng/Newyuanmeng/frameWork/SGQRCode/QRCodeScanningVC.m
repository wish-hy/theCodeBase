//
//  QRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 JP_lee. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "ScanSuccessJumpVC.h"

@interface QRCodeScanningVC ()

@end

@implementation QRCodeScanningVC


//  修改状态栏颜色   使用新方法  修改方式将View controller-based status bar appearance设置为YES
//- (void)viewWillAppear:(BOOL)animated{
//
//    //时间颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isHidden == NO) {
        //创建导航栏
        [self createNavigationView];
    }
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
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
    [backBtn setTitle:@"\U0000e657" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.center = CGPointMake(ScreenWidth/2, 40);
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"二维码扫描";
    [navView addSubview:title];
    
}

#pragma mark - 按钮事件
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;

    ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
    jumpVC.token = _token;
    jumpVC.user_id = _user_id;
    jumpVC.jump_URL = string;
    [self.navigationController pushViewController:jumpVC animated:NO];
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    SGQRCodeLog(@"noti - - %@", noti);
    NSString *string = noti.object;
    
    if ([string hasPrefix:@"http"]) {
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.token = _token;
        jumpVC.user_id = _user_id;
        jumpVC.jump_URL = string;
        [self.navigationController pushViewController:jumpVC animated:NO];
        
    } else { // 扫描结果为条形码
        
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.token = _token;
        jumpVC.user_id = _user_id;
        jumpVC.jump_bar_code = string;
        [self.navigationController pushViewController:jumpVC animated:NO];
    }
}

- (void)dealloc {
    SGQRCodeLog(@"QRCodeScanningVC - dealloc");
    [SGQRCodeNotificationCenter removeObserver:self];
}

@end
