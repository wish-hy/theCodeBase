//
//  NewMainViewController.m
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "NewMainViewController.h"
#import "GoodsGridCell.h"
#import "GridItem.h"
#import "SlideshowHeadView.h"
#import "NewGoodsViewCell.h"
#import "NewGoodsListViewCell.h"
#import "GoodsYouLikeCell.h"
#import "Newyuanmeng-Swift.h"

#import "IndexAreaModel.h"
#import "BannerModel.h"
#import "GridItem.h"
#import "FlashBuyModel.h"

#import "IndexCategoryModel.h"

#import "ThreeCategoryViewCell.h"
#import "FourCategoryViewCell.h"
#import "FiveCategoryViewCell.h"
#import "SixCategoryViewCell.h"
#import "LoadWebViewController.h"
#import "CollectionTitleView.h"

@interface NewMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* 10个属性 */
@property (strong , nonatomic)NSMutableArray<GridItem *> *gridItem;

@property (nonatomic, strong) NSArray *GoodsHomeSilderImagesArray;

@property (nonatomic, strong) NSArray *adsArr;

@property (nonatomic, strong) NSArray *flashBuyArr;

@property (nonatomic, strong) NSArray *pointBuyArr;

@property (nonatomic, assign) NSInteger categroyCount;

@property (nonatomic, strong) NSArray *categoryArr;
@property (weak, nonatomic) IBOutlet CoreVIew *searchText;

@property (nonatomic, strong) NSMutableArray *bannerModel;

@property (nonatomic, strong) UICollectionView *collectionView;

/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;

@end

@implementation NewMainViewController
- (IBAction)near:(id)sender {
    NearViewController *near = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"NearViewController"];
    near.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:near animated:YES];
}
- (IBAction)qrCode:(id)sender {
    if (CommonConfig.isLogin) {
       AVCaptureDevice *av = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        if (av != nil) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusRestricted || status ==AVAuthorizationStatusDenied){
                //无权限 做一个友好的提示
                UIAlertController *alerts = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alerts addAction:action];
                [self presentViewController:alerts animated:YES completion:nil];
            
            } else {
                QRCodeScanningVC *qrCode = [[QRCodeScanningVC alloc] init];
                qrCode.token = CommonConfig.Token;
                qrCode.user_id = CommonConfig.UserInfoCache.userId;
                qrCode.isHidden = NO;
                qrCode.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:qrCode animated:YES];
            }
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        LoginViewController *login = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        login.isGoods = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}

-(NSArray *)flashBuyArr
{
    if (!_flashBuyArr) {
        _flashBuyArr = [NSArray array];
    }
    return _flashBuyArr;
}

-(NSArray *)pointBuyArr
{
    if (!_pointBuyArr) {
        _pointBuyArr = [NSArray array];
    }
    return _pointBuyArr;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 49 - 64);
        _collectionView.showsVerticalScrollIndicator = NO;
        //  注册cell  两种注册方式
        // 功能格子
        [_collectionView registerClass:[GoodsGridCell class] forCellWithReuseIdentifier:@"GoodsGridCell"];
        
        // 新品专区
        [_collectionView registerNib:[UINib nibWithNibName:@"NewGoodsViewCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewGoodsViewCell"];
        // 专区列表
        [_collectionView registerClass:[NewGoodsListViewCell class] forCellWithReuseIdentifier:@"NewGoodsListViewCell"];
        // 推荐商品
        [_collectionView registerClass:[GoodsYouLikeCell class] forCellWithReuseIdentifier:@"GoodsYouLikeCell"];
        
        // 轮播
        [_collectionView registerClass:[SlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SlideshowHeadView"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"CollectionTitleView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionTitleView"];
        
        //  四种cell
        [_collectionView registerClass:[ThreeCategoryViewCell class] forCellWithReuseIdentifier:@"ThreeCategoryViewCell"];
        [_collectionView registerClass:[FourCategoryViewCell class] forCellWithReuseIdentifier:@"FourCategoryViewCell"];
        [_collectionView registerClass:[FiveCategoryViewCell class] forCellWithReuseIdentifier:@"FiveCategoryViewCell"];
        [_collectionView registerClass:[SixCategoryViewCell class] forCellWithReuseIdentifier:@"SixCategoryViewCell"];
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}

-(void)toSearch
{
    SearchViewController *search = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *search = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSearch)];
    [self.searchText addGestureRecognizer:search];
    [self setUpBase];
    [self getBanner];
    [self getData];
    
    self.categroyCount = 0;
    
    //【下拉刷新】
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.isHeaderRefreshing) return;
        self.headerRefreshing = YES;
        [self getData];
    }];
}

