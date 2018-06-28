//
//  Withdrawals.m
//  huabi
//
//  Created by TeamMac2 on 17/4/6.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "Withdrawals.h"
#import "GoldWithdrawals.h"
#import "recordCell.h"
#import "BalanceCashViewController.h"
#import "CashBalanceRecordViewController.h"
#import "Newyuanmeng-Swift.h"
#import "UserBalance.h"

@interface Withdrawals ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *backBtn;
    UILabel *title;
}

@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *nowGoldLabel;
@property(nonatomic,strong)UIButton *recordBtn;//!<提现记录
@property(nonatomic,strong)UIButton *withdrawalsBtn;

@property(nonatomic,strong)UITableView *tableV;

@end

@implementation Withdrawals

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self createUI];
    [self refershInfo];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refershInfo) name:@"getBalance" object:nil];

}

-(void)refershInfo
{
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    //    NSLog(@"%@-----%@--------%@",keys,values,CommonConfig.Token);
    [MySDKHelper postAsyncWithURL:@"/v1/huabi" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSLog(@"余额信息请求成功%@",result);
        NSDictionary *balanceInfo = result[@"content"];
        UserBalance *userBalance = [UserBalance mj_objectWithKeyValues:balanceInfo];
//        NSString *str = [NSString stringWithFormat:@"%ld",(long)userBalance.order.todayamount];
//        NSLog(@"%@",str);
//
        self.priceLabel.text = userBalance.customer.balance;
//
//        self.remainingPoints.text = userBalance.customer.point_coin;
//        self.yuE.text = [NSString stringWithFormat:@"%ld",(long)userBalance.order.todayamount];
//        self.bance.text = userBalance.customer.balance;
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];
    [self getData];
}

-(void)getData
{

    //  获取提现记录
    NSArray *keys = [NSArray array];
    NSArray *values = [NSArray array];
    NSInteger currentPage = 1;
    NSString *url = @"/v1/get_my_balance_withdraw_record";
    keys = @[@"user_id",@"token",@"page"];
    values = @[@(self.userID),self.token,@(currentPage)];
    __weak typeof(self) weakSelf = self;
    [MySDKHelper postAsyncWithURL:url withParamBodyKey:keys withParamBodyValue:values needToken:self.token postSucceed:^(NSDictionary *result) {
        NSLog(@"解析数据成功,数据如下:");
        NSLog(@"%@",result);
        if ([result[@"content"] isEqual:[NSNull null]]) {
            NSLog(@"数据为空=====");
            return ;
        }else{
            [self createTableView];
            for (NSDictionary *dict in result[@"content"][@"data"]) {
                recordModel *model = [[recordModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.mutArr addObject:model];
            }
            
            [weakSelf.tableV reloadData];

        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"错误信息:%@",error);
    }];

}

-(void)createTableView
{
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.recordBtn.frame.origin.y + self.recordBtn.frame.size.height, ScreenWidth, ScreenHeight - self.recordBtn.frame.origin.y - self.recordBtn.frame.size.height - 59) style:UITableViewStylePlain];
    [self.tableV registerNib:[UINib nibWithNibName:@"recordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"recordCell"];
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.showsHorizontalScrollIndicator = NO;
//    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableV.bounces = YES;
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.rowHeight = UITableViewAutomaticDimension;
    self.tableV.estimatedRowHeight = 44;
    self.tableV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableV];
}

-(void)createUI
{
    title = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 - 40, 25, 80, 25)];
    [title setTintColor:[UIColor blackColor]];
    [title setText:@"余额提现"];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:title];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 25, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"ic_back-1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 - 40, ScreenHeight * 0.13, 80, 20)];
//    self.priceLabel.text = self.goldNumber;
    self.priceLabel.textColor = [UIColor grayColor];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.priceLabel];
    
    self.nowGoldLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 - 40, ScreenHeight * 0.18, 80, 20)];
    self.nowGoldLabel.text = @"当前余额";
    self.nowGoldLabel.textColor = [UIColor grayColor];
    self.nowGoldLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nowGoldLabel];
    
    self.withdrawalsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.withdrawalsBtn.frame = CGRectMake(15, ScreenHeight * 0.25, ScreenWidth * 0.9, ScreenHeight * 0.09);
    [self.withdrawalsBtn setTitle:@"我要提现" forState:UIControlStateNormal];
    self.withdrawalsBtn.titleLabel.font   = [UIFont systemFontOfSize: 15];
    [self.withdrawalsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.withdrawalsBtn.backgroundColor = [UIColor redColor];
    self.withdrawalsBtn.layer.masksToBounds = YES;
    self.withdrawalsBtn.layer.cornerRadius = 10;
    [self.withdrawalsBtn addTarget:self action:@selector(withdrawalsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.withdrawalsBtn];
    [self.withdrawalsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20*ScaleWidth);
        make.right.mas_equalTo(self.view).mas_offset(20*-(ScaleWidth));
        make.top.mas_equalTo(self.nowGoldLabel).mas_offset(ScreenHeight * 0.25 - ScreenHeight * 0.18);
        make.width.mas_equalTo(ScreenWidth * 0.9);
        make.height.mas_equalTo(ScreenHeight * 0.09);
    }];
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordBtn.frame = CGRectMake(10, self.withdrawalsBtn.frame.origin.y + self.withdrawalsBtn.frame.size.height + 10, 80, 25);
    [self.recordBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    self.recordBtn.titleLabel.font   = [UIFont systemFontOfSize: 15];
    [self.recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self.recordBtn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordBtn];
    
}


-(void)gotoBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)withdrawalsClick:(UIButton *)sender
{
    NSLog(@"我要提现");
//    GoldWithdrawals *VC = [[GoldWithdrawals alloc] init];
//    VC.userID = self.userID;
//    VC.token = self.token;
//    [self.navigationController pushViewController:VC animated:YES];
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    BalanceCashViewController *balance = [stroy instantiateViewControllerWithIdentifier:@"BalanceCashViewController"];
    balance.balanceMoney = self.goldNumber;
    balance.isBalanceCash = YES;
    balance.isBanlanceCard = YES;
    [self.navigationController pushViewController:balance animated:YES];
}

-(void)recordClick:(UIButton *)sender
{
    NSLog(@"查看提现记录");
    CashBalanceRecordViewController *cashBalance = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"CashBalanceRecordViewController"];
    cashBalance.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cashBalance animated:YES];
}

#pragma mark UITableViewDelegate
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
    recordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellModel = self.mutArr[indexPath.row];
    return cell;
}

-(NSMutableArray<recordModel *> *)mutArr
{
    if (_mutArr == nil) {
        _mutArr = [NSMutableArray array];
    }
    return _mutArr;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
