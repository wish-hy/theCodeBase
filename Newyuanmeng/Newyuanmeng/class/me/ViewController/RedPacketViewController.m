//
//  RedPacketViewController.m
//  huabi
//
//  Created by hy on 2018/1/9.
//  Copyright © 2018年 ltl. All rights reserved.
//   红包管理页面


#import "RedPacketViewController.h"
#import "Newyuanmeng-Swift.h"
#import "MyRedBag.h"
#import "MyRedBagViewCell.h"
#import "PaperRedViewController.h"

@interface RedPacketViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *redPacketMoney;
@property (weak, nonatomic) IBOutlet UILabel *redPacketCount;


@property (nonatomic,strong)NSMutableArray *info;



@property (nonatomic,strong)NSString *type;

@property (nonatomic, assign) NSInteger page;
/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@property (weak, nonatomic) IBOutlet UIButton *myReceive;
@property (weak, nonatomic) IBOutlet UIButton *mySend;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.type = @"2";
    _myReceive.selected = YES;
    self.tableView.hidden = YES;
    [self setRefresh];
}

// 我收到的红包
- (IBAction)myReceive:(id)sender {
    _myReceive.selected = YES;
    _mySend.selected = NO;
    self.type = @"2";
     [self setRefresh];
   
}
- (IBAction)mySend:(id)sender {
    _mySend.selected = YES;
    _myReceive.selected = NO;
    self.type = @"1";
    [self setRefresh];
}


- (void)setRefresh {
    //【下拉刷新】
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewFriendCircleDynamicData];
    }];
    
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreFriendCircleDynamicData];
    }];
    
    self.page = 1;
    self.tableView.mj_footer.hidden = YES;
    // 一进来就开始刷新
    [self.tableView.mj_header beginRefreshing];
    
}

// 加载最新 动态数据
- (void)loadNewFriendCircleDynamicData {
    
    if (self.isHeaderRefreshing) return;
    self.page = 1;
    self.headerRefreshing = YES;
    self.tableView.mj_footer.hidden = YES;
    
    [SVProgressHUD show];
    NSArray *keys = @[@"user_id",@"page",@"type"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page),_type];
    [self.tableView.mj_footer resetNoMoreData];
    [MySDKHelper postAsyncWithURL:@"/v1/my_redbag" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSDictionary *dic = result[@"content"][@"page"];
        NSString *total = dic[@"total"];
        NSString *total_money = result[@"content"][@"total_money"];
        self.redPacketMoney.text = [NSString stringWithFormat:@"￥%@",total_money];
        if ([_type isEqualToString:@"1"]) {
             self.redPacketCount.text = [NSString stringWithFormat:@"共发送红包%@个",total];
        }
        else if ([_type isEqualToString:@"2"])
        {
             self.redPacketCount.text = [NSString stringWithFormat:@"共收到红包%@个",total];
        }
       
        
        NSDictionary *balanceInfo = result[@"content"];
        NSArray *arr = [balanceInfo objectForKey:@"data"];
        NSMutableArray *cashRecond = [MyRedBag mj_objectArrayWithKeyValuesArray:arr];
        self.info = cashRecond;
        
        if (self.info.count == 0) {
            self.tableView.hidden = YES;
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else
        {
            self.tableView.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer.hidden = NO;
            self.headerRefreshing = NO;
            
            [self.tableView reloadData];
        }
        
        [SVProgressHUD dismiss];
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [SVProgressHUD dismiss];
        [NoticeView showMessage:error];
        
    }];
    
    
}

// 加载更多动态 数据
- (void)loadMoreFriendCircleDynamicData {
    
    if (self.isFooterRefreshing) return;// 正在刷新 直接return
    self.tableView.mj_footer.hidden = NO;
    self.page++; // page加1
    self.headerRefreshing = YES;
    [SVProgressHUD show];
    NSArray *keys = @[@"user_id",@"page",@"type"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page),_type];
    [MySDKHelper postAsyncWithURL:@"/v1/my_redbag" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSDictionary *dic = result[@"content"][@"page"];
        NSString *total = dic[@"total"];
        NSString *total_money = result[@"content"][@"total_money"];
        self.redPacketMoney.text = [NSString stringWithFormat:@"￥%@",total_money];
        if ([_type isEqualToString:@"1"]) {
            self.redPacketCount.text = [NSString stringWithFormat:@"共发送红包%@个",total];
        }
        else if ([_type isEqualToString:@"2"])
        {
            self.redPacketCount.text = [NSString stringWithFormat:@"共收到红包%@个",total];
        }
        
        NSDictionary *balanceInfo = result[@"content"];
        NSArray *arr = [balanceInfo objectForKey:@"data"];
        NSMutableArray *cashRecond = [MyRedBag mj_objectArrayWithKeyValuesArray:arr];
        [self.info addObjectsFromArray:cashRecond];
        
        if (self.info.count == 0) {
            self.tableView.hidden = YES;
            self.headerRefreshing = NO;
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else
        {
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
            self.headerRefreshing = NO;
        }
        [SVProgressHUD dismiss];
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [NoticeView showMessage:error];
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.info.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"info数据  %@",self.info);
    MyRedBagViewCell *cell = [MyRedBagViewCell creatCell:tableView];
    MyRedBag *Info = self.info[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([Info.avatar rangeOfString:@"http"].location != NSNotFound) {
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:Info.avatar] placeholderImage:[UIImage imageNamed:@"none"]];
    }
    else
    {
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,Info.avatar]] placeholderImage:[UIImage imageNamed:@"none"]];
    }
    
    if ([_type isEqualToString:@"1"]) {
        if ([Info.redbag_type isEqualToString:@"1"]) {
            cell.redBagType.text = @"商家红包";
        }
        else if ([Info.redbag_type isEqualToString:@"2"])
        {
            cell.redBagType.text = @"商家红包";
        }
        else if ([Info.redbag_type isEqualToString:@"3"])
        {
            cell.redBagType.text = @"宝箱红包";
        }
        cell.redBagFrom.text = Info.create_time;
        cell.redBagStatus.text = [NSString stringWithFormat:@"%@元",Info.total_money];
    }
    else
    {
        cell.redBagType.text = Info.real_name;
        cell.redBagFrom.text = Info.get_date;
        cell.redBagStatus.text = [NSString stringWithFormat:@"%@元",Info.get_money];
    }
    
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        NSLog(@"%@",self.info);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (IBAction)sendRedBag:(id)sender {
    PaperRedViewController *paperRed = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"PaperRedViewController"];
    paperRed.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:paperRed animated:YES];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//  隐藏导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