-(void)getBanner
{
    NSArray *keys = @[];
    NSArray *values = @[];
    
    [MySDKHelper postAsyncWithURL:@"/v1/get_index_ad" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        // banners
        NSArray *res = result[@"content"][@"banner"][@"content"];
        NSMutableArray *bannerArr = [NSMutableArray array];
        NSMutableArray *banner_model = [NSMutableArray array];
        for (int i = 0; i < res.count; i++) {
            BannerModel *bannerModel = [BannerModel mj_objectWithKeyValues:res[i]];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",imgHost,bannerModel.path];
            [bannerArr addObject:urlStr];
            [banner_model addObject:bannerModel];
            
        }
        self.bannerModel = banner_model;
        self.GoodsHomeSilderImagesArray = bannerArr;
        
        
        // ads
        NSArray *res1 = result[@"content"][@"ad"][@"imgs"];
        NSMutableArray *ads = [NSMutableArray array];
        for (int i = 0; i < res1.count; i++) {
            BannerModel *models = [BannerModel mj_objectWithKeyValues:res1[i]];
            [ads addObject:models];
        }
        self.adsArr = ads;
        
        [_collectionView reloadData];
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];
    
    [MySDKHelper postAsyncWithURL:@"/v1/category_nav" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSArray *res = result[@"content"];
        NSMutableArray *icon = [NSMutableArray array];
        for (int i = 0; i < res.count; i++) {
            GridItem *model = [GridItem mj_objectWithKeyValues:res[i]];
            [icon addObject:model];
        }
           _gridItem = [icon mutableCopy];

        [_collectionView reloadData];
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
        
    }];
}

