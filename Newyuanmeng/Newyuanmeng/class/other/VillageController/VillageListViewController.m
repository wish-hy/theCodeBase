//
//  VillageListViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/29.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "VillageListViewController.h"
#import "VillageIcon.h"
#import "DetailsView.h"
#import "MySDKHelper.h"
#import "VillageListModel.h"
#import "pend_districtModel.h"

//跳转页面
#import "VillagePayViewController.h"
#import "ApplyForViewController.h"
#import "VillageIntroductionViewController.h"
#import "ExampleVillageViewController.h"
#import "VillageViewController.h"

@interface VillageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *section1Content;
@property(nonatomic,strong)NSArray *sectionTitle;
@property(nonatomic,strong)NSArray *iconArr;
@property(nonatomic,strong)NSArray *bgColorArr;
//数据
@property(nonatomic,strong)NSMutableArray *section2Content;
@property(nonatomic,strong)NSMutableArray *districtArr;

@end

@implementation VillageListViewController

- (void)viewWillAppear:(BOOL)animated{
    
    //时间颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    //创建导航栏
    [self createNavigationView];
    
}

#pragma mark - 加载数据
- (void)setToken:(NSString *)token{
    
    _token = token;
//    NSLog(@"token=%@ id=%ld",token,_user_id);
    //加载数据
    [self loadData];
}
- (void)loadData{
    
    //初始化
    _section2Content = [NSMutableArray array];
    _districtArr = [NSMutableArray array];
    
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token"];
    values = @[@(_user_id),_token];
    [MySDKHelper postAsyncWithURL:@"/v1/get_district_list" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//        NSLog(@"我是数据%@",result);
        
        //解析
        for (NSDictionary *dic in result[@"content"][@"district"]) {
            VillageListModel *model = [[VillageListModel alloc] initWithDictionary:dic error:nil];
            [_section2Content addObject:model];
        }
//        NSLog(@"%@",result[@"content"][@"pending_district"]);
        for (NSDictionary *dic in result[@"content"][@"pending_district"]) {
            pend_districtModel *model = [[pend_districtModel alloc] initWithDictionary:dic error:nil];
//            NSLog(@"%@",model);
            [_districtArr addObject:model];
        }
        
        //创建视图
        [self createView];

    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);

    }];
}

#pragma mark - 创建视图
- (void)createView{
    
    _section1Content = @[@"查看示例专区",@"了解专区详情",@"申请专区入驻"];
    _sectionTitle = @[@"专区功能",@"选择专区"];
    _iconArr = @[icon_village_sale,icon_village_aboutUs,icon_village_add,icon_village_home1];
    _bgColorArr = @[@"#3cd0cd",@"#3cd0cd",@"#9cd0cd",@"#95a4ff"];
    //测试数据
//    _section2Content = @[@"水口花园",@"翻身专区"];
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableV.tableFooterView = [self createFootView];
    [self.view addSubview:tableV];
}

#pragma mark - UITableViewDelegate方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return _section2Content.count;
    }
    if (_section2Content.count) {
        return 2;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.layer.cornerRadius = 5;
        if (indexPath.section == 0) {
            if (_section2Content.count) {
                cell.textLabel.text = self.section1Content[indexPath.row+1];
                cell.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(_iconArr[indexPath.row+1], 25, [UIColor whiteColor])];
                cell.imageView.backgroundColor = [UIColor colorWithHexString:_bgColorArr[indexPath.row+1]];
            }else {
                cell.textLabel.text = self.section1Content[indexPath.row];
                cell.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(_iconArr[indexPath.row], 25, [UIColor whiteColor])];
                cell.imageView.backgroundColor = [UIColor colorWithHexString:_bgColorArr[indexPath.row]];
            }
        }else{
            VillageListModel *model = _section2Content[indexPath.row];
            cell.textLabel.text = model.name;
            cell.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(_iconArr[2], 25, [UIColor whiteColor])];
            cell.imageView.backgroundColor = [UIColor colorWithHexString:_bgColorArr[2]];
        }
    }
    return cell;
}

//组表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, headerView.frame.size.height)];
    titleLabel.text = self.sectionTitle[section];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:titleLabel];
    return headerView;
}
//组间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

//选择功能
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            if (_section2Content.count) {
                
                VillageIntroductionViewController *introductionVC = [[VillageIntroductionViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:introductionVC animated:YES];
            }else{
                
                VillageViewController *villageVC = [[VillageViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:villageVC animated:YES];
            }
        }else if(indexPath.row == 1){
            if (_section2Content.count) {
                ApplyForViewController *applyVC = [[ApplyForViewController alloc] init];
                applyVC.user_id = _user_id;
                applyVC.token = _token;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:applyVC animated:YES];
            }else{
                
                VillageIntroductionViewController *introductionVC = [[VillageIntroductionViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:introductionVC animated:YES];
            }

        }else {
            ApplyForViewController *applyVC = [[ApplyForViewController alloc] init];
            applyVC.user_id = _user_id;
            applyVC.token = _token;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];

        }
    }else{
        //传专区id
        ExampleVillageViewController *exampleVC = [[ExampleVillageViewController alloc] init];
        exampleVC.user_id = _user_id;
        exampleVC.token = _token;
        VillageListModel *model = _section2Content[indexPath.row];
        exampleVC.model = model;
        exampleVC.haveVillage = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:exampleVC animated:YES];
    }
}

#pragma mark - footView
- (UIView *)createFootView{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _districtArr.count*160+(_districtArr.count-1)*30+50)];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    titleLabel.text = @"待定专区";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [footView addSubview:titleLabel];
    
//    NSArray *testArr = @[@"上川专区",@"2017-03-13 17:37:39",@"深圳宝安",@"测试",@"未付款"];
    //循环添加专区详情视图
    for (int i = 0; i < _districtArr.count; i++) {
        
        DetailsView *detailV = [[DetailsView alloc] initWithFrame:CGRectMake(20, 30+i*190, ScreenWidth-40, 160)];
        detailV.model = _districtArr[i];
        detailV.btnTag = i + 1000;
        __weak typeof (self)weakSelf = self;
        detailV.block = ^(NSInteger index){
            
//            VillagePayViewController  *payVC = [[VillagePayViewController alloc] init];
//            self.hidesBottomBarWhenPushed = YES;
//            pend_districtModel *model = _districtArr[index-1000];
//            payVC.user_id = _user_id;
//            payVC.token = _token;
//            payVC.name = model.name;
//            payVC.district_id = model.district_id;
//            [weakSelf.navigationController pushViewController:payVC animated:YES];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请与客服联系！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:ok];
            [weakSelf presentViewController:alertC animated:YES completion:nil];
        };
        [footView addSubview:detailV];
    }
    
    return footView;

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
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.center = CGPointMake(ScreenWidth/2, 40);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"专区列表 ";
    [navView addSubview:title];
    
    
}

//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}





@end
