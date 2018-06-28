//
//  ApplyPayViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ApplyPayViewController.h"
#import "CheckViewController.h"

@interface ApplyPayViewController ()<UITableViewDelegate,UITableViewDataSource>

//标题
@property(nonatomic,strong)NSArray *titleArr;

@end

@implementation ApplyPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建导航栏
    [self createNavigationView];
    
}

#pragma mark - 创建列表
- (void)setName:(NSString *)name{
    
    _name = name;
    //创建列表
    _titleArr = @[@"专区名称",@"入驻金额"];
    [self createListView];
}
- (void)createListView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, self.titleArr.count*50) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableV.rowHeight = 50;
    [self.view addSubview:tableV];
    
    //立即支付
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 50)];
    nextStepButton.center = CGPointMake(ScreenWidth/2,tableV.frame.origin.y+tableV.frame.size.height+50);
    nextStepButton.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
    [nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepButton setTitle:@"立即支付" forState:UIControlStateNormal];
    nextStepButton.layer.cornerRadius = 8;
    [nextStepButton addTarget:self action:@selector(nextStepButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];
}

#pragma mark - UITableVIewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = _name;
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"10000元";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
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

//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//立即支付
- (void)nextStepButtonAction:(UIButton *)btn{
    
    CheckViewController *checkVC = [[CheckViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkVC animated:YES];
}

@end
