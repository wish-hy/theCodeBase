//
//  IncomeRecordViewController.m
//  huabi
//
//  Created by teammac3 on 2017/6/2.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "IncomeRecordViewController.h"
#import "IncomeRecordModel.h"
#import "SaleRecordCell.h"

@interface IncomeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

//modelArr
@property(nonatomic,strong)NSMutableArray *modelArr;
//页码
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,weak)UITableView *tableV;

@end

@implementation IncomeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self createNavigationView];
    [self setInfo];
}

//#pragma mark - 加载数据
//- (void)setToken:(NSString *)token{
//
//    _token = token;
//    _modelArr = [NSMutableArray array];
//
//}

-(void)setInfo
{
    _pageNum = 1;
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token"];
    values = @[@(_user_id),_token];
    [MySDKHelper postAsyncWithURL:@"/v1/get_promoter_income_record" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
        
        NSArray *arr = result[@"content"][@"data"];
        NSMutableArray *model = [IncomeRecordModel mj_keyValuesArrayWithObjectArray:arr];
        _modelArr = model;
        NSLog(@"%@",model);
        //创建视图
        [self createView];
        
    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
        
    }];
}

#pragma mark - 创建视图
- (void)createView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, ScreenWidth, ScreenHeight-64)];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableV.rowHeight = 80;

    [self.view addSubview:tableV];
    self.tableV = tableV;
}

#pragma mark - UITableViewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaleRecordCell *cell  = [SaleRecordCell creatCell:tableView];
    NSDictionary *model = _modelArr[indexPath.row];
//    NSLog(@"%@",model);
//    NSLog(@"%@",);
//    NSLog(@"%@",model.frezze_income_change);
//    NSLog(@"%@",model.settled_income_change);
//    NSLog(@"%@",model.note);
//    NSLog(@"%@",model.status);
    [cell setTime:[model objectForKey:@"date"] AvailableIncome:[model objectForKey:@"valid_income_change"] UnlockedIncome:[model objectForKey:@"frezze_income_change"]  ExtractedIncome:[model objectForKey:@"settled_income_change"] Describe:[model objectForKey:@"note"] Status:[model objectForKey:@"status"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

#pragma mark - 导航栏
- (void)createNavigationView{
    
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
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    title.center = CGPointMake(ScreenWidth/2, 40);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"推广者收益记录";
    [navView addSubview:title];
    
    
}
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
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
