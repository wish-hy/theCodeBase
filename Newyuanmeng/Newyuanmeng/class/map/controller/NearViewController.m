//
//  NearViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/12.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "NearViewController.h"
#import "PopDropdownMenuView.h"
#import "TitleDropMenuView.h"
#import "MapViewController.h"
#import "NearShopModel.h"
#import "GetByCityModel.h"
#import "ShopInfoViewCell.h"
//#import "Newyuanmeng-Swift.h"
#import "ShopForDetailsViewController.h"
#import "SwitchAddressViewController.h"

#define iphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NAV_SaferHeight   iphoneX ? 86 : 64


@interface NearViewController ()<PopDropdownMenuViewDelegate,TitleDropMenuViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mapClick;
@property (weak, nonatomic) IBOutlet UIButton *localizeImage;
@property (weak, nonatomic) IBOutlet UIButton *localizeButton;
@property (weak, nonatomic) IBOutlet UIImageView *localizeImage2;
@property (weak, nonatomic) IBOutlet UITextField *search;
@property (weak, nonatomic) IBOutlet UIImageView *searchImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, strong) PopDropdownMenuView *dropDownView;
@property (nonatomic, strong) TitleDropMenuView *titleView;
@property (nonatomic, assign) NSInteger currentTag;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *getByCityModelArr;
@property (nonatomic, strong) NSMutableArray *shopCategoryArr;
@property (nonatomic, strong) NSMutableArray *shopCategoryIDArr;
@property (nonatomic, assign) NSInteger buttonSelectIndex;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger temuSelectIndex;
//@property (nonatomic, strong) NSMutableArray *subArr;

