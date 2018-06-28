//
//  SaleViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "SaleViewController.h"
#import "FirstSaleView.h"
#import "SaleRecordView.h"
#import "WithDrawMoneyView.h"

@interface SaleViewController ()
//标题
@property(nonatomic,weak)UILabel *titleStr;

@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
}

//加载标题
- (void)setViewIndexTitle:(NSInteger)index{
    
    if (index == 0) {
        //创建导航栏
        [self createNavigationView:@"销售记录"];
    }else if(index == 1){
        //创建导航栏
        [self createNavigationView:@"收益记录"];
    }else{
        //创建导航栏
        [self createNavigationView:@"提现记录"];
    }
}
//加载视图
- (void)setIndex:(NSInteger)index withUser_id:(NSInteger)user_id withToken:(NSString *)token withDistrict_id:(NSString *)district_id{
    
    _index = index;
    _user_id = user_id;
    _token = token;
    _district_id = district_id;

    if (index == 0) {
        FirstSaleView *firstView = [[FirstSaleView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight-80)];
        [firstView setUser_id:_user_id withToken:_token withDistrict_id:_district_id];
        [self.view addSubview:firstView];
    }else if(index == 1){
        SaleRecordView *srV = [[SaleRecordView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight-80)];
        [srV setUser_id:_user_id withToken:_token withDistrict_id:_district_id];
        [self.view addSubview:srV];
    }else{
        WithDrawMoneyView *withDMV = [[WithDrawMoneyView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight-80)];
        [withDMV setUser_id:_user_id withToken:_token withDistrict_id:_district_id];
        [self.view addSubview:withDMV];
    }
}

#pragma mark - 导航栏
- (void)createNavigationView:(NSString *)str{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
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
    title.text = str;
    [navView addSubview:title];
    
    
}
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
