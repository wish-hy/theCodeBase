//
//  OperatorViewController.m
//  huabi
//
//  Created by teammac3 on 2017/4/1.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "OperatorViewController.h"
#import "ExpendListModel.h"
#import "QRCodeView.h"
#import "VillageIcon.h"
#import "SubordinateModel.h"
#import "Newyuanmeng-Swift.h"
#import "SubordViewCell.h"

@interface OperatorViewController ()<UITableViewDelegate,UITableViewDataSource>

//modelArr
@property(nonatomic,strong)NSMutableArray *modelArr;
@property(nonatomic,weak)UITableView *tableV;

@property (nonatomic, assign) NSInteger page;

/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@end

@implementation OperatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    //创建导航栏
    [self createNavigationView];
    
    //创建视图
    [self createView];
    [self setRefresh];
}

- (void)setRefresh {
    //【下拉刷新】
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewFriendCircleDynamicData];
    }];
    
    //默认【上拉加载】
    self.tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreFriendCircleDynamicData];
    }];
    
    self.page = 1;
    self.tableV.mj_footer.hidden = YES;
    // 一进来就开始刷新
    [self.tableV.mj_header beginRefreshing];
    
}

// 加载最新 动态数据
- (void)loadNewFriendCircleDynamicData {
    
    if (self.isHeaderRefreshing) return;
    self.page = 1;
    self.headerRefreshing = YES;
    self.tableV.mj_footer.hidden = YES;
    
    
    NSArray *keys = @[@"user_id",@"page"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page)];
    [self.tableV.mj_footer resetNoMoreData];
    [MySDKHelper postAsyncWithURL:@"/v1/get_subordinate" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        if ([result[@"content"][@"data"] isKindOfClass:[NSNull class]]) {
            self.tableV.hidden = YES;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *model = [ExpendListModel mj_objectArrayWithKeyValuesArray:arr];
            self.modelArr = model;
            [self.tableV reloadData];
            [self.tableV.mj_header endRefreshing];
            self.tableV.mj_footer.hidden = NO;
            self.headerRefreshing = NO;
            
            
        }
        
        
    } postCancel:^(NSString *error) {
//        NSLog(@"%@",error);
        [self.tableV.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [NoticeView showMessage:error];
        
    }];
    
    
}

// 加载更多动态 数据
- (void)loadMoreFriendCircleDynamicData {
    
    if (self.isFooterRefreshing) return;// 正在刷新 直接return
    self.tableV.mj_footer.hidden = NO;
    self.page++; // page加1
    self.headerRefreshing = YES;
    
    NSArray *keys = @[@"user_id",@"page"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page)];
    [MySDKHelper postAsyncWithURL:@"/v1/get_subordinate" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        if ([result[@"content"][@"data"] isKindOfClass:[NSNull class]]) {
            self.headerRefreshing = NO;
            [self.tableV.mj_footer endRefreshing];
            self.tableV.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *model = [ExpendListModel mj_objectArrayWithKeyValuesArray:arr];
            [self.modelArr addObjectsFromArray:model];
            [self.tableV reloadData];
            [self.tableV.mj_footer endRefreshing];
            
            [SVProgressHUD dismiss];
            self.headerRefreshing = NO;
        }
        
    } postCancel:^(NSString *error) {
//        NSLog(@"%@",error);
        [self.tableV.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [NoticeView showMessage:error];
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubordViewCell *cell = [SubordViewCell creatCell:tableView];
    ExpendListModel *model = self.modelArr[indexPath.row];
    cell.name.text = model.nickname;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

////获取数据
//- (void)setUser_id:(NSInteger)user_id withToken:(NSString *)token withDistrict_id:(NSString *)district_id{
//
//    _user_id = user_id;
//    _token = token;
//    _district_id = district_id;
//    _modelArr = [NSMutableArray array];
//
//    NSArray *keys = [[NSArray alloc]init];
//    NSArray *values = [[NSArray alloc]init];
//    keys = @[@"user_id",@"page"];
//    values = @[@(_user_id),@"1"];
//    [MySDKHelper postAsyncWithURL:@"/v1/get_subordinate" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//        //解析
//        for (NSDictionary *dic in result[@"content"]) {
//            ExpendListModel *model = [[ExpendListModel alloc] initWithDictionary:dic error:nil];
//            [_modelArr addObject:model];
//        }
//        //扩展列表
////        [self expendListView];
//
//    } postCancel:^(NSString *error) {
//        NSLog(@"我是错误%@",error);
//    }];
//}

#pragma mark - 创建视图
- (void)createView{
    
//    UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 94, ScreenWidth-40, 40)];
//    inviteButton.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
//    [inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [inviteButton setTitle:@"我要邀请" forState:UIControlStateNormal];
//    inviteButton.layer.cornerRadius = 8;
//    [inviteButton addTarget:self action:@selector(inviteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:inviteButton];
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeight - 100) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
//    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableV];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableV = tableV;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, ScreenWidth, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"我的拓展专区";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}

//#pragma mark - 扩展列表
//- (void)expendListView{
//
//    CGFloat baseY = self.label.frame.origin.y+self.label.frame.size.height;
//    CGFloat height = 35;
//    CGFloat spaceHeight = 20;
//    for (int i = 0; i < _modelArr.count; i++) {
//
//        ExpendListModel *model = _modelArr[i];
//
//        UIButton *village = [[UIButton alloc] initWithFrame:CGRectMake(20, baseY+i*height+i*spaceHeight, ScreenWidth-40, height)];
//        village.backgroundColor = [UIColor whiteColor];
//        [village setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        village.layer.borderWidth = 1;
//        village.layer.borderColor = [UIColor greenColor].CGColor;
////        [village setTitle:model.name forState:UIControlStateNormal];
//        village.layer.cornerRadius = 8;
//        [self.view addSubview:village];
//
//
//    }
//}

//#pragma mark - 按钮事件
//- (void)inviteButtonAction:(UIButton *)btn{
//
//    //创建二维码
//    //拼接字符串
//    if (_qrcV == nil) {
//        NSString *str = [NSString stringWithFormat:@"%@%@",expendStr,_district_id];
//        CGFloat viewWidth = 230;
//        QRCodeView *qrcV = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, viewWidth,viewWidth) withLinkStr:str];
//        qrcV.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
//        [self.view addSubview:qrcV];
//        _qrcV = qrcV;
//    }
//}

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
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.center = CGPointMake(ScreenWidth/2, 40);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"经营商";
    [navView addSubview:title];
    
}
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

////触摸事件
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    [_qrcV removeFromSuperview];
//}

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
