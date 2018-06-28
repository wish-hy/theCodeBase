//
//  SaleRecordView.m
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "SaleRecordView.h"
#import "SaleRecordCell.h"
#import "IncomeRecordModel.h"
#import "MJRefresh.h"

@interface SaleRecordView()<UITableViewDelegate,UITableViewDataSource>

//modelArr
@property(nonatomic,strong)NSMutableArray *modelArr;
//页码
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,weak)UITableView *tableV;

@end

@implementation SaleRecordView


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
    _modelArr = [NSMutableArray array];
    _pageNum = 1;
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"district_id",@"page"];
    values = @[@(_user_id),_token,_district_id,@(_pageNum)];
    [MySDKHelper postAsyncWithURL:@"/v1/get_district_income_record" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//        NSLog(@"我是数据%@",result);
        //解析
        //容错
//        NSArray *arr = result[@"content"];
//        if (arr.count) {
//        for (NSDictionary *dic in result[@"content"][@"data"]) {
//            IncomeRecordModel *model = [[IncomeRecordModel alloc] initWithDictionary:dic error:nil];
//            [_modelArr addObject:model];
//        }
//        //创建视图
//        [self createView];
//    }
    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
        
    }];
    
}

#pragma mark - 刷新数据
- (void)loadNewData{
    
//    NSMutableArray *dataArr = _modelArr;
    _modelArr = [[NSMutableArray alloc] init];
    _pageNum += 1;
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"district_id",@"page"];
    values = @[@(_user_id),_token,_district_id,@(_pageNum)];
    [MySDKHelper postAsyncWithURL:@"/v1/get_district_income_record" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
        //        NSLog(@"我是数据%@",result);
        //解析
//        NSArray *arr = result[@"content"];
//        if (arr.count == 0) {
//            _modelArr = dataArr;
//            _pageNum -= 1;
//            //刷新视图
//            [self.tableV reloadData];
//            //结束
//            [self.tableV.mj_footer endRefreshing];
//            self.tableV.mj_footer.state = MJRefreshStateNoMoreData;
//            [UIView animateWithDuration:2 animations:^{
//                self.tableV.mj_footer.alpha = 0;
//            }];
//        }else{
//            for (NSDictionary *dic in result[@"content"][@"data"]) {
//                IncomeRecordModel *model = [[IncomeRecordModel alloc] initWithDictionary:dic error:nil];
//                [_modelArr addObject:model];
//            }
//            //刷新视图
//            [self.tableV reloadData];
//            //结束
//            [self.tableV.mj_footer endRefreshing];
//
//        }
        
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
    values = @[@(_user_id),_token,_district_id,@(_pageNum)];
    [MySDKHelper postAsyncWithURL:@"/v1/get_district_income_record" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
        //        NSLog(@"我是数据%@",result);
        //解析
//        _modelArr = [[NSMutableArray alloc] init];
//        for (NSDictionary *dic in result[@"content"][@"data"]) {
//            IncomeRecordModel *model = [[IncomeRecordModel alloc] initWithDictionary:dic error:nil];
//            [_modelArr addObject:model];
//        }
//        //刷新视图
//        [self.tableV.mj_header endRefreshing];
//        [self.tableV reloadData];
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
    return _modelArr.count;
}

- (SaleRecordCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SaleRecordCell *cell  = [SaleRecordCell creatCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTime:@"" AvailableIncome:@"" UnlockedIncome:@""  ExtractedIncome:@"" Describe:@"" Status:@""];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

@end
