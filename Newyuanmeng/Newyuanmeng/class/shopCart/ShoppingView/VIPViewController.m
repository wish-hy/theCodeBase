//
//  VIPViewController.m
//  huabi
//
//  Created by teammac3 on 2017/6/2.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "VIPViewController.h"
#import "UIImageView+WebCache.h"
#import "VillageIcon.h"
#import "MySDKHelper.h"
#import "NoticeView.h"
#import "Newyuanmeng-Swift.h"
#import "VIPCell.h"
#import "VIPModel.h"
#import "VIPView1.h"

@interface VIPViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)UITableView *tableV;
//套餐1
@property(nonatomic,strong)NSMutableArray *arr1;
//套餐2-4
@property(nonatomic,strong)NSMutableArray *arr2;
@property(nonatomic,strong)NSMutableDictionary *cellDic;

@property(nonatomic,assign)NSInteger cols;

@end

@implementation VIPViewController

- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSetting];

    //获取数据
    [self loadData];

}

#pragma mark - 加载数据
- (void)loadData{
    
    _arr1 = [NSMutableArray array];
    _arr2 = [NSMutableArray array];
    [MySDKHelper postAsyncWithURL:@"/v1/get_recharge_package_gift" withParamBodyKey:nil withParamBodyValue:nil needToken:[MyManager sharedMyManager].accessToken postSucceed:^(NSDictionary *result) {
        
//        NSLog(@"打印数据————————%@",result);
        //解析
        NSDictionary *content = result[@"content"];
        for (NSDictionary *dic in content[@"package1"]) {
            VIPModel *model = [[VIPModel alloc] initWithDictionary:dic error:nil];
            [_arr1 addObject:model];
            
        }
        for (NSDictionary *dic in content[@"package2_4"]) {
            VIPModel *model = [[VIPModel alloc] initWithDictionary:dic error:nil];
            [_arr2 addObject:model];
        }

        //创建视图
        [self createTableView];
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        //请求失败  创建空视图
        [self createTableView];
    }];
}

#pragma mark - 创建视图
- (void)createTableView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableV.rowHeight = 200;
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.scrollEnabled = NO;
    [self.view addSubview:tableV];
    self.tableV = tableV;
}

#pragma mark - 表格代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = YES;

    }
    if (indexPath.section == 0) {
        //创建集合视图1
        VIPView1 *view1 = [[VIPView1 alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        view1.userInteractionEnabled = YES;
        view1.cols = _arr1.count;
        view1.dataArr = _arr1;
        view1.block = ^(NSString *goodsID) {
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
            VIPGoodsDetailController *controller = [story instantiateViewControllerWithIdentifier:@"VIPGoodsDetailController"];
            controller.isOC = YES;
            controller.hidesBottomBarWhenPushed = YES;
            controller.goodsID = goodsID;
            [self.navigationController pushViewController:controller animated:true];
 
        };
        [cell.contentView addSubview:view1];
    }else if (indexPath.section == 1){
        //创建集合视图2
        [cell.contentView addSubview:[self createCollectionView:_arr2.count]];
    }


    return cell;
}
//组距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
//组头文字
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerV.backgroundColor = [UIColor colorWithRed:237/255.0 green:236/255.0 blue:242/255.0 alpha:1];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-15, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        titleL.text = @"600元套餐";
    }else{
        titleL.text = @"3600元套餐";
    }
    titleL.font = [UIFont systemFontOfSize:12];
    [headerV addSubview:titleL];
    
    return headerV;
}

#pragma mark - 创建集合视图
- (UICollectionView *)createCollectionView:(NSInteger)items{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((ScreenWidth-2*8)/3, 200);
    flowLayout.minimumLineSpacing = 10*ScaleWidth;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    

    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) collectionViewLayout:flowLayout];
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor whiteColor];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    _cols = items;
    //注册Item
    [collectionV registerClass:[VIPCell class] forCellWithReuseIdentifier:@"VIPCellID"];
    return collectionV;
}

#pragma mark - 集合视图的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _arr2.count;
}
- (VIPCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VIPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VIPCellID" forIndexPath:indexPath];

    VIPModel *model = _arr2[indexPath.item];
    NSString *str = [NSString stringWithFormat:@"%@%@",imgHost,model.img];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"moren"]];
    cell.title.text = model.name;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
    VIPGoodsDetailController *controller = [story instantiateViewControllerWithIdentifier:@"VIPGoodsDetailController"];
    controller.isOC = YES;
    controller.hidesBottomBarWhenPushed = YES;
    VIPModel *model = _arr2[indexPath.item];
//    NSLog(@"goodsID——————%@",model.vip_id);
    controller.goodsID = model.vip_id;
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark - 导航栏
- (void)initSetting{
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    backview.backgroundColor = color_white;
    [self.view addSubview:backview];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    title.textColor = color_title_main;
    title.text = @"套餐专区";
    title.font = MyFontSize(16);
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [back setImage:[UIImage imageNamed:@"ic_back-1"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton *main = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-44, 20, 44, 44)];
    [main setImage:[UIImage imageNamed:@"backbackmain"] forState:UIControlStateNormal];
    [main addTarget:self action:@selector(mainClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:main];
    main.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 16);
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 63, ScreenWidth, 1)];
    line.backgroundColor = color_Bottom_Line;
    [self.view addSubview:line];
}

-(void)backClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)mainClick:(UIButton *)sender{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
}

@end
