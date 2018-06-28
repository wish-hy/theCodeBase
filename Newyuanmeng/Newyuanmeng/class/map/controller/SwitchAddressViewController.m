//
//  SwitchAddressViewController.m
//  huabi
//
//  Created by huangyang on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "SwitchAddressViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "NearViewController.h"



@interface SwitchAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AMapSearchDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *searchImage;
@property (weak, nonatomic) IBOutlet UIImageView *location;
@property (weak, nonatomic) IBOutlet UITableView *adressTableView;   //  搜索历史
@property (nonatomic,strong)UITableView *guessTable;  //地址选择
@property (weak, nonatomic) IBOutlet UITextField *textFied;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,strong)AMapSearchAPI * search;

@property (weak, nonatomic) IBOutlet UILabel *dinWei2;
@property (weak, nonatomic) IBOutlet UIView *dinWeiView;

@property (nonatomic,strong)NSMutableArray *adressArray;

@property (nonatomic,strong)NSMutableArray *logArray;
@end

@implementation SwitchAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGesture];
    NSLog(@"%@",_logArray);
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"logArray"];
    _logArray = [array mutableCopy];
    self.searchImage.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e689", 25, [UIColor colorWithHexString:@"dddddd"])];
    self.location.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e69a", 25, [UIColor redColor])];
    self.adressTableView.delegate = self;
    self.adressTableView.dataSource = self;
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    _guessTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, ScreenWidth, 200) style:UITableViewStylePlain];
    _guessTable.hidden = YES;
    _guessTable.delegate = self;
    _guessTable.dataSource = self;
    [self.view addSubview:_guessTable];
    
    _textFied.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    

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

-(void)setGesture
{
    self.dinWeiView.userInteractionEnabled = YES;
    self.dinWei2.userInteractionEnabled = YES;
    UITapGestureRecognizer *toch2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AutoDinWei)];
    UITapGestureRecognizer *toch3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AutoDinWei)];
    [self.dinWei2 addGestureRecognizer:toch2];
    [self.dinWeiView addGestureRecognizer:toch3];
}

-(void)AutoDinWei
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self.locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        _dinWei2.text = @"正在定位";
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

-(void)textValueChange
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = _textFied.text;
    request.requireExtension = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    //    CLLocationDegrees latitude = location.coordinate.latitude;
    //    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"纬度:%f",location.coordinate.latitude);
    NSLog(@"经度:%f",location.coordinate.longitude);
    [manager stopUpdatingLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = [placemarks lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [_localizeButton setTitle:place.thoroughfare forState:UIControlStateNormal];
            NearViewController *near = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"NearViewController"];
            near.adressValue = place.thoroughfare;
            near.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            near.lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            [self.navigationController pushViewController:near animated:YES];
        });
    }];
}


/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSMutableArray *arr = [NSMutableArray array];
    if (response.pois.count == 0)
    {
        [self.adressArray removeAllObjects];
        self.guessTable.hidden = YES;
        return;
    }
    
    for(AMapPOI *poi in response.pois){
        NSLog(@"%@.%@-%@-%@",poi.name,poi.district,poi.businessArea,poi.address);
        [arr addObject:poi];
    }
    self.guessTable.hidden = NO;
    self.adressArray = arr;
    
    if (self.adressArray.count < 4) {
        _guessTable.frame = CGRectMake(0, 115, ScreenWidth, 50);
    }
    else
    {
        _guessTable.frame = CGRectMake(0, 115, ScreenWidth, ScreenHeight-115);
    }
    
    [self.guessTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_adressTableView]) {
        return self.logArray.count;
    }
    else if ([tableView isEqual:_guessTable])
    {
        return self.adressArray.count;
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_adressTableView]) {
        return @"历史地址";
    }
    else if ([tableView isEqual:_guessTable])
    {
    }
    return @"";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if ([tableView isEqual:_adressTableView]) {
        if (_logArray.count == 0) {
            self.adressTableView.hidden = YES;
        }else{
            NSDictionary *info = self.logArray[indexPath.row];
            cell.textLabel.text = info[@"adress"];
            self.adressTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            self.adressTableView.tableFooterView.backgroundColor = [UIColor clearColor];
        }
    }
    else if ([tableView isEqual:_guessTable])
    {
        AMapPOI *poi = self.adressArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@",poi.name,poi.district,poi.businessArea,poi.address];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_adressTableView]) {
        NSDictionary *info = self.logArray[indexPath.row];
        NearViewController *near = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"NearViewController"];
        near.adressValue = info[@"adress"];
        near.lat = info[@"lat"];
        near.lon = info[@"lon"];
        [self.navigationController pushViewController:near animated:YES];
    }
    else if ([tableView isEqual:_guessTable])
    {
        AMapPOI *poi = self.adressArray[indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@%@%@%@",poi.name,poi.district,poi.businessArea,poi.address] forKey:@"adress"];
        [dic setObject:[NSString stringWithFormat:@"%f",poi.location.latitude] forKey:@"lat"];
        [dic setObject:[NSString stringWithFormat:@"%f", poi.location.longitude] forKey:@"lon"];
        
        [_logArray addObject:dic];
        [[NSUserDefaults standardUserDefaults] setObject:_logArray forKey:@"logArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NearViewController *near = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"NearViewController"];
        near.adressValue = [NSString stringWithFormat:@"%@%@%@%@",poi.name,poi.district,poi.businessArea,poi.address];
        near.lat = [NSString stringWithFormat:@"%f",poi.location.latitude];
        near.lon = [NSString stringWithFormat:@"%f", poi.location.longitude];
        [self.navigationController pushViewController:near animated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textFied resignFirstResponder];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)logArray
{
    if (!_logArray) {
         self.logArray = [ NSMutableArray array];
    }
    return _logArray;
}

@end