-(void)getData{
    NSArray *keys = @[@"user_id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
    //  抢购   积分
    [MySDKHelper postAsyncWithURL:@"/v1/index_area" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSArray *res = result[@"content"][@"flash"][@"list"];
        NSMutableArray *flash = [NSMutableArray array];
        for (int i = 0; i < res.count; i++) {
            FlashBuyModel *model = [FlashBuyModel mj_objectWithKeyValues:res[i]];
            
            [flash addObject:model];
        }
        
        NSArray *res1 = result[@"content"][@"point"][@"list"];
        NSMutableArray *point = [NSMutableArray array];
        for (int i = 0; i < res1.count; i++) {
            FlashBuyModel *model1 = [FlashBuyModel mj_objectWithKeyValues:res1[i]];
            [point addObject:model1];
        }
        // 抢购
        self.flashBuyArr = flash;
        // 积分购买
        self.pointBuyArr = point;
         NSLog(@"0asdfasdfasdfasdf%lu   %lu",(unsigned long)self.flashBuyArr.count,(unsigned long)self.pointBuyArr.count);
        
        [_collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        self.headerRefreshing = NO;
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
    
    //  分类加载
    [MySDKHelper postAsyncWithURL:@"/v1/index_category" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSArray *res = result[@"content"];
        
        NSMutableArray *category = [NSMutableArray array];
        for (int i = 0; i < res.count; i++) {
            IndexCategoryModel *model = [IndexCategoryModel mj_objectWithKeyValues:res[i]];
            [category addObject:model];
        }
        self.categoryArr = category;
        self.categroyCount = category.count;
//        BannerModel
        [_collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        self.headerRefreshing = NO;
    } postCancel:^(NSString *error) {
        NSLog(@"%@",error);
        [NoticeView showMessage:error];
    }];
    
}

#pragma mark - collectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_categroyCount < 0) {
        return 3;
    }else{
     return 3 + _categroyCount;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _gridItem.count;
    }
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        GoodsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsGridCell" forIndexPath:indexPath];
        cell.gridItem = _gridItem[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        gridcell = cell;
    }else if (indexPath.section == 1){
        NewGoodsListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewGoodsListViewCell" forIndexPath:indexPath];
        cell.didSelect = ^(NSString *str, BOOL isPointBuy) {
            
            [self goodsClick:str isPointBuy:isPointBuy];
        };
        cell.isPointBuy = NO;   //  是否普通积分商品
        cell.countDownItem = self.flashBuyArr;
        [cell.collectionView reloadData];
        gridcell = cell;
    }else if (indexPath.section == 2){
        NewGoodsListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewGoodsListViewCell" forIndexPath:indexPath];
        cell.didSelect = ^(NSString *str, BOOL isPointBuy) {
            
            [self goodsClick:str isPointBuy:isPointBuy];
        };
        cell.isPointBuy = YES;
        cell.countDownItem = self.pointBuyArr;
        [cell.collectionView reloadData];
        gridcell = cell;
    }
    else   //  垃圾代码  不会简化
    {
        
        IndexCategoryModel *categoryModel = _categoryArr[indexPath.section - 3];
            if ([categoryModel.img_num intValue] == 3)  //  图片个数为3个
            {
                NSMutableArray *images = [NSMutableArray array];
                for (int i = 0; i < categoryModel.imgs.count; i++){
                    NSDictionary *imgN = categoryModel.imgs[i];
                    NSString *imgStr = [CommonConfig getImageUrl:imgN[@"path"]];
                    [images addObject:imgStr];
                }
                ThreeCategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThreeCategoryViewCell" forIndexPath:indexPath];
                if ([categoryModel.ad_position isEqualToString:@"0"]){
                    cell.status = 0;
                    [cell.ads1 sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.banner_img.path]]];
                }else{
                    cell.status = 1;
                    [cell.ads2 sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.banner_img.path]]];
                }

                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:images[0]]];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:images[1]]];
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:images[2]]];
                cell.index = ^(NSInteger index) {
                    [self goodsDetailWith:categoryModel index:index];
                };
                gridcell = cell;
            }
            else if ([categoryModel.img_num intValue] == 4){
                NSMutableArray *images = [NSMutableArray array];
                for (int i = 0; i < categoryModel.imgs.count; i++){
                    NSDictionary *imgN = categoryModel.imgs[i];
                    NSString *imgStr = [CommonConfig getImageUrl:imgN[@"path"]];
                    [images addObject:imgStr];
                }
                FourCategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FourCategoryViewCell" forIndexPath:indexPath];
                if ([categoryModel.ad_position isEqualToString:@"0"]){
                    cell.status = 0;
                    [cell.ads1 sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.banner_img.path]]];
                }else{
                    cell.status = 1;
                    [cell.ads2 sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.banner_img.path]]];
                }
                
                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:images[0]]];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:images[1]]];
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:images[2]]];
                [cell.image4 sd_setImageWithURL:[NSURL URLWithString:images[3]]];
                cell.index = ^(NSInteger index) {
                    [self goodsDetailWith:categoryModel index:index];
                };
                gridcell = cell;
            }
            else if ([categoryModel.img_num intValue] == 5){
                NSMutableArray *images = [NSMutableArray array];
                for (int i = 0; i < categoryModel.imgs.count; i++){
                    NSDictionary *imgN = categoryModel.imgs[i];
                    NSString *imgStr = [CommonConfig getImageUrl:imgN[@"path"]];
                    [images addObject:imgStr];
                }
                FiveCategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FiveCategoryViewCell" forIndexPath:indexPath];
                if ([categoryModel.ad_position isEqualToString:@"0"]){
                    cell.status = 0;
                    [cell.ads1 sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.banner_img.path]]];
                }else{
                    cell.status = 1;
                    [cell.ads2 sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.banner_img.path]]];
                }
                
                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:images[0]]];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:images[1]]];
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:images[2]]];
                [cell.image4 sd_setImageWithURL:[NSURL URLWithString:images[3]]];
                [cell.image5 sd_setImageWithURL:[NSURL URLWithString:images[4]]];
                cell.index = ^(NSInteger index) {
                    [self goodsDetailWith:categoryModel index:index];
                };
                gridcell = cell;
            }
            else if ([categoryModel.img_num intValue] == 6){
                NSMutableArray *images = [NSMutableArray array];
                for (int i = 0; i < categoryModel.imgs.count; i++){
                    NSDictionary *imgN = categoryModel.imgs[i];
                    NSString *imgStr = [CommonConfig getImageUrl:imgN[@"path"]];
                    [images addObject:imgStr];
                }
                SixCategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SixCategoryViewCell" forIndexPath:indexPath];
                if ([categoryModel.ad_position intValue] == 0){
                    cell.status = 0;
                    [cell.ads1 sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.banner_img.path]]];
                }else{
                    cell.status = 1;
                    [cell.ads2 sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.banner_img.path]]];
                }
                
                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:images[0]]];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:images[1]]];
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:images[2]]];
                [cell.image4 sd_setImageWithURL:[NSURL URLWithString:images[3]]];
                [cell.image5 sd_setImageWithURL:[NSURL URLWithString:images[4]]];
                [cell.image6 sd_setImageWithURL:[NSURL URLWithString:images[5]]];
                cell.index = ^(NSInteger index) {
                    [self goodsDetailWith:categoryModel index:index];
                };
                gridcell = cell;
            }
    }
    return gridcell;
}
//  根据分类跳转商品详情
-(void)goodsDetailWith:(IndexCategoryModel *)categoryModel index:(NSInteger)index
{
    SearchViewController *searchVc = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    GoodsDetailViewController *goods = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
    goods.isOC = YES;
    searchVc.isResult = YES;
    if (index == 0 || index == 1) {
        if ([categoryModel.banner_img.url.type isEqualToString:@"category"]) {
            searchVc.cid = categoryModel.banner_img.url.type_value;
            [self.navigationController pushViewController:searchVc animated:YES];
            
        }else if ([categoryModel.banner_img.url.type isEqualToString:@"goods"]){
            goods.goodsID = categoryModel.banner_img.url.type_value;
            [self.navigationController pushViewController:goods animated:YES];
            
        }else if ([categoryModel.banner_img.url.type isEqualToString:@"search"]){
            searchVc.searchKey = categoryModel.banner_img.url.type_value;
            [self.navigationController pushViewController:searchVc animated:YES];
        }
    }else{
        NSArray *imageAr = categoryModel.imgs;
        
        NSArray *imgModel = [BannerModel mj_objectArrayWithKeyValuesArray:imageAr];
        BannerModel *modelss = imgModel[index - 2];
        
        if ([modelss.url.type isEqualToString:@"category"]) {
            searchVc.cid = modelss.url.type_value;
            [self.navigationController pushViewController:searchVc animated:YES];
            
        }else if ([modelss.url.type isEqualToString:@"goods"]){
            goods.goodsID = modelss.url.type_value;
            [self.navigationController pushViewController:goods animated:YES];
            
        }else if ([modelss.url.type isEqualToString:@"search"]){
            searchVc.searchKey = modelss.url.type_value;
            [self.navigationController pushViewController:searchVc animated:YES];
        }
    }
    
}
//  根据banner跳转详情
-(void)bannerClickWith:(BannerModel *)modelss
{
    SearchViewController *searchVc = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    GoodsDetailViewController *goods = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
    goods.isOC = YES;
    searchVc.isResult = YES;
        if ([modelss.url.type isEqualToString:@"category"]) {
            searchVc.cid = modelss.url.type_value;
            [self.navigationController pushViewController:searchVc animated:YES];
            
        }else if ([modelss.url.type isEqualToString:@"goods"]){
            goods.goodsID = modelss.url.type_value;
            [self.navigationController pushViewController:goods animated:YES];
            
        }else if ([modelss.url.type isEqualToString:@"search"]){
            searchVc.searchKey = modelss.url.type_value;
            [self.navigationController pushViewController:searchVc animated:YES];
        }else if ([modelss.url.type isEqualToString:@"jump"]){
            LoadWebViewController *web = [[LoadWebViewController alloc] init];
            web.Url = modelss.url.type_value;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (indexPath.section == 0) {
        SlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SlideshowHeadView" forIndexPath:indexPath];
        headerView.imageGroupArray = self.GoodsHomeSilderImagesArray;
        headerView.banner = ^(NSInteger i) {
            BannerModel *banners = self.bannerModel[i];
            [self bannerClickWith:banners];
        };
        reusableview = headerView;
    }
    else if (indexPath.section == 1){
        BannerModel *model = self.adsArr[0];
        NewGoodsViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewGoodsViewCell" forIndexPath:indexPath];
        if ([[model.path substringToIndex:4] isEqualToString:@"http"]) {
            
            [cell.banner sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:@""]];
        }else{
            NSURL *urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,model.path]];
            [cell.banner sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@""]];
        }
        cell.selectBanner = ^{
            [self bannerClickWith:model];
        };
        cell.selectFount = ^{
            FlashViewController *flash = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"FlashViewController"];
            [self.navigationController pushViewController:flash animated:YES];
        };
        cell.label.text = @"抢购专区";
        cell.backgroundImage.image = [UIImage imageNamed:@"xinpintuijian"];
        cell.everyDayFound.image = [UIImage imageNamed:@"meirifaxian"];
        reusableview = cell;
    }else if (indexPath.section == 2){
        BannerModel *model = self.adsArr[1];
        NewGoodsViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewGoodsViewCell" forIndexPath:indexPath];
        if ([[model.path substringToIndex:4] isEqualToString:@"http"]) {
            [cell.banner sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:@""]];
        }else{
            NSURL *urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,model.path]];
            [cell.banner sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@""]];
        }
        cell.selectBanner = ^{
            [self bannerClickWith:model];
        };
        cell.selectFount = ^{
            IntegralListViewController *list = [[IntegralListViewController alloc] init];
            list.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:list animated:YES];
        };
        cell.label.text = @"积分专区";
        cell.backgroundImage.image = [UIImage imageNamed:@"jifenzhuanqu"];
        cell.everyDayFound.image = [UIImage imageNamed:@"gourenxin"];
        reusableview = cell;
    }
    else
    {
         IndexCategoryModel *categoryModel = _categoryArr[indexPath.section - 3];
        CollectionTitleView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionTitleView" forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:categoryModel.title_img]]];
        cell.see = ^{
            SearchViewController *searchVc = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
            searchVc.isResult = YES;
            searchVc.cid = categoryModel.id;
            [self.navigationController pushViewController:searchVc animated:YES];
        };
        [cell.seeMore setTitleColor:[UIColor colorWithHexString:categoryModel.font_color] forState:UIControlStateNormal];
        reusableview = cell;
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//9宫格组
        return CGSizeMake(ScreenWidth/5 , ScreenWidth/5 + 10);
    }
    else if (indexPath.section == 1) {//抢购
//        if (self.flashBuyArr.count > 0) {
//            NSLog(@"1asdfasdfasdfasdf%lu   %lu",(unsigned long)self.flashBuyArr.count,(unsigned long)self.pointBuyArr.count);
            return CGSizeMake(ScreenWidth, 160);
//        }
    }
