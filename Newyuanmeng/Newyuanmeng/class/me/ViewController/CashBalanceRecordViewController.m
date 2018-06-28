//
//  CashBalanceRecordViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "CashBalanceRecordViewController.h"
#import "RecodCell.h"
#import "Newyuanmeng-Swift.h"
#import "CashRecodModel.h"

@interface CashBalanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *cashTableView;

@property (nonatomic,strong)NSMutableArray *info;
@property (nonatomic, assign) NSInteger page;

/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@property (nonatomic,strong)NSString *type;

@end

@implementation CashBalanceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cashTableView.delegate = self;
    self.cashTableView.dataSource = self;
    self.type = @"1";
    [self setRefresh];
}

- (void)setRefresh {
    //【下拉刷新】
    self.cashTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewFriendCircleDynamicData];
    }];
    
    //默认【上拉加载】
    self.cashTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreFriendCircleDynamicData];
    }];
    
    self.page = 1;
    self.cashTableView.mj_footer.hidden = YES;
    // 一进来就开始刷新
    [self.cashTableView.mj_header beginRefreshing];
    
}

// 加载最新 动态数据
- (void)loadNewFriendCircleDynamicData {
    
    if (self.isHeaderRefreshing) return;
    self.page = 1;
    self.headerRefreshing = YES;
    self.cashTableView.mj_footer.hidden = YES;
    
    
    NSArray *keys = @[@"user_id",@"page",@"type"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page),_type];
    [self.cashTableView.mj_footer resetNoMoreData];
    [MySDKHelper postAsyncWithURL:@"/v1/get_my_balance_withdraw_record" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        if ([result[@"content"] isKindOfClass:[NSNull class]]) {
            self.cashTableView.hidden = YES;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *cashRecond = [CashRecodModel mj_objectArrayWithKeyValuesArray:arr];
            self.info = cashRecond;

            [self.cashTableView.mj_header endRefreshing];
            self.cashTableView.mj_footer.hidden = NO;
            self.headerRefreshing = NO;

            [self.cashTableView reloadData];
        }
        
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [self.cashTableView.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [NoticeView showMessage:error];
        
    }];
    
    
}

// 加载更多动态 数据
- (void)loadMoreFriendCircleDynamicData {
    
    if (self.isFooterRefreshing) return;// 正在刷新 直接return
    self.cashTableView.mj_footer.hidden = NO;
    self.page++; // page加1
    self.headerRefreshing = YES;
    
    NSArray *keys = @[@"user_id",@"page",@"type"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page),_type];
    [MySDKHelper postAsyncWithURL:@"/v1/get_my_balance_withdraw_record" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        if ([result[@"content"] isKindOfClass:[NSNull class]]) {
            self.headerRefreshing = NO;
            [self.cashTableView.mj_footer endRefreshing];
            self.cashTableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *cashRecond = [CashRecodModel mj_objectArrayWithKeyValuesArray:arr];
            [self.info addObjectsFromArray:cashRecond];
            
            [self.cashTableView reloadData];
            [self.cashTableView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
            self.headerRefreshing = NO;
        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.info.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CashRecodModel *Info = self.info[indexPath.row];
    
    RecodCell *cell = [RecodCell creatCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([Info.open_name isEqualToString:@"" ]|| [Info.open_name isKindOfClass:[NSNull class]])
    {
        cell.event.text = @"提现到可用余额";
    }
    else
    {
        cell.event.text = [NSString stringWithFormat:@"提现到 %@",Info.open_bank];
    }
    
    cell.date.text = Info.apply_date;
    cell.money.text = [NSString stringWithFormat:@"- %@",Info.amount];
    self.cashTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
