//
//  SystemMessageViewController.m
//  huabi
//
//  Created by hy on 2018/2/2.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "Newyuanmeng-Swift.h"
#import "MessageModel.h"

@interface SystemMessageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//modelArr
@property(nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic, assign) NSInteger page;

/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles.text = _titleStr;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [_tableView registerClass:[MessageViewCell class] forCellReuseIdentifier:@"MessageViewCell"];
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
    
    
    NSArray *keys = @[@"user_id",@"page",@"type",@"status"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page),@"system",@"all"];
    [self.tableView.mj_footer resetNoMoreData];
    [MySDKHelper postAsyncWithURL:@"/v1/get_message" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        if ([result[@"content"] isKindOfClass:[NSNull class]]) {
            self.tableView.hidden = YES;
        }
        else
        {
            NSArray *arr = result[@"content"];
            
            _modelArr = [MessageModel mj_objectArrayWithKeyValuesArray:arr];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer.hidden = NO;
            self.headerRefreshing = NO;
            NSLog(@"model == %@",_modelArr);
            
        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [NoticeView showMessage:error];
        
    }];
    
    
}

// 加载更多动态 数据
- (void)loadMoreFriendCircleDynamicData {
    
//    if (self.isFooterRefreshing) return;// 正在刷新 直接return
//    self.tableView.mj_footer.hidden = NO;
//    self.page++; // page加1
//    self.headerRefreshing = YES;
//
//    NSArray *keys = @[@"user_id",@"page"];
//    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@(self.page)];
//    [MySDKHelper postAsyncWithURL:@"/v1/get_my_invite_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
//
//        if ([result[@"content"][@"data"] isKindOfClass:[NSNull class]]) {
//            self.headerRefreshing = NO;
            [self.tableView.mj_footer endRefreshing];
//            self.tableV.mj_footer.state = MJRefreshStateNoMoreData;
//        }
//        else
//        {
//            NSDictionary *balanceInfo = result[@"content"];
//            NSArray *arr = [balanceInfo objectForKey:@"data"];
//            NSMutableArray *model = [MyInvitePModel mj_objectArrayWithKeyValuesArray:arr];
//            [self.modelArr addObjectsFromArray:model];
//            [self.tableV reloadData];
//            [self.tableV.mj_footer endRefreshing];
//
//            [SVProgressHUD dismiss];
//            self.headerRefreshing = NO;
//        }
//
//    } postCancel:^(NSString *error) {
//        NSLog(@"%@",error);
//        [self.tableV.mj_header endRefreshing];
//        self.headerRefreshing = NO;
//        [NoticeView showMessage:error];
//
//    }];
    
}

#pragma mark - UITableViewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = _modelArr[indexPath.row];
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageViewCell"];
    [cell setMessageInfo:model.title content:model.content times:model.time];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    MyInviteGenerCell *cell = [MyInviteGenerCell creatCell:tableView];
//    MyInvitePModel *model = _modelArr[indexPath.row];
//    NSString *imgurl = @"";
//    if ([model.avatar rangeOfString:@"http"].location != NSNotFound)
//    {
//        imgurl = model.avatar;
//    }
//    else
//    {
//        imgurl = [NSString stringWithFormat:@"%@%@",imgHost,model.avatar];
//    }
//    //            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil];
//    //            cell.textLabel.text = model.nickname;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"icon-60"]];
//    NSLog(@"%@",imgurl);
//    cell.name.text = model.nickname;
//    cell.catgroy.text = @"代理商";
//    }
    return cell;
}


//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGRect size = [CommonConfig getTextRectSize:self.modelArr[indexPath.row][@"content"] font:[UIFont systemFontOfSize:12] size:CGSizeMake(ScreenWidth - 40, 0)];
//    return 10 + 30 + 13 + 13 + 12 + 8 + size.size.height;
    return 30;
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
