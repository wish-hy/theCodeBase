//
//  MapViewController.m
//  huabi
//
//  Created by huangyang on 2017/11/23.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnnotationView.h"
#import "NearShopModel.h"
#import "ShopDetailView.h"
#import "ShopForDetailsViewController.h"
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "YSCRippleView.h"
#import "NearViewController.h"
#import "MapPaperRedModel.h"
#import "Newyuanmeng-Swift.h"
#import "RobRedBagView.h"
#import "DetailsOfRedViewController.h"
@interface MapViewController ()<MAMapViewDelegate,CLLocationManagerDelegate,AMapSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)MAMapView *mapView;

@property(nonatomic,strong)AMapSearchAPI * search;

@property(nonatomic,strong)AMapReGeocodeSearchRequest *regeo;

@property (nonatomic,strong)NSMutableArray *annotations;
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic,strong)YSCRippleView *rippleView;

@property (nonatomic,strong)UITextField *textfiled;

@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *adressArray;
// 定位前 经纬度
@property (nonatomic, strong) NSString *lat;
@property (nonatomic,strong) NSString *lon;

// 定位后经纬度
@property (nonatomic,strong)NSString *llat;
@property (nonatomic,strong)NSString *llon;

// 用户经纬度
@property (nonatomic,strong)NSString *userLat;
@property (nonatomic,strong)NSString *userLon;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AMapServices sharedServices].enableHTTPS = YES;
    
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView = mapView;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    mapView.showsUserLocation = NO;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    
    [_mapView setZoomLevel:15 animated:YES];//改变地图的缩放级别
//    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    imagev.center = _mapView.center;
//    imagev.image = [UIImage imageNamed:@"tuoyuan"];
//    [_mapView addSubview:imagev];
    

    YSCRippleView *rippleView = [[YSCRippleView alloc] initWithFrame:CGRectMake(ScreenWidth/2-50, ScreenHeight/2-100, 100, 100)];
//    rippleView.center = _mapView.center;
    _rippleView = rippleView;
    [rippleView showWithRippleType:YSCRippleTypeCircle];
    [_rippleView addRippleLayer];
    [_mapView addSubview:rippleView];
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    
    
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    [self.mapView updateUserLocationRepresentation:r];
    
    // 显示比例尺
    self.mapView.showsScale = YES;
    self.mapView.rotateCameraEnabled= NO;  // 禁用倾斜手势
    // 缩放
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 10);
    
    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:zoomPannelView];
    
    // 定位按钮
    self.gpsButton = [self makeGPSButtonView];
    self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 20);
    [self.view addSubview:self.gpsButton];
    self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;


    [self initSetting];
    
    [self getLocation];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    // 强制隐藏tabbar
//    NSArray *views = self.tabBarController.view.subviews;
//    UIView *contentView = [views objectAtIndex:0];
//    contentView.height += 49;
//    self.tabBarController.tabBar.hidden = YES;
//}

#pragma mark - MAMapViewDelegate
//地图区域改变完成后调用的接口
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    NSLog(@"地图区域改变完成后调用的接口%f",mapView.region.center.latitude); //拿到中心点的经纬度
//    NSLog(@"%f\n",mapView.region.center.longitude);
    
    //如果将坐标转为地址,需要进行逆地理编码
    //设置逆地理编码查询参数 ,进行逆地编码时，请求参数类为 AMapReGeocodeSearchRequest，location为必设参数。
    _regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    _regeo.location = [AMapGeoPoint locationWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
    _regeo.requireExtension = YES;
    [_search AMapReGoecodeSearch:_regeo];
    
}