//    else if (indexPath.section == 1 && self.flashBuyArr.count < 6) {//抢购
//        //        if (self.flashBuyArr.count > 0) {
//        //            NSLog(@"1asdfasdfasdfasdf%lu   %lu",(unsigned long)self.flashBuyArr.count,(unsigned long)self.pointBuyArr.count);
//        return CGSizeMake(ScreenWidth, 0);
//        //        }
//    }
    else if (indexPath.section == 2) {//积分
//        if (self.pointBuyArr.count == 0) {
//            NSLog(@"3asdfasdfasdfasdf%lu   %lu",(unsigned long)self.flashBuyArr.count,(unsigned long)self.pointBuyArr.count);
//            return CGSizeMake(ScreenWidth, 0);
//        }else{
//            NSLog(@"4asdfasdfasdfasdf%lu   %lu",(unsigned long)self.flashBuyArr.count,(unsigned long)self.pointBuyArr.count);
            return CGSizeMake(ScreenWidth, 160);
//        }
    }
    else{
        if (ScreenWidth < 321) {
            return CGSizeMake(ScreenWidth, 300);
        }
        return CGSizeMake(ScreenWidth, 350);
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            layoutAttributes.size = CGSizeMake(ScreenWidth, ScreenWidth * 0.38);
        }
            else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4){
            layoutAttributes.size = CGSizeMake(ScreenWidth * 0.5, ScreenWidth * 0.24);
        }
