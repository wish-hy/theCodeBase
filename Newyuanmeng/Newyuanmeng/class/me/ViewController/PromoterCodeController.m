//
//  PromoterCodeController.m
//  huabi
//
//  Created by hy on 2018/1/22.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "PromoterCodeController.h"
#import "Newyuanmeng-Swift.h"
#import "PromoterCodeListMOdel.h"
#import "PromoterCodeCell.h"

@interface PromoterCodeController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *sumNumber;
@property (weak, nonatomic) IBOutlet UILabel *waitUse;
@property (weak, nonatomic) IBOutlet UILabel *useago;
@property (weak, nonatomic) IBOutlet UITableView *tableV;

@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, assign) NSInteger page;

/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@end

@implementation PromoterCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self setRefresh];
    self.tableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (IBAction)makeCode:(id)sender {
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    [MySDKHelper postAsyncWithURL:@"/v1/make_promoter_code" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSDictionary *dic = result[@"content"];
        PromoterCodeListMOdel *model = [PromoterCodeListMOdel mj_objectWithKeyValues:dic];
        NSLog(@"%@",model.code);
        [self.modelArr addObject:model];
        [self loadNewFriendCircleDynamicData];
        [NoticeView showMessage:@"激活码生成成功"];
        [self.tableV reloadData];
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];
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
    [MySDKHelper postAsyncWithURL:@"/v1/promoter_code_list" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        NSDictionary *dic = result[@"content"][@"count"];
        
        self.sumNumber.text = [NSString stringWithFormat:@"已生成数量:(%@/%@)",dic[@"made_num"],dic[@"max_num"]];
        self.waitUse.text = [NSString stringWithFormat:@"待使用:%@",dic[@"unused_num"]];
        self.useago.text = [NSString stringWithFormat:@"已过期:%@",dic[@"expired_num"]];
        
        if ([result[@"content"][@"list"][@"data"] isKindOfClass:[NSNull class]]) {
            self.tableV.hidden = YES;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"][@"list"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *model = [PromoterCodeListMOdel mj_objectArrayWithKeyValuesArray:arr];
            self.modelArr = model;
            [self.tableV reloadData];
            [self.tableV.mj_header endRefreshing];
            self.tableV.mj_footer.hidden = NO;
            self.headerRefreshing = NO;
            
        }
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
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
    [MySDKHelper postAsyncWithURL:@"/v1/promoter_code_list" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        NSDictionary *dic = result[@"content"][@"count"];
        
        self.sumNumber.text = [NSString stringWithFormat:@"已生成数量:(%@/%@)",dic[@"made_num"],dic[@"max_num"]];
        self.waitUse.text = [NSString stringWithFormat:@"待使用:%@",dic[@"unused_num"]];
        self.useago.text = [NSString stringWithFormat:@"已过期:%@",dic[@"expired_num"]];
        
        if ([result[@"content"][@"list"][@"data"] isKindOfClass:[NSNull class]]) {
            self.headerRefreshing = NO;
            [self.tableV.mj_footer endRefreshing];
            self.tableV.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"][@"list"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *model = [PromoterCodeListMOdel mj_objectArrayWithKeyValuesArray:arr];
            [self.modelArr addObjectsFromArray:model];
            [self.tableV reloadData];
            [self.tableV.mj_footer endRefreshing];
            
            [SVProgressHUD dismiss];
            self.headerRefreshing = NO;
        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [self.tableV.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [NoticeView showMessage:error];
        
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modelArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*ScaleHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

////组间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//    return view;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//    return view;
//}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromoterCodeListMOdel *model = _modelArr[indexPath.section];
    PromoterCodeCell *cell = [PromoterCodeCell creatCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.Code.text = model.code;
    cell.status.text = [NSString stringWithFormat:@"有效期:%@至:%@",model.start_date,model.end_date];
    if ([model.status isEqualToString:@"1"]) {
        cell.codeStatus.textColor = [UIColor colorWithHexString:@"#CE4731"];
        cell.codeStatus.text = @"待激活";
        cell.label.hidden = NO;
    }
    else if ([model.status isEqualToString:@"0"])
    {
        cell.codeStatus.text = @"已使用";
        cell.codeStatus.textColor = [UIColor colorWithHexString:@"#dddddd"];
        cell.label.hidden = YES;
        
    }
    else if ([model.status isEqualToString:@"-1"])
    {
        cell.codeStatus.text = @"已过期";
        cell.codeStatus.textColor = [UIColor colorWithHexString:@"#dddddd"];
        cell.label.hidden = YES;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromoterCodeListMOdel *model = _modelArr[indexPath.section];
    if (![model.status isEqualToString:@"1"]) {
        [NoticeView showMessage:@"该激活码已激活或已过期"];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.code;
    [NoticeView showMessage:@"复制成功"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
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