#pragma mark -  AMapSearchDelegate
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    if (response.regeocode != nil)
    {
//        [_rippleView addRippleLayer];
        //位置信息
        NSLog(@"reGeocode:%@", response.regeocode.formattedAddress);//获得的中心点地址
        NSArray *arr = response.regeocode.aois;

        if (arr.count > 0) {
            AMapAOI *amapAoi = arr[0];
            NSLog(@"当前纬度:%f",amapAoi.location.latitude);
            NSLog(@"经度:%f",amapAoi.location.longitude);
            _lat = [NSString stringWithFormat:@"%f",amapAoi.location.latitude];
            _lon = [NSString stringWithFormat:@"%f",amapAoi.location.longitude];
            NSLog(@"定位前？%@-----%@",_lat,_lon);
                //1.将两个经纬度点转成投影点
                MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_llat doubleValue], [_llon doubleValue]));
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_lat doubleValue],[_lon doubleValue]));
//                //2.计算距离
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
//
                NSLog(@"两点之间的距离%f",distance);
            
                if (distance > 500) {
                    [_rippleView beganAnimal];
//                    [_rippleView showWithRippleType:YSCRippleTypeCircle];
                    [self loadDataWithValue:@[[NSString stringWithFormat:@"%f",amapAoi.location.longitude],[NSString stringWithFormat:@"%f",amapAoi.location.latitude]]];
                }

        
        }
    }
}

#pragma  mark -- 查找附近的商家
//0通过经纬度 1通过距离 2通过区 3通过分类
- (void)loadDataWithValue:(NSArray *)valueArr{
    [_mapView removeAnnotations:self.annotations];
    NSArray *keyArr;
    valueArr = valueArr == nil ? @[] : valueArr;
    keyArr = @[@"lng",@"lat"];
    
    NSLog(@"保存的经纬度 %@  %@",_llon,_llat);
    _llat = valueArr[1];
    _llon = valueArr[0];
    [SVProgressHUD show];
    self.annotations = [[NSMutableArray alloc] init];
    self.modelArr = [[NSMutableArray alloc] init];
    NSString *urlString;
    urlString = @"/v1/get_map";
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadDataWithValue:) object:valueArr]; //取消之前的定时加载
    [MySDKHelper postAsyncWithURL:urlString withParamBodyKey:keyArr withParamBodyValue:valueArr needToken:@"" postSucceed:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 0) {
            NSArray *contentArr = result[@"content"];
            for (NSInteger i = 0; i < contentArr.count;i ++ ) {
                id object = contentArr[i];
                NearShopModel *model = [NearShopModel mj_objectWithKeyValues:object];
                [self.modelArr addObject:model];
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
                MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                annotation.coordinate = coor;
                annotation.title    = [NSString stringWithFormat:@"%ld",(long)i];
                [self.annotations addObject:annotation];
            }
            [self loadPaperRedWithValue:valueArr];
        }else{
            [NoticeView showMessage:result[@"message"]];
        }
        [SVProgressHUD dismiss];
    } postCancel:^(NSString *error) {
        [self performSelector:@selector(loadDataWithValue:) withObject:valueArr afterDelay:3]; //请求超时就定时加载
        [SVProgressHUD dismiss];
    }];
}

#pragma  mark -- 获取红包
//
- (void)loadPaperRedWithValue:(NSArray *)valueArr{
    NSArray *keyArr;
    valueArr = valueArr == nil ? @[] : valueArr;
    keyArr = @[@"lng",@"lat"];
    [SVProgressHUD show];
    NSString *urlString;
    urlString = @"/v1/redbag_list";
    [MySDKHelper postAsyncWithURL:urlString withParamBodyKey:keyArr withParamBodyValue:valueArr needToken:@"" postSucceed:^(NSDictionary *result) {
        if ([result[@"code"] integerValue] == 0) {
            NSInteger titleId = self.modelArr.count;
            NSArray *contentArr = result[@"content"];
            for (NSInteger i = 0; i < contentArr.count;i ++ ) {
                MapPaperRedModel *model = [MapPaperRedModel mj_objectWithKeyValues:contentArr[i]];
                [self.modelArr addObject:model];
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
                MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                annotation.coordinate = coor;
                annotation.title = [NSString stringWithFormat:@"%ld",(long)i+titleId];
                [self.annotations addObject:annotation];
            }
//            _mapView.userTrackingMode = MAUserTrackingModeFollow;
        }else{
            [NoticeView showMessage:result[@"message"]];
        }
        [_mapView addAnnotations:self.annotations];
        [SVProgressHUD dismiss];
    } postCancel:^(NSString *error) {
        [SVProgressHUD dismiss];
         [_mapView addAnnotations:self.annotations];
    }];
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
    
    NSLog(@"纬度1:%f",newLocation.coordinate.latitude);
    NSLog(@"经度1:%f",newLocation.coordinate.longitude);
    
    _userLon = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    _userLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    // 停止位置更新
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    //    CLLocationDegrees latitude = location.coordinate.latitude;
    //    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"纬度:%f",location.coordinate.latitude);
    NSLog(@"经度:%f",location.coordinate.longitude);
    _userLat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    _userLon = [NSString stringWithFormat:@"%f",location.coordinate.longitude ];
    [self loadDataWithValue:@[[NSString stringWithFormat:@"%f",location.coordinate.longitude],
                              [NSString stringWithFormat:@"%f",location.coordinate.latitude]]];
}



// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败--------error:%@",error);
}



#pragma mark - Utility

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = title;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        annotationView.annotation = annotation;
     
        if (self.modelArr.count != 0) {
            id object = self.modelArr[[annotation.title integerValue]];
            if ([object isKindOfClass:[NearShopModel class]]) {
                NearShopModel *model =(NearShopModel *)object;
                CLLocationCoordinate2D coor = annotation.coordinate;
                if (model.is_district == 0) {
                    annotationView.portraitImageView.image = [UIImage imageNamed:@"dianpu-1"];
                    CGRect frame = annotationView.portraitImageView.frame;
                    frame.size.width = 48;
                    frame.size.height = 52;
                    annotationView.portraitImageView.frame = frame;
                }else{
                    annotationView.portraitImageView.image = [UIImage imageNamed:@"wawa2"];
                    CGRect frame = annotationView.portraitImageView.frame;
                    frame.size.width = 50;
                    frame.size.height = 50;
                    annotationView.portraitImageView.frame = frame;
                }
                annotationView.nameLabel.text = model.shop_name;
                CGSize size = [model.shop_name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
                [annotationView.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(size.width + 20*ScaleWidth);
                }];
                NSLog(@"代理方法的位置:%f,%f",coor.latitude,coor.longitude);
                annotationView.centerOffset=CGPointMake(0,-18);
                __weak __typeof(&*self)weakSelf = self;
                annotationView.showaction = ^(NSInteger index) {
                    NSLog(@"点击了:%ld",(long)index);
                    [weakSelf showShopDetail:index];
                };
            }else if ([object isKindOfClass:[MapPaperRedModel class]]){ //红包
                MapPaperRedModel *model =(MapPaperRedModel *)object;
                CLLocationCoordinate2D coor = annotation.coordinate;
                if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"2"]) { //红包
                    annotationView.portraitImageView.image = [UIImage imageNamed:@"hongbao3"];
                }else if ([model.type isEqualToString:@"3"]){ //宝箱
                    annotationView.portraitImageView.image = [UIImage imageNamed:@"hongb"];
                    [annotationView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CommonConfig.ImageHost,model.avatar]] placeholderImage:[UIImage imageNamed:@"none"]];
                }
                CGRect frame = annotationView.portraitImageView.frame;
                frame.size.width = 43;
                frame.size.height = 52;
                annotationView.portraitImageView.frame = frame;
                
//                annotationView.nameLabel.text = model.shop_name;
//                CGSize size = [model.shop_name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
//                [annotationView.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo(size.width + 20*ScaleWidth);
//                }];
                NSLog(@"代理方法的位置:%f,%f",coor.latitude,coor.longitude);
                annotationView.centerOffset=CGPointMake(0,-18);
                __weak __typeof(&*self)weakSelf = self;
                annotationView.showaction = ^(NSInteger index) {
                    //点击红包
                    NSLog(@"-----%ld",(long)index);
                    [weakSelf showRedView:index];
                };
            }
            
        }
        
        annotationView.backgroundColor = [UIColor clearColor];
        return annotationView;
    }
    return nil;
}

