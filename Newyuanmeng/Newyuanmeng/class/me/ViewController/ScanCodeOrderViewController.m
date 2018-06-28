//
//  ScanCodeOrderViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ScanCodeOrderViewController.h"
#import "ScanCodeOrderCell.h"
#import "Newyuanmeng-Swift.h"
#import "OrderScanModel.h"

@interface ScanCodeOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ScanOrderTable;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *home;

@property (nonatomic,strong)NSMutableArray *info;

@property (nonatomic, assign) NSInteger page;

/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@end

@implementation ScanCodeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ScanOrderTable.delegate = self;
    self.ScanOrderTable.dataSource = self;
    self.info = [NSMutableArray array];
    [self setRefresh];
}

//-(void)setInfo
//{
//    NSArray *keys = @[@"user_id",@"page",@"type"];
//    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@"1",_type];
//    //    NSLog(@"%@-----%@--------%@",keys,values,CommonConfig.Token);
//    [MySDKHelper postAsyncWithURL:@"/v1/offline_order" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
//        NSDictionary *balanceInfo = result[@"content"];
//        NSArray *arr = [balanceInfo objectForKey:@"data"];
//        NSMutableArray *orderModel = [OrderScanModel mj_objectArrayWithKeyValuesArray:arr];
//        self.info = orderModel;
//
//        [self.ScanOrderTable reloadData];
//    } postCancel:^(NSString *error) {
//        NSLog(@"%@",error);
//        [NoticeView showMessage:error];
//
//    }];
//}

- (void)setRefresh {
    //【下拉刷新】
    self.ScanOrderTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewFriendCircleDynamicData];
    }];
    
    //默认【上拉加载】
    self.ScanOrderTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreFriendCircleDynamicData];
    }];
    
    self.page = 1;
    self.ScanOrderTable.mj_footer.hidden = YES;
    // 一进来就开始刷新
    [self.ScanOrderTable.mj_header beginRefreshing];
    
}

// 加载最新 动态数据
- (void)loadNewFriendCircleDynamicData {
    
    if (self.isHeaderRefreshing) return;
    self.page = 1;
    self.headerRefreshing = YES;
    self.ScanOrderTable.mj_footer.hidden = YES;
    
    
    NSArray *keys = @[@"user_id",@"page",@"type"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page),_type];
    [self.ScanOrderTable.mj_footer resetNoMoreData];
    [MySDKHelper postAsyncWithURL:@"/v1/offline_order" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        if ([result[@"content"] isKindOfClass:[NSNull class]]) {
            self.ScanOrderTable.hidden = YES;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *orderModel = [OrderScanModel mj_objectArrayWithKeyValuesArray:arr];
            self.info = orderModel;
            
            [self.ScanOrderTable.mj_header endRefreshing];
            self.ScanOrderTable.mj_footer.hidden = NO;
            self.headerRefreshing = NO;
            
            [self.ScanOrderTable reloadData];
        }
        
       
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [self.ScanOrderTable.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [NoticeView showMessage:error];
        
    }];

    
}

// 加载更多动态 数据
- (void)loadMoreFriendCircleDynamicData {
    
    if (self.isFooterRefreshing) return;// 正在刷新 直接return
    self.ScanOrderTable.mj_footer.hidden = NO;
    self.page++; // page加1
    self.headerRefreshing = YES;
    
    NSLog(@"page = %ld",(long)self.page);
    NSArray *keys = @[@"user_id",@"page",@"type"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page),_type];
    //    NSLog(@"%@-----%@--------%@",keys,values,CommonConfig.Token);
    [MySDKHelper postAsyncWithURL:@"/v1/offline_order" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        if ([result[@"content"] isKindOfClass:[NSNull class]]) {
            self.headerRefreshing = NO;
            [self.ScanOrderTable.mj_footer endRefreshing];
            self.ScanOrderTable.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *orderModel = [OrderScanModel mj_objectArrayWithKeyValuesArray:arr];
            [self.info addObjectsFromArray:orderModel];
            
            [self.ScanOrderTable reloadData];
            [self.ScanOrderTable.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
            self.headerRefreshing = NO;
        }
        
//
//
//
//
//
//        [self.ScanOrderTable reloadData];
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];
    

//    [MySDKHelper postAsyncWithURL:@"/v1/index_goods" withParamBodyKey:keys withParamBodyValue:values needToken:@"" postSucceed:^(NSDictionary *result) {

//
//    } postCancel:^(NSString *error) {
//        NSLog(@"我是错误%@",error);
//        [self.tableView.mj_footer endRefreshing];
//
//        self.headerRefreshing = NO;
//    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.info.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderScanModel *model = self.info[indexPath.row];
    ScanCodeOrderCell *cell = [ScanCodeOrderCell creatCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.number.text = model.order_no;
    cell.payMan.text = model.shop_name;
    cell.payMethod.text = [NSString stringWithFormat:@"(%@)",model.payment_name];
    cell.money.text = [NSString stringWithFormat:@"￥%@",model.order_amount];
    
    if ([model.payment_name isEqualToString:@"支付宝支付"]) {
        cell.payImage.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e68f", 24, [UIColor colorWithHexString:@"fcc900"])];
    }
    else if ([model.payment_name isEqualToString:@"微信支付"]) {
        cell.payImage.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e642", 24, [UIColor colorWithHexString:@"b0d075"])];
    }
    self.ScanOrderTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (IBAction)backHome:(id)sender {
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
//    (UIApplication.shared.delegate as! AppDelegate).showMainPage()
}
- (IBAction)goBackHome:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
}

- (IBAction)backClick:(id)sender {
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
