//
//  GoldSpendingViewController.m
//  huabi
//
//  Created by TeamMac2 on 17/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "GoldSpendingViewController.h"
#import "GoldRecordCell.h"
#import "SilverRecordModel.h"
@interface GoldSpendingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)NSMutableArray<SilverRecordModel *> *mutArr;

@property (nonatomic, assign) NSInteger page;
/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;
@end

@implementation GoldSpendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self loadData];
    [self setRefresh];
}

- (void)setRefresh {
    //【下拉刷新】
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    //默认【上拉加载】
    self.tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData2];
    }];
    
    self.page = 1;
    self.tableV.mj_footer.hidden = YES;
    // 一进来就开始刷新
    [self.tableV.mj_header beginRefreshing];
    
}

-(void)loadData
{
    if (self.isHeaderRefreshing) return;
    self.page = 1;
    self.headerRefreshing = YES;
    self.tableV.mj_footer.hidden = YES;
    
    NSArray *keys = [NSArray array];
    NSArray *values = [NSArray array];
    
    NSString *type = [NSString new];
    NSString *url = @"/v1/balance_log";
    type = @"out";
    keys = @[@"user_id",@"token",@"page",@"type"];
    values = @[@(self.userID),self.token,@(self.page),type];
    [self.mutArr removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [MySDKHelper postAsyncWithURL:url withParamBodyKey:keys withParamBodyValue:values needToken:self.token postSucceed:^(NSDictionary *result) {
        NSLog(@"解析数据成功,数据如下:");
        NSLog(@"%@",result);
        NSMutableArray *arr = [NSMutableArray array];
        //容错处理
        if (![result[@"content"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dict in result[@"content"]) {
                SilverRecordModel *model = [[SilverRecordModel alloc] initWithDictionary:dict error:nil];
                [arr addObject:model];
            }
            weakSelf.mutArr = arr;
            [self.tableV.mj_header endRefreshing];
            self.tableV.mj_footer.hidden = NO;
            self.headerRefreshing = NO;
            [weakSelf.tableV reloadData];
        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"错误信息:%@",error);
    }];
    
    
}

-(void)loadData2
{
    if (self.isHeaderRefreshing) return;
    self.page++;
    self.headerRefreshing = YES;
    self.tableV.mj_footer.hidden = YES;
    
    NSArray *keys = [NSArray array];
    NSArray *values = [NSArray array];
    
    NSString *type = [NSString new];
    NSString *url = @"/v1/balance_log";
    type = @"out";
    keys = @[@"user_id",@"token",@"page",@"type"];
    values = @[@(self.userID),self.token,@(self.page),type];
    __weak typeof(self) weakSelf = self;
    [MySDKHelper postAsyncWithURL:url withParamBodyKey:keys withParamBodyValue:values needToken:self.token postSucceed:^(NSDictionary *result) {
        NSLog(@"解析数据成功,数据如下:");
        NSLog(@"%@",result);
        
        //容错处理
        if (![result[@"content"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dict in result[@"content"]) {
                SilverRecordModel *model = [[SilverRecordModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.mutArr addObject:model];
            }
            [self.tableV.mj_footer endRefreshing];
            self.headerRefreshing = NO;
            [weakSelf.tableV reloadData];
        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"错误信息:%@",error);
    }];
    
    
}

-(void)createUI
{
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 158) style:UITableViewStylePlain];
    [self.tableV registerNib:[UINib nibWithNibName:@"GoldRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GoldRecordCell"];
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.showsHorizontalScrollIndicator = NO;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableV.bounces = YES;
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.rowHeight = UITableViewAutomaticDimension;
    self.tableV.estimatedRowHeight = 44;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableV];
}

-(NSMutableArray<SilverRecordModel *> *)mutArr
{
    if (_mutArr == nil) {
        _mutArr = [NSMutableArray array];
    }
    return _mutArr;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.mutArr.count == 0) {
        return 0;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoldRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoldRecordCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellModel = self.mutArr[indexPath.row];
    return cell;
}

@end