//                else{
//            layoutAttributes.size = CGSizeMake(ScreenWidth * 0.25, ScreenWidth * 0.35);
//        }
//    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 150); //图片滚动的宽高
    }
    if (section == 1 || section == 2) {
        return CGSizeMake(ScreenWidth, 120);
    }
    return CGSizeMake(ScreenWidth, 50);
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 10);  //网格视图下间距
    }
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SearchViewController *searchVc = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
        searchVc.isResult = YES;
        GridItem *model = self.gridItem[indexPath.row];
        if ([model.type isEqualToString:@"category"]) {
            searchVc.cid = model.id;
            [self.navigationController pushViewController:searchVc animated:YES];
        }else if ([model.type isEqualToString:@"mini_shop"]){
            WeiShangViewController *weiShang = [[WeiShangViewController alloc] init];
            [self.navigationController pushViewController:weiShang animated:YES];
        }else if ([model.type isEqualToString:@"nearby"]){
            NearViewController *near = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"NearViewController"];
            near.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:near animated:YES];
        }
    }else if (indexPath.section == 1){
        
    }
}

-(void)goodsClick:(NSString *)index isPointBuy:(BOOL)isPointBuy
{
    GoodsDetailViewController *goods = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
        NSInteger i = [index intValue];
    
    if (isPointBuy) {
        FlashBuyModel *model = self.pointBuyArr[i];
        goods.goodsID = model.id;
        goods.showQRcodeBtn = NO;
        goods.isIntegral = YES;
        goods.isFlash = NO;
        [self.navigationController pushViewController:goods animated:YES];
    }else{
        FlashBuyModel *model = self.flashBuyArr[i];
        goods.goodsID = model.id;
        goods.isFlash = YES;
        goods.isIntegral = NO;
        [self.navigationController pushViewController:goods animated:YES];
    }
    
    
}

#pragma mark - initialize
- (void)setUpBase
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
