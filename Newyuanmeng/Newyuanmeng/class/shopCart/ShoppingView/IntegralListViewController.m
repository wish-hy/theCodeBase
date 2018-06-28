//
//  IntegralListViewController.m
//  huabi
//
//  Created by teammac3 on 2017/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//
//  积分，优惠精选
#import "IntegralListViewController.h"
#import "IntegralListCell.h"
#import "IntegralListModel.h"
#import "MJRefresh.h"

@interface IntegralListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *modelArr;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) NSInteger totalPage;
@end

@implementation IntegralListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    self.totalPage = 1;
     _modelArr = [[NSMutableArray alloc] initWithCapacity:10];
    //创建导航栏
    [self createNavigationView];
    //创建视图
    [self createListView];
    //加载数据
    [self loadData:1];
}

#pragma mark - 加载列表数据
- (void)loadData:(NSInteger)page{
    NSNumber *pageNumber = [NSNumber numberWithInteger:page];
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"page"];
    values = @[pageNumber];
    [MySDKHelper postAsyncWithURL:@"/v1/point_sale" withParamBodyKey:keys withParamBodyValue:values needToken:[MyManager sharedMyManager].accessToken postSucceed:^(NSDictionary *result) {
        //        NSLog(@"我是数据%@",result);
        if ([result[@"message"] isEqualToString:@"成功"]) {
            self.totalPage = [result[@"content"][@"page"][@"totalPage"] integerValue];
            for (NSDictionary *dic in result[@"content"][@"data"]) {
                IntegralListModel *model = [[IntegralListModel alloc] initWithDictionary:dic error:nil];
//                if (![result[@"content"] isKindOfClass:[NSNull class]]) {
//                    [_modelArr addObject:model];
//                     [self.tableView reloadData];
//                }
                [_modelArr addObject:model];
                
            }
            //刷新视图
            [self.tableView reloadData];
        }
    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
    }];
}

#pragma mark - 创建表格列表
- (void) createListView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) style:UITableViewStylePlain
                           ];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.rowHeight = 120;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = tableV;
    [self.view addSubview:tableV];
    
    MJRefreshNormalHeader *refreshH = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    tableV.mj_header = refreshH;
    //添加刷新
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开进行刷新" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"松开进行刷新" forState:MJRefreshStatePulling];
    [footer setTitle:@"松开进行刷新" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    tableV.mj_footer = footer;
    
}

- (void)headerRefreshAction{
////    _modelArr = [NSMutableArray array];//清空原来的数据，重新加载
//    _modelArr = [[NSMutableArray alloc] initWithCapacity:10];
////    [self.tableView.mj_header endRefreshing];
//    [self loadData:1];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - 加载图文详情
- (void)footerRefreshAction{
    self.page += 1;
    if (self.page > self.totalPage) {
        return;
    }
    [self loadData:self.page];
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _modelArr.count;
}

- (IntegralListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IntegralListCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralListCell" owner:nil options:nil] firstObject];
    }
    cell.model = _modelArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IntegralListModel *model = _modelArr[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)model.list_id];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"integralBuy" object:nil userInfo:@{@"goods_id":str}];
}

#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 25, 25)];
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size:30];
    backBtn.titleLabel.font = iconfont;
    [backBtn setTitle:@"\U0000e61e" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //首页按钮按钮
    UIButton *homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-40, 30, 25, 25)];
    UIFont *iconfont2 = [UIFont fontWithName:@"iconfont" size:30];
    homeBtn.titleLabel.font = iconfont2;
    [homeBtn setTitle:@"\U0000e619" forState:UIControlStateNormal];
    [homeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:homeBtn];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    title.center = CGPointMake(ScreenWidth/2, 40);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"积分，优惠精选";
    [navView addSubview:title];
    
    
}

//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)homeBtnAction:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    self.tabBarController.tabBar.hidden = NO;
}

@end
