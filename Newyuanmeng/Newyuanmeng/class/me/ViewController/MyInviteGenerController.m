//
//  MyInviteGenerController.m
//  huabi
//
//  Created by teammac3 on 2017/6/2.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "MyInviteGenerController.h"
#import "UIImageView+WebCache.h"
#import "MyInvitePModel.h"
#import "QRCodeView.h"
#import "VillageIcon.h"
#import "Newyuanmeng-Swift.h"
#import "MyInviteGenerCell.h"

@interface MyInviteGenerController ()<UITableViewDelegate,UITableViewDataSource>

//modelArr
@property(nonatomic,strong)NSMutableArray *modelArr;
@property(nonatomic,weak)UITableView *tableV;
//二维码视图
@property(nonatomic,weak)QRCodeView *qrcV;
@property (nonatomic, strong) UIButton *save;
@property (nonatomic,strong)UIView *views;

@property (nonatomic, assign) NSInteger page;

/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;


@end

@implementation MyInviteGenerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
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
    [MySDKHelper postAsyncWithURL:@"/v1/get_my_invite_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        
        if ([result[@"content"][@"data"] isKindOfClass:[NSNull class]]) {
            self.tableV.hidden = YES;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *model = [MyInvitePModel mj_objectArrayWithKeyValuesArray:arr];
            self.modelArr = model;
            [self.tableV reloadData];
            [self.tableV.mj_header endRefreshing];
            self.tableV.mj_footer.hidden = NO;
            self.headerRefreshing = NO;
//            NSLog(@"model == %@",_modelArr);
            
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
    [MySDKHelper postAsyncWithURL:@"/v1/get_my_invite_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {

        if ([result[@"content"][@"data"] isKindOfClass:[NSNull class]]) {
            self.headerRefreshing = NO;
            [self.tableV.mj_footer endRefreshing];
            self.tableV.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else
        {
            NSDictionary *balanceInfo = result[@"content"];
            NSArray *arr = [balanceInfo objectForKey:@"data"];
            NSMutableArray *model = [MyInvitePModel mj_objectArrayWithKeyValuesArray:arr];
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



#pragma mark - 创建视图
- (void)createView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, ScreenWidth, ScreenHeight - 74) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableV];
    self.tableV = tableV;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(0, 29, ScreenWidth, 1)];
    xian.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 25)];
    label.text = @"推广人员";
    
    //邀请按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-80, 3, 68, 24)];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#f4a788"].CGColor;
    btn.layer.cornerRadius = 3;
    [btn setTitle:@"我要邀请" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"89d12e"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(inviteAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:xian];
    [headerView addSubview:label];
    [headerView addSubview:btn];
    self.tableV.tableHeaderView = headerView;
    
    
}

#pragma mark - UITableViewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   MyInviteGenerCell *cell = [MyInviteGenerCell creatCell:tableView];
    MyInvitePModel *model = _modelArr[indexPath.row];
    NSString *imgurl = @"";
    if ([model.avatar rangeOfString:@"http"].location != NSNotFound)
    {
        imgurl = model.avatar;
    }
    else
    {
        imgurl = [NSString stringWithFormat:@"%@%@",imgHost,model.avatar];
    }
    //            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil];
    //            cell.textLabel.text = model.nickname;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"icon-60"]];
    NSLog(@"%@",imgurl);
    cell.name.text = model.nickname;
    if ([model.role_type isEqualToString:@"0"])
    {
        cell.catgroy.text = @"会员";
    }
    else if ([model.role_type isEqualToString:@"2"])
    {
        cell.catgroy.text = @"经销商";
    }
    else if ([model.role_type isEqualToString:@"1"])
    {
        cell.catgroy.text = @"代理商";
    }
    return cell;
}


//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        return 50;
//    }
    return 90;
}

#pragma mark - 按钮事件   // 邀请二维码
- (void)inviteAction:(UIButton *)btn{
    
    //创建二维码
    //拼接字符串http://www.ymlypt.com/index/invite/inviter_id/

    if (CommonConfig.isLogin) {
        NSString *str = [NSString stringWithFormat:@"%@/index/invite/inviter_id/%ld",mainUrl,(long)CommonConfig.UserInfoCache.userId];
        NSLog(@"打印————%@",str);
        CGFloat viewWidth = 280;
        CGFloat viewHeight = 400;
        QRCodeView *qrcV = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, viewWidth,viewHeight) withLinkStr:str];
        qrcV.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        views.backgroundColor = [UIColor grayColor];
        views.userInteractionEnabled = YES;
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAllView)];
        [views addGestureRecognizer:gest];
        views.alpha = 0.5;
        _views = views;
        qrcV.clipsToBounds = YES;
        [qrcV.layer setCornerRadius:10];
        
        UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
        [save setTitle:@"保存到相册" forState:UIControlStateNormal];
        [save setBackgroundColor:[UIColor colorWithHexString:@"#0D69F0"]];
        [save addTarget:self action:@selector(saveMainscreen) forControlEvents:UIControlEventTouchUpInside];
        [save.layer setCornerRadius:6];
        save.clipsToBounds = YES;
        save.frame = CGRectMake(qrcV.x + viewWidth/2 - 50, qrcV.y +viewHeight - 50, 100, 40);
        _save = save;
        [self.view addSubview:views];
        [self.view addSubview:qrcV];
        [self.view addSubview:save];
        _qrcV = qrcV;
    }else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVc.isGoods = true;
        [self.navigationController pushViewController:loginVc animated:YES];
        NSLog(@"请登录");
    }
}

- (void)saveMainscreen
{
    UIGraphicsBeginImageContextWithOptions(self.qrcV.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.qrcV.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [NoticeView showMessage:@"保存成功"];
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
    title.text = @"我的邀请";
    [navView addSubview:title];
    
}
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)removeAllView
{
    [_qrcV removeFromSuperview];
    [_views removeFromSuperview];
    [_save removeFromSuperview];
}
////触摸事件
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    [_qrcV removeFromSuperview];
//    [_views removeFromSuperview];
//    [_save removeFromSuperview];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
