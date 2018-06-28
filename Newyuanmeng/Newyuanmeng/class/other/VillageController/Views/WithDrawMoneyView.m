//
//  WithDrawMoneyView.m
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "WithDrawMoneyView.h"
#import "WithDrawRecordModel.h"
#import "MJRefresh.h"

#import "CashViewCell.h"

@interface WithDrawMoneyView()<UITableViewDelegate,UITableViewDataSource>

//modelArr
@property(nonatomic,strong)NSMutableArray *modelArr;
//页码
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,weak)UITableView *tableV;

@end

@implementation WithDrawMoneyView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

//获取数据
- (void)setUser_id:(NSInteger)user_id withToken:(NSString *)token withDistrict_id:(NSString *)district_id{
    
    _user_id = user_id;
    _token = token;
    _district_id = district_id;
    _pageNum = 1;
    _modelArr = [[NSMutableArray alloc] init];
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"district_id",@"page"];
    NSString* page = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    values = @[@(_user_id),_token,_district_id,page];
    [MySDKHelper postAsyncWithURL:@"/v1/get_district_withdraw_record" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
        //        NSLog(@"我是数据%@",result);
        //解析
        //容错
        NSArray *arr = result[@"content"];
        if (arr.count) {
        for (NSDictionary *dic in result[@"content"][@"data"]) {
            WithDrawRecordModel *model = [[WithDrawRecordModel alloc] initWithDictionary:dic error:nil];
            [_modelArr addObject:model];
        }
        //创建视图
        [self createView];
    }
    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
        
    }];

}

#pragma mark - 刷新数据
- (void)loadNewData{
    
    NSMutableArray *dataArr = _modelArr;
    _modelArr = [[NSMutableArray alloc] init];
    _pageNum += 1;
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"district_id",@"page"];
    NSString* page = [NSString stringWithFormat:@"%ld",_pageNum];
    values = @[@(_user_id),_token,_district_id,page];
    __weak typeof (self)weakSelf = self;
    [MySDKHelper postAsyncWithURL:@"/v1/get_district_withdraw_record" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//                NSLog(@"我是数据%@",result);
        //解析
        NSArray *arr = result[@"content"];
        if (arr.count == 0) {
            _modelArr = dataArr;
            weakSelf.pageNum -= 1;
            //刷新视图
            [self.tableV reloadData];
            //结束
            [self.tableV.mj_footer endRefreshing];
            self.tableV.mj_footer.state = MJRefreshStateNoMoreData;
            [UIView animateWithDuration:2 animations:^{
                self.tableV.mj_footer.alpha = 0;
            }];  
        }else{
            for (NSDictionary *dic in result[@"content"][@"data"]) {
                WithDrawRecordModel *model = [[WithDrawRecordModel alloc] initWithDictionary:dic error:nil];
                [_modelArr addObject:model];
            }
            //刷新视图
            [self.tableV reloadData];
            //结束
            [self.tableV.mj_footer endRefreshing];
        }

    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
        
    }];
}

//加载旧数据
- (void)loadOldData{
    
    if (_pageNum <= 1) {
        _pageNum = 1;
    }else {
        _pageNum -= 1;
    }
    self.tableV.mj_footer.alpha = 1;
    self.tableV.mj_footer.state = MJRefreshStateIdle;
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"district_id",@"page"];
    NSString* page = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    values = @[@(_user_id),_token,_district_id,page];
    [MySDKHelper postAsyncWithURL:@"/v1/get_district_withdraw_record" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
        //        NSLog(@"我是数据%@",result);
        //解析
        _modelArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in result[@"content"][@"data"]) {
                WithDrawRecordModel *model = [[WithDrawRecordModel alloc] initWithDictionary:dic error:nil];
                [_modelArr addObject:model];
            }
        //刷新视图
        [self.tableV.mj_header endRefreshing];
        [self.tableV reloadData];
    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
        
    }];
}

#pragma mark - 创建视图
- (void)createView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableV.rowHeight = 80;
    tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadNewData];
    }];
    tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadOldData];
    } ];
    [self addSubview:tableV];
    self.tableV = tableV;
}

#pragma mark - UITableViewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"我是数据个数%ld",(unsigned long)_modelArr.count);
    return _modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithDrawRecordModel *model = _modelArr[indexPath.row];
    CashViewCell *cell = [CashViewCell creatCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.weekDay.text = model.weekday;
    cell.date.text = model.month;
    cell.money.text = model.amount;
    if ([model.status isEqualToString:@"0"]) {
        cell.status.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e648", 25, [UIColor colorWithHexString:@"#60B5DF"])];
        cell.moneyStatus.text = @"待处理";
        cell.moneyStatus.textColor = [UIColor colorWithHexString:@"#9CB753"];
    }
    else if ([model.status isEqualToString:@"1"]) {
        cell.status.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e64c", 25, [UIColor colorWithHexString:@"#75C51E"])];
        cell.moneyStatus.text = @"已转账";
        cell.moneyStatus.textColor = [UIColor colorWithHexString:@"939393"];
    }
    else if ([model.status isEqualToString:@"-1"]) {
        cell.status.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e634", 25, [UIColor colorWithHexString:@"#5CA312"])];
        cell.moneyStatus.text = @"未通过";
        cell.moneyStatus.textColor = [UIColor colorWithHexString:@"#E9504A"];
    }
    cell.moneyGo.text = model.settle_type;
    return cell;
}


//@property(nonatomic,copy)NSString *district_id;
//@property(nonatomic,copy)NSString *weekday;
//@property(nonatomic,copy)NSString *month;
//@property(nonatomic,copy)NSString *status_icon;
//@property(nonatomic,copy)NSString *amount;
//@property(nonatomic,copy)NSString *settle_type;
//@property(nonatomic,copy)NSString *status;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

@end