//显示商店的介绍
- (void)showShopDetail:(NSInteger )index{
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadow)];
    [self.shadowView addGestureRecognizer:tap];
    [self.view addSubview:self.shadowView];
    [UIView animateWithDuration:0.6 animations:^{
        self.shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    }];
    ShopDetailView *shopDetailView = [ShopDetailView creatShopDetailView];
    NearShopModel *model = self.modelArr[index];
    [shopDetailView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,model.picture]] placeholderImage:[UIImage imageNamed:@"none"]];
    shopDetailView.nameLabel.text = model.shop_name;
    shopDetailView.distanceLabel.text = [NSString stringWithFormat:@"距离：%.2fkm",model.dist];
    shopDetailView.descLabel.text = model.info;
    [self.shadowView addSubview:shopDetailView];
    [shopDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shadowView.mas_left).mas_equalTo(72*ScaleWidth);
        make.right.mas_equalTo(self.shadowView.mas_right).mas_equalTo(-72*ScaleWidth);
        make.height.mas_equalTo(534*ScaleHeight);
        make.centerX.centerY.mas_equalTo(self.shadowView);
    }];
    __weak __typeof(&*self)weakSelf = self;
    shopDetailView.buttonaction = ^(NSInteger index) {
        //index 0 再逛逛 1进店
        if (index == 0) {
            [weakSelf removeShadow];
        }else{ //进店
            UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
            ShopForDetailsViewController *shopDetails = [stroy instantiateViewControllerWithIdentifier:@"ShopForDetailsViewController"];
            shopDetails.ID = model.id;
            shopDetails.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopDetails animated:YES];
        }
    };
    shopDetailView.navgation = ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择地图" message:@"请选择您将要跳转的应用" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *iphone = [UIAlertAction actionWithTitle:@"iphone地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 终点位置
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
            // 用户位置
            //MKMapItem 使用场景: 1. 跳转原生地图 2.计算线路
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
            // 跳转地图
            //MKLaunchOptionsDirectionsModeKey 指定导航模式
            //NSString * const MKLaunchOptionsDirectionsModeDriving; 驾车
            //NSString * const MKLaunchOptionsDirectionsModeWalking; 步行
            //NSString * const MKLaunchOptionsDirectionsModeTransit; 公交
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];

        }];
        [alertController addAction:iphone];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            UIAlertAction *baidu = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",[model.lat doubleValue], [model.lng doubleValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
        
            }];
            [alertController addAction:baidu];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        {
            UIAlertAction *GaoDe = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"圆梦共享网",@"",[model.lat doubleValue], [model.lng doubleValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
        
            }];
            [alertController addAction:GaoDe];
        }
        UIAlertAction *cancer = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
       
        [alertController addAction:cancer];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView;
    for (annotationView in views)
    {
        if (![annotationView isKindOfClass:[MKPinAnnotationView class]])
        {
            CGRect endFrame = annotationView.frame;
            annotationView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y - 50.0, endFrame.size.width, endFrame.size.height);
            [UIView beginAnimations:@"mov" context:NULL];
            [UIView setAnimationDuration:0.45];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [annotationView setFrame:endFrame];
            [UIView commitAnimations];
        }
    }
}


