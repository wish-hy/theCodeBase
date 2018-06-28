//
//  VipController.m
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//  套餐专区

#import "VipController.h"
#import "VipGoodsModel.h"
#import "VipFirstCell.h"
#import "VipHeadView.h"
#import "VipSecondCell.h"
#import "MySDKHelper.h"
#import "NoticeView.h"
#import "Newyuanmeng-Swift.h"

@interface VipController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *vipCollectionView;
    NSMutableArray <VipGoodsModel *> *goodsArr;
    NSMutableArray <VipGoodsModel *> *goodsArr2;
}

@end

@implementation VipController

- (void)viewDidLoad {
    [super viewDidLoad];
    goodsArr = [[NSMutableArray alloc]init];
//    for (int i = 0; i < 6; i++) {
//        VipGoodsModel *model = [[VipGoodsModel alloc]init];
//        [goodsArr addObject:model];
//    }
    goodsArr2 = [[NSMutableArray alloc]init];
//    for (int i = 0; i < 6; i++) {
//        VipGoodsModel *model = [[VipGoodsModel alloc]init];
//        [goodsArr2 addObject:model];
//    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = color_white;
    [self getHuabiRecommend];
    [self getHuabiGoods];
    [self setCollection];
    [self initSetting];

    
}

-(void)getHuabiRecommend{
    [MySDKHelper postAsyncWithURL:@"/v1/huabipage_recommend" withParamBodyKey:@[] withParamBodyValue:@[] needToken:@"" postSucceed:^(NSDictionary *result) {
        NSLog(@"getHuabiRecommend %@",result);
        NSArray<NSDictionary *> *data = [result[@"content"] mutableArrayValueForKey:@"data"];
        for (int i = 0 ; i < data.count; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data[i]];
            VipGoodsModel *model = [[VipGoodsModel alloc]init];
            [model setDictionayInfo:dic];
            [goodsArr addObject:model];
        }
        [vipCollectionView reloadData];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];

}
-(void)getHuabiGoods{
    [MySDKHelper postAsyncWithURL:@"/v1/huabipage_goods" withParamBodyKey:@[@"page"] withParamBodyValue:@[@"1"] needToken:@"" postSucceed:^(NSDictionary *result) {
        NSLog(@"getHuabiGoods %@",result);

        if ([result[@"content"] isEqual:[NSNull null]]) {
                return ;
            }else{
                NSArray<NSDictionary *> *data = [result[@"content"] mutableArrayValueForKey:@"data"];
                for (int i = 0 ; i < data.count; i++) {
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data[i]];
                    VipGoodsModel *model = [[VipGoodsModel alloc]init];
                    [model setDictionayInfo:dic];
                    [goodsArr2 addObject:model];
                }
                [vipCollectionView reloadData];

            }
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
    
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

-(void)setCollection{
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //定义每个UICollectionView 的大小
    layout.itemSize = CGSizeMake(ScreenWidth, (204+26)*ScaleWidth);
    //定义每个UICollectionView 横向的间距
    layout.minimumLineSpacing = 0*ScaleWidth;
    //定义每个UICollectionView 纵向的间距
    layout.minimumInteritemSpacing = 0*ScaleWidth;
    
    vipCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) collectionViewLayout:layout];
    vipCollectionView.tag = 0;
    vipCollectionView.scrollEnabled = YES;
    vipCollectionView.bounces = YES;
    vipCollectionView.backgroundColor = [UIColor clearColor];
    vipCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    vipCollectionView.dataSource = self;
    vipCollectionView.delegate = self;
    vipCollectionView.showsVerticalScrollIndicator = NO;
    vipCollectionView.showsHorizontalScrollIndicator = NO;
    vipCollectionView.layer.masksToBounds = NO;
    [vipCollectionView registerClass:[VipFirstCell class] forCellWithReuseIdentifier:@"VipFirstCell"];
    [vipCollectionView registerClass:[VipSecondCell class] forCellWithReuseIdentifier:@"VipSecondCell"];
    [vipCollectionView registerClass:[VipHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VipHeadView"];
    [self.view addSubview:vipCollectionView];
//    [vipCollectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return goodsArr.count;
    }else{
        return goodsArr2.count;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  CGSizeMake(ScreenWidth, (204+26)*ScaleWidth);
    }else{
        return  CGSizeMake(ScreenWidth/2.0, 516*ScaleWidth);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        VipFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VipFirstCell" forIndexPath:indexPath];
        cell.tag = indexPath.row;
        if (goodsArr.count > indexPath.row) {
            [cell setImageWithTitle:goodsArr[indexPath.row].goodsName image:goodsArr[indexPath.row].goodsImg price1:goodsArr[indexPath.row].sell_price price2:goodsArr[indexPath.row].still_pay count:goodsArr[indexPath.row].goodsCount];
        }
        cell.iconClick = ^(NSInteger tag){
            [self toGoodsDetail:0 row:indexPath.row];
        };
        cell.buyClick = ^(NSInteger tag){
            [self toGoodsDetail:0 row:indexPath.row];
        };
        cell.backgroundColor = color_white;
        return cell;
    }else{
        VipSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VipSecondCell" forIndexPath:indexPath];
        cell.tag = indexPath.row;
        if (goodsArr2.count > indexPath.row) {
            [cell setImageWithTitle:goodsArr2[indexPath.row].goodsName image:goodsArr2[indexPath.row].goodsImg price:goodsArr2[indexPath.row].sell_price price1:goodsArr2[indexPath.row].market_price price2:goodsArr2[indexPath.row].still_pay];
        }
        cell.iconClick = ^(NSInteger tag){
            [self toGoodsDetail:1 row:indexPath.row];
        };
        cell.backgroundColor = color_white;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self toGoodsDetail:indexPath.section row:indexPath.row];

}

-(void)toGoodsDetail:(NSInteger)section row:(NSInteger)row
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"shopCart" bundle:nil];
    GoodsDetailViewController *controller = [story instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
    controller.isOC = YES;
    if (section == 0) {
        controller.goodsID = goodsArr[row].goodsID;
    }else{
        controller.goodsID = goodsArr2[row].goodsID;
    }
    [self.navigationController pushViewController:controller animated:true];
}
//协议中的方法，用来返回分组头的大小。如果不实现这个方法，- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath将不会被调用
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //宽度随便定，系统会自动取collectionView的宽度
    //高度为分组头的高度
    if (section == 0) {
        return  CGSizeMake(ScreenWidth, (22+22+28)*ScaleWidth);
    }else{
        return  CGSizeMake(ScreenWidth, (26+26+28)*ScaleWidth);
    }
    
}
//协议中的方法，用来返回CollectionView的分组头或者分组脚
//参数二：用来区分是分组头还是分组脚
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //重用分组头，因为前边注册过，所以重用一定会成功
    //参数一：用来区分是分组头还是分组脚
    //参数二：注册分组头时指定的ID
    //此处是headerView
    NSArray *titleArr = @[@"推荐兑换",@"超值兑换"];
    VipHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"VipHeadView" forIndexPath:indexPath];
    [header setImagesWithTitle:titleArr[indexPath.section] type:indexPath.section];
    return header;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return  NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
