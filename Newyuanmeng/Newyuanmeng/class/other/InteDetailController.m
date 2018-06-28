//
//  InteDetailController.m
//  huabi
//
//  Created by teammac3 on 2017/6/6.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "InteDetailController.h"
#import "Newyuanmeng-Swift.h"
#import "InteDetailCell.h"
#import "InteDetailModel.h"
@interface InteDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *backBtn;
    UIButton *homeBtn;
    UILabel *title;
    
}
@property(nonatomic,strong)UISegmentedControl *segmentedControl;
@property(nonatomic,weak)UITableView *tableV;
@property(nonatomic,strong)NSMutableArray *modelArr;

@end

@implementation InteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
    
    [self creatUI];
}

//分段控制器
-(UISegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"获得",@"支出"]];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl setTintColor:[UIColor grayColor]];
        id selectedTexAttri = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13.0],NSForegroundColorAttributeName : [UIColor whiteColor]};
        id unseletedTexAttri = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13.0],NSForegroundColorAttributeName :[UIColor grayColor]};
        [_segmentedControl setTitleTextAttributes:selectedTexAttri forState:UIControlStateSelected];
        [_segmentedControl setTitleTextAttributes:unseletedTexAttri forState:UIControlStateNormal];
        [_segmentedControl addTarget:self action:@selector(segmentClick) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)segmentClick{
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
    
            //全部
            [self loadData:@"all"];
        
    }else if (self.segmentedControl.selectedSegmentIndex == 1){
            //获得
            [self loadData:@"in"];

    }else{
            //支出
            [self loadData:@"out"];
    }
    
}

#pragma mark - 界面图
-(void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.frame = CGRectMake(30, 64,ScreenWidth - 70, 30.0);
    [self.view addSubview:self.segmentedControl];
//    [self loadData:@"all"];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 - 40, 25, 80, 25)];
    title.font = [UIFont systemFontOfSize:15];
    [title setTintColor:[UIColor blackColor]];
    title.textAlignment = NSTextAlignmentCenter;
    [title setText:@"积分明细"];
    [self.view addSubview:title];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 25, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"ic_back-1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(ScreenWidth - 40, 25, 25, 25);
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"backbackmain"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
}
- (void)setToken:(NSString *)token{
    _token = token;
    [self loadData:@"all"];
}

#pragma mark - 加载数据
- (void)loadData:(NSString *)type{
    
    _modelArr = [NSMutableArray array];
    NSArray *keys = @[@"user_id",@"token",@"page",@"type"];
    NSArray *values = @[@(_user_id),_token,@"1",type];
    [MySDKHelper postAsyncWithURL:@"/v1/pointcoin_log" withParamBodyKey:keys withParamBodyValue:values needToken:[MyManager sharedMyManager].accessToken postSucceed:^(NSDictionary *result) {
        
        NSDictionary *content = result[@"content"];
        if (![content isEqual:[NSNull null]]) {
            
            //解析
            for (NSDictionary *dic in content[@"data"]) {
                
                InteDetailModel *model = [[InteDetailModel alloc] initWithDictionary:dic error:nil];
                [_modelArr addObject:model];
                
            }
            if (self.tableV != nil) {
                [self.tableV removeFromSuperview];
                [self createTableView];
            }else{
                [self createTableView];
            }
 
        }else{
            self.tableV.hidden = YES;
        }
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - 创建表格
- (void)createTableView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, ScreenWidth, ScreenHeight - 138) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.rowHeight = 80;
    tableV.separatorStyle = UITableViewCellStyleDefault;
    [self.view addSubview:tableV];
    //注册
    [tableV registerNib:[UINib nibWithNibName:@"InteDetailCell" bundle:nil] forCellReuseIdentifier:@"InteDetailCellID"];
    self.tableV = tableV;
}
#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}

- (InteDetailCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InteDetailCellID" forIndexPath:indexPath];
    InteDetailModel *model = _modelArr[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)gotoBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoHome:(UIButton *)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
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