- (void)showRedView:(NSInteger )index{
    
    MapPaperRedModel *mapPaper = self.modelArr[index];
    NSLog(@"红包经纬度%@---%@",mapPaper.lat,mapPaper.lng);
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_userLat doubleValue], [_userLon doubleValue]));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([mapPaper.lat doubleValue],[mapPaper.lng doubleValue]));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    NSLog(@"两点之间的距离%f %d ",distance,[mapPaper.available_distance intValue]);
    
    
    
    if (distance > [mapPaper.available_distance intValue]) {
        NSString *redName = [NSString stringWithFormat:@"%@离你有点远，请再走进一点",mapPaper.bag_name];
        [NoticeView showMessage:redName];
        return;
    }
    NSArray *keys = @[@"user_id",@"id"];
    NSArray *values = @[@(CommonConfig.UserInfoCache.userId),mapPaper.id];
    [MySDKHelper postAsyncWithURL:@"/v1/redbag_had_opened" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        if ([result[@"content"][@"had_opened"] integerValue] == 1)
        {  // 待打开
                self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                self.shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadow)];
                [self.shadowView addGestureRecognizer:tap];
                [self.view addSubview:self.shadowView];
                [UIView animateWithDuration:0.6 animations:^{
                    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
                }];
                RobRedBagView *robRedBag = [RobRedBagView creatRobRedBagView];
                robRedBag.center = self.view.center;
            [robRedBag.headerImage sd_setImageWithURL:[NSURL URLWithString:[CommonConfig getImageUrl:mapPaper.picture]] placeholderImage:[UIImage imageNamed:@"none"]];
            
                robRedBag.user_name.text = mapPaper.bag_name;
                if ([mapPaper.redbag_type isEqualToString:@"1"]) {
                    robRedBag.redBagType.text = @"发了个红包，金额随机";
                }
                else if ([mapPaper.redbag_type isEqualToString:@"2"])
                {
                    robRedBag.redBagType.text = @"发了个普通红包";
                }
                if ([mapPaper.info isKindOfClass:[NSNull class]] || [mapPaper.info isEqualToString:@""]) {
                    robRedBag.wish.text = @"恭喜发财，大吉大利";
                }
                else
                {
                    robRedBag.wish.text = mapPaper.info;
                }
                 __weak __typeof(&*self)weakSelf = self;
                robRedBag.open = ^{
                    [MySDKHelper postAsyncWithURL:@"/v1/redbag_open" withParamBodyKey:@[@"user_id",@"redbag_id",@"type"] withParamBodyValue:@[@(CommonConfig.UserInfoCache.userId),mapPaper.id,@"1"] needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
                        NSLog(@"hhhhhhh%@",result);
                        DetailsOfRedViewController *detail = [[DetailsOfRedViewController alloc] init];
                        detail.id = mapPaper.id;
                        detail.hidesBottomBarWhenPushed = YES;
                        detail.close = ^{
//                            [_rippleView beganAnimal];
//                            [self loadDataWithValue:@[_lon,_lat]];
                        };
                        [self.navigationController pushViewController:detail animated:YES];
                    } postCancel:^(NSString *error) {
                    [NoticeView showMessage:error];
                }];
                };
                robRedBag.close = ^{
                    [weakSelf removeShadow];
                };
            robRedBag.see = ^{
                DetailsOfRedViewController *detail = [[DetailsOfRedViewController alloc] init];
                detail.id = mapPaper.id;
                detail.hidesBottomBarWhenPushed = YES;
                detail.close = ^{
//                    [_rippleView beganAnimal];
//                    [self loadDataWithValue:@[_lon,_lat]];
                };
                [self.navigationController pushViewController:detail animated:YES];
            };
                [self.shadowView addSubview:robRedBag];
        }
        else if ([result[@"content"][@"had_opened"] integerValue] == 0)  // 没有更多
        {
            self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadow)];
            [self.shadowView addGestureRecognizer:tap];
            [self.view addSubview:self.shadowView];
            [UIView animateWithDuration:0.6 animations:^{
                self.shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
            }];
            RobRedBagView *robRedBag = [RobRedBagView creatRobRedBagView];
            robRedBag.center = self.view.center;
            
            robRedBag.wish.text = @"没有更多了~";
            robRedBag.headerImage.hidden = YES;
            robRedBag.user_name.hidden = YES;
            robRedBag.redBagType.hidden = YES;
            robRedBag.openButton.hidden = YES;
            
            __weak __typeof(&*self)weakSelf = self;
            robRedBag.see = ^{
                DetailsOfRedViewController *detail = [[DetailsOfRedViewController alloc] init];
                detail.id = mapPaper.id;
                detail.hidesBottomBarWhenPushed = YES;
                detail.close = ^{
//                    [_rippleView beganAnimal];
//                    [self loadDataWithValue:@[_lon,_lat]];
                };
                [self.navigationController pushViewController:detail animated:YES];
            };
            robRedBag.close = ^{
                [weakSelf removeShadow];
            };
            [self.view addSubview:robRedBag];
        }
        else if ([result[@"content"][@"had_opened"] integerValue] == 2) // 已开启
        {
            DetailsOfRedViewController *detail = [[DetailsOfRedViewController alloc] init];
            detail.id = mapPaper.id;
            detail.hidesBottomBarWhenPushed = YES;
            detail.close = ^{
//                [_rippleView beganAnimal];
//                [self loadDataWithValue:@[_lon,_lat]];
            };
            [self.navigationController pushViewController:detail animated:YES];
        }
        else
        {
            NSLog(@"NNNNNNNNNNNN");
        }
        
    } postCancel:^(NSString *error) {
        [SVProgressHUD dismiss];
        [NoticeView showMessage:@"请检查是否登录"];
    }];
    
}


- (void)removeShadow{
    [UIView animateWithDuration:0.6 animations:^{
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
    }];
    self.shadowView = nil;
}


