//
//  IntegralOrderDetailController.m
//  huabi
//
//  Created by teammac3 on 2017/4/18.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "IntegralOrderDetailController.h"
#import "IntegralOrderDetailCell.h"
#import "UIImageView+webCache.h"

@interface IntegralOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *num;
@property(nonatomic,copy)NSString *price;

@end

@implementation IntegralOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //创建导航栏
    [self createNavigationView];
    
}

//加载数据
- (void)setGoodsName:(NSString *)name withGoodsImg:(NSString *)img withGoodsNum:(NSString *)num withPrice:(NSString *)price{
    _num = num;
    _name = name;
    _price = price;
    NSString *str = [NSString stringWithFormat:@"https://ymlypt.b0.upaiyun.com%@",img];
    _img = str;
    [self createListView];
}
#pragma mark - 创建表格列表
- (void) createListView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) style:UITableViewStylePlain
                           ];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.rowHeight = 120;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableV];
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (IntegralOrderDetailCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IntegralOrderDetailCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IntegralOrderDetailCell" owner:nil options:nil] firstObject];
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:_img] placeholderImage:nil];
        cell.goodsName.text = _name;
        cell.goodsNum.text = [NSString stringWithFormat:@"✖️%@",_num];
        cell.goodsPrice.text = _price;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
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
    title.text = @"订单详情";
    [navView addSubview:title];
    
    
}

//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