@property (nonatomic, assign) NSInteger page;
/** 是否正在加载--最新--数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 是否正在加载--更多--数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@end

@implementation NearViewController

- (void)loadView {
    [super loadView];
//    [self customAccessors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _adressValue = @"";
    self.search.delegate = self;
    self.search.returnKeyType = UIReturnKeySearch;
    self.modelArr = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.page = 1;
    [self getLocation];
    _selectIndex = 0;
    _buttonSelectIndex = 0;
    _temuSelectIndex = 0;
    _localizeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self customAccessors];
    [self.tableView registerClass:[ShopInfoViewCell class] forCellReuseIdentifier:@"ShopInfoViewCell"];
    [self initWithView];
    [self loadShopCategory];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    if (!_adressValue) {
        [self getLocation];
    }
    else
    {
        [_localizeButton setTitle:_adressValue forState:UIControlStateNormal];
//        [self loadData:0 withValue:@[self.lon,self.lat,@"1"]];
    }
    
    [self setRefresh];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.search resignFirstResponder];
    [self loadDataByCity:_search.text];
    NSLog(@"%@",_search.text);
    [self loadData:4 withValue:@[self.longitude,self.latitude,_search.text,@"1"]];
    return YES;
}

//-(void)textValueChange
//{
//    [self.search resignFirstResponder];
//    [self loadDataByCity:_search.text];
//}

- (void)setRefresh {
    if (self.longitude == nil || [self.longitude isEqualToString:@""] || self.latitude == nil || [self.latitude isEqualToString:@""]) {
        return ;
    }
    //【下拉刷新】
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData:0 withValue:@[self.longitude,self.latitude,@"1"]];
    }];
    
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++; // page加1
        [self loadMoreData:0 withValue:@[self.longitude,self.latitude,@(self.page)]];
        
    }];
    
    
    self.tableView.mj_footer.hidden = YES;
    // 一进来就开始刷新
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    // 强制隐藏tabbar
//    NSArray *views = seasslf.tabBarController.view.subviews;
//    UIView *contentView = [views objectAtIndex:0];
//    contentView.height += 49;
//    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self removePopMenuView];
}

-(void)initWithView
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.localizeImage setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e683", 18, [UIColor colorWithHexString:@"333333"])] forState:UIControlStateNormal];
    
    self.searchImage.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e689", 20, [UIColor colorWithHexString:@"a8a8a8"])];
    [self.mapClick setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e696", 30, [UIColor colorWithHexString:@"ed561f"])] forState:UIControlStateNormal];
}

#pragma mark -- 获取地址
- (void)getLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self.locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"⚠️ 提示" message:@"开启定位:设置 > 隐私 > 定位服务 > 圆梦商城" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:alertA];
            [self presentViewController:controller animated:YES completion:nil];
            
        }else{
            if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
            {
                [_locationManager requestAlwaysAuthorization];
                [_locationManager requestWhenInUseAuthorization];
            }
            
            [self.locationManager startUpdatingLocation];
        }
        
    }else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"⚠️ 提示" message:@"开启定位:设置 > 隐私 > 定位服务" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [controller addAction:alertA];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    // 停止位置更新
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
//    CLLocationDegrees latitude = location.coordinate.latitude;
//    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"纬度:%f",location.coordinate.latitude);
    NSLog(@"经度:%f",location.coordinate.longitude);
    self.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
//    //获取附近商家的信息
//    [self loadData:0 withValue:@[self.longitude,self.latitude,@"1"]];
    
    [manager stopUpdatingLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = [placemarks lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_localizeButton setTitle:place.thoroughfare forState:UIControlStateNormal];
        });
        
        //获取城市的相关信息
        [self loadDataByCity:place.locality];
        
//        for (CLPlacemark * place in placemarks) {
//            //            NSDictionary * location = [place addressDictionary];
//            //            NSLog(@"国家：%@",[location objectForKey:@"Country"]);
//            //            NSLog(@"城市：%@",[location objectForKey:@"State"]);
//            //            NSLog(@"区：%@",[location objectForKey:@"SubLocality"]);
//
//            NSLog(@"位置：%@",place.name);
//            //            NSLog(@"国家：%@",place.country);
//            //            NSLog(@"城市：%@",place.locality);
//            //            NSLog(@"区：%@",place.subLocality);
//            //            NSLog(@"街道：%@",place.thoroughfare);
//            //            NSLog(@"子街道：%@",place.subThoroughfare);
//        }
    }];
}



// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败--------error:%@",error);
}




// 加载更多动态 数据
- (void)loadMoreData:(NSInteger )index withValue:(NSArray *)valueArr {

    if (self.isFooterRefreshing) return;// 正在刷新 直接return
    self.tableView.mj_footer.hidden = NO;
    self.headerRefreshing = YES;
    
    NSArray *keyArr;
    valueArr = valueArr == nil ? @[] : valueArr;
    if (index == 0) {
        keyArr = @[@"lng",@"lat",@"page"];
    }else if (index == 1){
        keyArr = @[@"lng",@"lat",@"distance",@"page"];
    }else if (index == 2){
        keyArr = @[@"lng",@"lat",@"tourist_id",@"page"];
    }else if (index == 3){
        keyArr = @[@"lng",@"lat",@"classify_id",@"page"];
    }else if (index == 4){
        keyArr = @[@"lng",@"lat",@"keyword",@"page"];
    }else{
        keyArr = nil;
    }
    
    [SVProgressHUD show];
    [MySDKHelper postAsyncWithURL:@"/v1/get_map" withParamBodyKey:keyArr withParamBodyValue:valueArr needToken:@"" postSucceed:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 0) {
            NSMutableArray *arr= [NSMutableArray array];
            NSArray *count = result[@"content"];
            if (count.count == 0) {
                self.headerRefreshing = NO;
                [self.tableView.mj_footer endRefreshing];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                return ;
            }
            for (id object in result[@"content"]) {
                NearShopModel *model = [NearShopModel mj_objectWithKeyValues:object];
                [arr addObject:model];
            }
            [self.modelArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
            self.headerRefreshing = NO;
            [self.tableView reloadData];
        }else{
            [NoticeView showMessage:result[@"message"]];
            [self.tableView.mj_header endRefreshing];
        }
        
        [SVProgressHUD dismiss];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
        [self.tableView.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [SVProgressHUD dismiss];
    }];
}

#pragma  mark -- 查找附近的商家
//0通过经纬度 1通过距离 2通过区 3通过分类
- (void)loadData:(NSInteger )index withValue:(NSArray *)valueArr{
    if (self.isHeaderRefreshing) return;
    self.page = 1;
    self.headerRefreshing = YES;
    self.tableView.mj_footer.hidden = YES;
    NSArray *keyArr;
    valueArr = valueArr == nil ? @[] : valueArr;
    if (index == 0) {
        keyArr = @[@"lng",@"lat",@"page"];
    }else if (index == 1){
        keyArr = @[@"lng",@"lat",@"distance",@"page"];
    }else if (index == 2){
        keyArr = @[@"lng",@"lat",@"tourist_id",@"page"];
    }else if (index == 3){
        keyArr = @[@"lng",@"lat",@"classify_id",@"page"];
    }else if (index == 4){
        keyArr = @[@"lng",@"lat",@"keyword",@"page"];
    }else{
        keyArr = nil;
    }
    NSLog(@"经纬度地址 %@",valueArr);
    self.modelArr = [NSMutableArray array];
    [SVProgressHUD show];
    [self.tableView.mj_footer resetNoMoreData];
    [MySDKHelper postAsyncWithURL:@"/v1/get_map" withParamBodyKey:keyArr withParamBodyValue:valueArr needToken:@"" postSucceed:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 0) {
            NSMutableArray *arr= [NSMutableArray array];
            for (id object in result[@"content"]) {
                NearShopModel *model = [NearShopModel mj_objectWithKeyValues:object];
                    [arr addObject:model];
            }
            self.modelArr = arr;
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer.hidden = NO;
            self.headerRefreshing = NO;
            [self.tableView reloadData];
        }else{
            [NoticeView showMessage:result[@"message"]];
            [self.tableView.mj_header endRefreshing];
        }
        
        [SVProgressHUD dismiss];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
        [self.tableView.mj_header endRefreshing];
        self.headerRefreshing = NO;
        [SVProgressHUD dismiss];
    }];
}


#pragma mark -- 通过商家或者会员
//商家或者会员
- (void)loadDataByCatogery:(NSInteger)index{
    NSArray *keyArr = @[@"keyword"];
    NSArray *valueArr = @[[NSString stringWithFormat:@"%ld",(long)index]];

    self.modelArr = [[NSMutableArray alloc] init];
    [SVProgressHUD show];
    [MySDKHelper postAsyncWithURL:@"/v1/business_member" withParamBodyKey:keyArr withParamBodyValue:valueArr needToken:@"" postSucceed:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 0) {
            for (id object in result[@"content"]) {
                NearShopModel *model = [NearShopModel mj_objectWithKeyValues:object];
                [self.modelArr addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [NoticeView showMessage:result[@"message"]];
        }
        [SVProgressHUD dismiss];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -- 通过城市查找
- (void)loadDataByCity:(NSString *)city{
    NSArray *keyArr = @[@"city"];
    NSArray *valueArr = @[city];
    self.getByCityModelArr = [[NSMutableArray alloc] init];
    
    [MySDKHelper postAsyncWithURL:@"/v1/get_area_by_city" withParamBodyKey:keyArr withParamBodyValue:valueArr needToken:@"" postSucceed:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 0) {
            for (id object in result[@"content"]) {
                GetByCityModel *model = [GetByCityModel mj_objectWithKeyValues:object];
                [self.getByCityModelArr addObject:model];
            }
        }
        else
        {
            [NoticeView showMessage:result[@"message"]];
        }
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}

#pragma mark -- 获取商家类型列表
- (void)loadShopCategory{
    self.shopCategoryArr = [[NSMutableArray alloc] init];
    self.shopCategoryIDArr = [[NSMutableArray alloc] init];
    [MySDKHelper postAsyncWithURL:@"/v1/promoter_type" withParamBodyKey:@[] withParamBodyValue:@[] needToken:@"" postSucceed:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in result[@"content"]) {
                [self.shopCategoryArr addObject:dic[@"name"]];
                [self.shopCategoryIDArr addObject:dic[@"id"]];
            }
        }
        else
        {
            [NoticeView showMessage:result[@"message"]];
        }
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}


#pragma mark -- textfield的代理
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.search resignFirstResponder];
    [self loadDataByCity:textField.text];
    NSLog(@"%@",textField.text);
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self removePopMenuView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.search resignFirstResponder];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.search resignFirstResponder];
}

#pragma mark - Custom Accessors

- (TitleDropMenuView *)titleView {
    if(!_titleView) {
        _titleView = [TitleDropMenuView TitleDropMenuViewInitWithFrame:CGRectMake(0, 114, self.view.frame.size.width, 44) otherSetting:^(TitleDropMenuView *titleMenuView) {
            titleMenuView.titleArray = @[@"附近",@"全部",@"智能排序",@"商家"];
            titleMenuView.imageArray = @[@"botton",@"botton",@"botton",@"botton"];
            titleMenuView.imageSelectArray =@[@"top",@"top",@"top",@"top"];
            titleMenuView.titleColor = @"#949494";
            titleMenuView.titleSelectColor = @"#333333";
        }];
        _titleView.delegate = self;
    }
    return _titleView;
}

- (void)customAccessors {
    [self.view addSubview:self.titleView];
}
#pragma mark - Click Actions
- (void)buttonClick:(UIButton *)button {
    NSLog(@"buttonClick");
}

#pragma mark - Private
- (void)removePopMenuView {
    if(self.dropDownView != nil) {
        [self.dropDownView dismiss:NO];
        self.dropDownView = nil;
    }
}

#pragma mark - TitleDropMenuViewDelegate
- (void)titleButtonClick:(NSInteger)btnTag buttonSelect:(BOOL)isSelect {
    [self.search resignFirstResponder];
    //不同按钮传递不同数据，需重新加载页面
    self.currentTag = btnTag + 100;
    [self removePopMenuView];
    if(isSelect == YES) {
        switch (btnTag) {
            case 0:
            {
                if (_buttonSelectIndex != 0) {
                    self.temuSelectIndex = 0;
                    self.selectIndex = 0;
                }
                _buttonSelectIndex = 0;
                NSMutableArray *temuArr = [[NSMutableArray alloc] init];
                NSMutableArray *subArr = [[NSMutableArray alloc] init];
                for (int i = 0;i <= self.getByCityModelArr.count; i ++) {
                    if (i == 0) {
                        [temuArr addObject:@"附近"];
                        [subArr addObject:[@[@"附近(智能范围)",@"500米",@"1000米",@"2000米",@"5000米"] mutableCopy]];
                    }
//                    else if (i == 1){
//                        [temuArr addObject:@"热门商区"];
//                        self.shopCategoryArr = self.shopCategoryArr == nil ? [@[] mutableCopy] : self.shopCategoryArr;
//                        [subArr addObject:self.shopCategoryArr];
//                    }
                    else{
                        GetByCityModel *model = self.getByCityModelArr[i-1];
                        NSMutableArray *arr = [[NSMutableArray alloc] init];
                        for (id object in model.child) {
                            Child *child = [Child mj_objectWithKeyValues:object];
                            [arr addObject:child.name];
                        }
                        [subArr addObject:arr];
                        [temuArr addObject:model.name];
                    }
                }
                self.dropDownView = [PopDropdownMenuView PopDropdownMenuViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-(50+NAV_SaferHeight))  tableOneWith:150 imageArray:nil otherSetting:^(PopDropdownMenuView *popDropMenuView) {
                    popDropMenuView.isTowTable = 1;
                    popDropMenuView.temuSelectIndex = self.temuSelectIndex;
                    popDropMenuView.selectIndex = self.selectIndex;
                    popDropMenuView.firstArray = temuArr;
                    popDropMenuView.secondArray = subArr[0];
                    popDropMenuView.tmpOuterArray = subArr;
                }];
                self.dropDownView.delegate = self;
                [self.dropDownView show:YES];
                
            }
                break;
            case 1:
            {
                if (_buttonSelectIndex != 1) {
                    self.temuSelectIndex = 0;
                }
                _buttonSelectIndex = 1;
                self.shopCategoryArr = self.shopCategoryArr == nil ? [@[] mutableCopy] : self.shopCategoryArr;
                self.dropDownView = [PopDropdownMenuView PopDropdownMenuViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-(50+NAV_SaferHeight))  tableOneWith:self.view.frame.size.width imageArray:@[] otherSetting:^(PopDropdownMenuView *popDropMenuView) {
                    popDropMenuView.isTowTable = 0;
                    popDropMenuView.temuSelectIndex = self.temuSelectIndex;
                    popDropMenuView.firstArray = self.shopCategoryArr;
                }] ;
                self.dropDownView.delegate = self;
                [self.dropDownView show:YES];
                
            }
                break;
            case 2:
            {
                if (_buttonSelectIndex != 2) {
                    self.temuSelectIndex = 0;
                }
                _buttonSelectIndex = 2;
                self.dropDownView = [PopDropdownMenuView PopDropdownMenuViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-(50+NAV_SaferHeight))  tableOneWith:self.view.frame.size.width imageArray:@[] otherSetting:^(PopDropdownMenuView *popDropMenuView) {
                    popDropMenuView.isTowTable = 0;
                    popDropMenuView.temuSelectIndex = self.temuSelectIndex;
                    popDropMenuView.firstArray = [NSMutableArray arrayWithObjects:@"智能排序",@"距离优先",@"人气",@"评价",@"口味",@"环境",@"服务",@"均价从低到高",@"均价从高到低", nil];
                }] ;
                self.dropDownView.delegate = self;
                [self.dropDownView show:YES];
//                UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-300)];
//                backView.backgroundColor = [UIColor blueColor];
//
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                button.backgroundColor = [UIColor redColor];
//                [button setTitle:@"自定义页面" forState:UIControlStateNormal];
//                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//                button.frame = CGRectMake(0, 0, 100, 50);
//                [backView addSubview:button];
//
//                self.dropDownView = [PopDropdownMenuView PopDropdownMenuViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-(50+NAV_SaferHeight)) contentView:backView otherSetting:^(PopDropdownMenuView *popDropMenuView) {
//                }];
//                self.dropDownView.delegate = self;
//                [self.dropDownView show:YES];
            }
                break;
            case 3:{
                if (_buttonSelectIndex != 3) {
                    self.temuSelectIndex = 0;
                }
                _buttonSelectIndex = 3;
                self.dropDownView = [PopDropdownMenuView PopDropdownMenuViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-(50+NAV_SaferHeight))  tableOneWith:self.view.frame.size.width imageArray:@[] otherSetting:^(PopDropdownMenuView *popDropMenuView) {
                    popDropMenuView.isTowTable = 0;
                    popDropMenuView.temuSelectIndex = self.temuSelectIndex;
                    popDropMenuView.firstArray = [NSMutableArray arrayWithObjects:@"商家",@"会员", nil];
                }] ;
                self.dropDownView.delegate = self;
                [self.dropDownView show:YES];
            }
                break;
            default:
                break;
        }
    }
    
}
#pragma mark - PopDropdownMenuViewDelegate
- (void)tableViewDidSelect:(NSInteger)indexRow obj:(id)obj {
    switch (_buttonSelectIndex) {
        case 0:
        {
            self.temuSelectIndex = indexRow;
            
            if (indexRow == 0) {
                NSMutableDictionary *dic = (NSMutableDictionary *)obj;
                NSString *str = dic[@"name"];
                [_titleView.firstTitleButton setTitle:@"附近" forState:UIControlStateNormal];
                if ([dic[@"row"] integerValue] == 0) {
                    self.longitude = self.longitude == nil ? @"" : self.longitude;
                    self.latitude = self.latitude == nil ? @"" : self.latitude;
                    [self loadData:0 withValue:@[self.longitude,self.latitude,@"1"]];
                }else{
                    NSString *subString = [str substringWithRange:NSMakeRange(0, str.length-1)];
                    NSLog(@"mi:%ld",(long)[subString integerValue]);
                    [self loadData:1 withValue:@[self.longitude,self.latitude,[NSString stringWithFormat:@"%f",[subString integerValue] / 1000.0],@"1"]];
                }
                self.selectIndex = [dic[@"row"] integerValue];
            }else{
                NSMutableDictionary *dic = (NSMutableDictionary *)obj;
                NSInteger index = [dic[@"row"] integerValue];
                GetByCityModel *model = self.getByCityModelArr[indexRow-1];
                [_titleView.firstTitleButton setTitle:model.name forState:UIControlStateNormal];
                Child *child = [Child mj_objectWithKeyValues:model.child[index]];
                self.selectIndex = index;
                [self loadData:2 withValue:@[self.longitude,self.latitude,child.id,@"1"]];
            }
            CGSize buttonTitleSize = [self getSizeByText:_titleView.firstTitleButton.titleLabel.text textFont:[UIFont systemFontOfSize:12] textWidth:ScreenWidth/self.titleView.titleArray.count-1];
            _titleView.firstTitleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -(40+buttonTitleSize.width));
            _titleView.firstTitleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(buttonTitleSize.width), 0, 0);
        }
            
            break;
        case 1:
        {
            self.temuSelectIndex = indexRow;
            [self loadData:3 withValue:@[self.longitude,self.latitude,self.shopCategoryIDArr[indexRow],@"1"]];
        }
            break;
        case 2:
        {
            self.temuSelectIndex = indexRow;
        }
            break;
        case 3:
        {
            self.temuSelectIndex = indexRow;
            [self loadDataByCatogery:indexRow];
        }
            break;
        default:
            break;
    }
    //NSLog(@"row:%ld,obj:%@",indexRow,obj);
}

- (CGSize)getSizeByText:(NSString *)text textFont:(UIFont *)textFont textWidth:(long)textWidth{
    UIFont *font = textFont;//跟label的字体大小一样
    CGSize size = CGSizeMake(textWidth, 29999);//跟label的宽设置一样
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

- (void)dismissCurrentViewChangeSelectBtnStatues:(id)statues {
    UIButton *button = (UIButton *)[self.titleView viewWithTag:self.currentTag];
    button.selected = NO;
}

#pragma mark -- tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
  
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        ShopInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopInfoViewCell"];
       if (cell) {
           cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopInfoViewCell" owner:self options:nil] firstObject];
        }
        NearShopModel *model = self.modelArr[indexPath.section];
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                 forHTTPHeaderField:@"Accept"];
    if ([model.picture rangeOfString:@"http"].location != NSNotFound) {
        [cell.shopimgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.picture]] placeholderImage:[UIImage imageNamed:@"icon-60"] options:SDWebImageAllowInvalidSSLCertificates];
    }
    else
    {
        [cell.shopimgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,model.picture]] placeholderImage:[UIImage imageNamed:@"icon-60"] options:SDWebImageAllowInvalidSSLCertificates];
        
        NSLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,model.picture]]);
    }
    
    if (model.is_district == 1) {
        cell.jurisdiction.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6b4", 24, [UIColor colorWithHexString:@"#91a8ff"])];
    }
    else if (model.is_district == 0)
    {
        cell.jurisdiction.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e665", 24, [UIColor colorWithHexString:@"#b59bff"])];
    }
        cell.shopName.text = model.shop_name;
        cell.startNumber = model.quality_service;
        cell.priceForEveryOne.text = [NSString stringWithFormat:@"￥%@/人",model.price];
        cell.catgary.text = model.shop_type;
        cell.distance.text = [NSString stringWithFormat:@"%.2f km",model.dist];
        cell.likeImage.image = [UIImage imageNamed:@"zan"];
        cell.consume.text = [NSString stringWithFormat:@"%ld人消费",(long)model.consume_num];
        cell.activteView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NearShopModel *model = self.modelArr[indexPath.section];
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
    ShopForDetailsViewController *shopDetails = [stroy instantiateViewControllerWithIdentifier:@"ShopForDetailsViewController"];
    shopDetails.ID = model.id;
    shopDetails.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDetails animated:YES];
    
}

#pragma 设置tableView线条画满
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (IBAction)mapClick:(UIButton *)sender {
    NSLog(@"地图");
    MapViewController *map = [[MapViewController alloc] init];
    map.hidesBottomBarWhenPushed = YES;
    map.isPush = YES;
    [self.navigationController pushViewController:map animated:YES];
    map.hidesBottomBarWhenPushed = NO;

}


- (IBAction)switchAddress:(id)sender {  
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    SwitchAddressViewController *swich = [stroy instantiateViewControllerWithIdentifier:@"SwitchAddressViewController"];
    swich.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:swich animated:YES];
}

- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