#pragma mark - mapview delegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation)
    {
        MAAnnotationView *userLocationView = [mapView viewForAnnotation:mapView.userLocation];
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            userLocationView.imageView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}


#pragma mark - 导航栏
- (void)initSetting{
    self.mapView.showsCompass = NO;
    if (_isPush) {
        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(15, 30, 30, 30)];
        [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 30, ScreenWidth - 60, 30)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor colorWithHexString:@"#dcdcdc"].CGColor;
        view.layer.borderWidth = 1;
        
        UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
        imagev.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e626", 20, [UIColor colorWithHexString:@"cccccc"])];
        
        UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, ScreenWidth-80, 30)];
        _textfiled = textfiled;
        textfiled.placeholder = @"输入商户名、地点";
        textfiled.delegate = self;
        textfiled.clearButtonMode = UITextFieldViewModeAlways;
        textfiled.returnKeyType = UIReturnKeyGo;
        [view addSubview:imagev];
        [view addSubview:textfiled];
        [self.view addSubview:view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange) name:UITextFieldTextDidChangeNotification object:nil];
        
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 200) style:UITableViewStylePlain];
        _tableV = table;
        self.tableV.hidden = YES;
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 30, ScreenWidth-80, 30)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor colorWithHexString:@"#dcdcdc"].CGColor;
        view.layer.borderWidth = 1;
        
        UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
        imagev.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e626", 20, [UIColor colorWithHexString:@"cccccc"])];
        
        UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, ScreenWidth-80, 30)];
        _textfiled = textfiled;
        textfiled.placeholder = @"输入商户名、地点";
        textfiled.delegate = self;
        textfiled.clearButtonMode = UITextFieldViewModeAlways;
        textfiled.returnKeyType = UIReturnKeyGo;
        [view addSubview:imagev];
        [view addSubview:textfiled];
        [self.view addSubview:view];

         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange) name:UITextFieldTextDidChangeNotification object:nil];
       
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 200) style:UITableViewStylePlain];
        _tableV = table;
        self.tableV.hidden = YES;
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth-50, 30, 30, 30);
        [button setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6b5", 25, [UIColor blackColor])] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(goToNearView) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }

}

-(void)textValueChange
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = _textfiled.text;
    request.requireExtension = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSMutableArray *arr = [NSMutableArray array];
    if (response.pois.count == 0)
    {
        [self.adressArray removeAllObjects];
        self.tableV.hidden = YES;
        return;
    }
    
    for(AMapPOI *poi in response.pois){
        NSLog(@"%@.%@-%@-%@",poi.name,poi.district,poi.businessArea,poi.address);
        [arr addObject:poi];
    }
    self.tableV.hidden = NO;
    self.adressArray = arr;
    
    if (self.adressArray.count < 4) {
        self.tableV.frame = CGRectMake(0, 60, ScreenWidth, 50);
    }
    else
    {
        self.tableV.frame = CGRectMake(0, 60, ScreenWidth, 200);
    }
    
    [self.tableV reloadData];
}

-(void)goToNearView
{
    NearViewController *near = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"NearViewController"];
    near.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:near animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textfiled resignFirstResponder];

}

- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
    self.mapView.showsScale = YES;
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
    self.mapView.showsScale = NO;
}

- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
        [self loadDataWithValue:@[[NSString stringWithFormat:@"%f",self.mapView.userLocation.location.coordinate.longitude],
                                  [NSString stringWithFormat:@"%f",self.mapView.userLocation.location.coordinate.latitude]]];
    }
}

-(void)backClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.adressArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    AMapPOI *poi = self.adressArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@",poi.name,poi.district,poi.businessArea,poi.address];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *poi = self.adressArray[indexPath.row];
    
    _textfiled.text = [NSString stringWithFormat:@"%@%@%@%@",poi.name,poi.district,poi.businessArea,poi.address];
    [_textfiled resignFirstResponder];
    _tableV.hidden = YES;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = poi.location.latitude;
    coordinate.longitude = poi.location.longitude;
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    [self loadDataWithValue:@[[NSString stringWithFormat:@"%f",poi.location.longitude],
                              [NSString stringWithFormat:@"%f",poi.location.latitude]]];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
@end
