//
//  AppDelegate.m
//  Newyuanmeng
//
//  Created by hy on 2018/3/24.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "AppDelegate.h"
#import "HYTabBarViewController.h"
#import "Newyuanmeng-Swift.h"
#import "SplashScrollViewController.h"
#import "LHDBQueue.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVSpeechSynthesis.h>

@interface AppDelegate ()<JPUSHRegisterDelegate,AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) UIImageView *splashView;
@property (nonatomic, strong) LHDBQueue *lhdb;
@property (nonatomic, strong) NSArray *dic;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isShow;

@property(nonatomic,strong) AVSpeechSynthesizer *voice;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setup];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"feaaf7eaf74a3c1a161b779d" channel:@"APP Store" apsForProduction:YES];
    
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    return YES;
}

-(void)setup
{
    [TBCityIconFont setFontName:@"iconfont"];
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self getSessionId];
    [IAPHelper checkIAPReceiptWithPath:@"" type:0];
    [UserDefaults removeObjectForKey:@"FirstStartInstalled"];
    // 判断是否第一次启动
    if ([UserDefaults objectForKey:@"FirstStartInstalled"] == nil) {
        [UserDefaults setObject:@"打开过一次" forKey:@"FirstStartInstalled"];
        SplashScrollViewController *splashs = [[SplashScrollViewController alloc] init];
        self.window.rootViewController = splashs;
       
    }else{
        // 2.设置窗口的跟控制器
        self.window.rootViewController = [[HYTabBarViewController alloc] init];
    }
     // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    if (![UserDefaults objectForKey:@"citydata"]) {
        [self getCityDate];
    }
    
    if (![UserDefaults objectForKey:@"shopbadge"]) {
        [UserDefaults setObject:@"0" forKey:@"shopbadge"];
    }else{
        CommonConfig.shopBadge = [[UserDefaults objectForKey:@"shopbadge"] intValue];
    }
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage createImageWithColor:CommonConfig.MainGrayColor width:10 height:10] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    
    [UMengHelper UmengInit];
    [MOBHelper setMobWithAppkey:MobAppkey withSecret:MobAppSecret];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customNotice:) name:@"customNotice" object:nil];
    
//    if ([UserDefaults objectForKey:@"ShopPhoneList"] == nil) {
//        [UserDefaults setObject:@{@"":@""} forKey:@"ShopPhoneList"];
//    }
//
//    if ([UserDefaults objectForKey:@"SearchList"] == nil) {
//        [UserDefaults setObject:@[] forKey:@"SearchList"];
//    }
    
    [AMapServices sharedServices].apiKey = @"0ac83448015adf0c1b3de72ebee38759";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[RCIM sharedRCIM] initWithAppKey:@"p5tvi9dsphuc4"];
    
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
       
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
    NSDictionary *extras = userInfo[@"aps"];
    
    NSString *alerts = extras[@"alert"];
    
    if ([[UserDefaults objectForKey:@"voice"] isEqualToString:@"1"]) {
        if ([[userInfo allKeys] containsObject:@"type"]) {
            NSString *type = userInfo[@"type"];
            if ([type isEqualToString:@"offline_balance"]) {
                if (![alerts isKindOfClass:[NSNull class]]) {
                    
                    _voice = [[AVSpeechSynthesizer alloc] init];
                    AVAudioSession *avAudio = [AVAudioSession sharedInstance];
                    NSError *error;
                    [avAudio setCategory:AVAudioSessionCategoryAmbient error:&error];
                    AVSpeechUtterance *speech = [[AVSpeechUtterance alloc] initWithString:alerts];
                    speech.pitchMultiplier = 1.1;
                    speech.volume = 1;
                    speech.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];
                    [_voice speakUtterance:speech];
                }
            }
        }
    }
    
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
}

-(void)customNotice:(NSNotification *)notification{
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        _timer = [[NSTimer alloc] init];
        _dic = notification.object;
        if (_dic.count != 0 && _timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showNotice) userInfo:nil repeats:YES];
            [self showNotice];
        }
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
    }
}

-(void)networkDidReceiveMessage:(NSNotification *)notification{
    NSString *str = notification.userInfo[@"content"];
    NSLog(@"%@",str);
}

-(void)showNotice
{
    if (_dic.count == 0) {
        [self stopNoticeTime];
        return;
    }
    NSDictionary *info = _dic[0];
    NSString *content = info[@"content"];
    NSDictionary *extra = info[@"extras"];
    NSString *type = extra[@"type"];
    NSString *cancer = @"取消";
    NSString *defaults = @"确定";
    if ([type isEqualToString:@"9"]) {
        cancer = @"退出登录";
        defaults = @"重新登录";
    }
    if ([type isEqualToString:@"9"]) {
        if (self.isShow) {
            [self logOut];
            self.isShow = NO;
        }
        UIAlertController *alett = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *defauls = [UIAlertAction actionWithTitle:defaults style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *cancers = [UIAlertAction actionWithTitle:cancer style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self logOut];
        }];
        [alett addAction:defauls];
        [alett addAction:cancers];
        NSLog(@"弹窗显示不出");
    }else{
        [SwiftNotice noticeOnSatusBar:content autoClear:YES autoClearTime:2];
    }
    
}

-(void)stopNoticeTime
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)getCityDate
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:@"area.db"];
    
    NSString *fileNameago = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"db"];
    
    NSError *error;
//    if (![fm fileExistsAtPath:dataFilePath]) {
//        if ([fm copyItemAtPath:fileNameago toPath:dataFilePath error:&error]) {
//            if (error == nil) {
//                NSLog(@"数据库拷贝成功");
//            }else{
//                NSLog(@"数据库拷贝失败");
//            }
//            _lhdb = [LHDBQueue instanceManager];
//            _lhdb.sqlPath = fileNameago;
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                [_lhdb readOpeartionWith:@"SELECT * FROM tiny_area" tableName:@"tiny_area" success:^(NSArray *resultArray) {
//                    NSArray *arr = [MySDKHelper choosecity:resultArray];
//                    [UserDefaults setObject:resultArray forKey:@"addressdata"];
//                    [UserDefaults setObject:arr forKey:@"citydata"];
//                } faild:^(NSError *error) {
//                    NSLog(@"%@",error);
//                }];
//                
//            });
//        }
//    
//    }
}

-(void)getSessionId
{
    [MySDKHelper postAsyncWithURL:@"" withParamBodyKey:@[@"version",@"platform"] withParamBodyValue:@[@"1.0",@"ios"] needToken:@"" postSucceed:^(NSDictionary * _Nonnull result) {
//        RequestUrl.session_id = result[@"content"][@"session_id"];
        CommonConfig.ImageHost = result[@"content"][@"img_host"];
        CommonConfig.UploadURL = result[@"content"][@"uploadurl"];
        MyManager.sharedMyManager.ImageHost = result[@"content"][@"img_host"];
         MyManager.sharedMyManager.UploadURL = result[@"content"][@"uploadurl"];
         MyManager.sharedMyManager.sessionid = result[@"content"][@"session_id"];
        
    } postCancel:^(NSString * _Nonnull error) {
        
    }];
}

- (void)showMainPage
{
    [_splashView removeFromSuperview];
    _splashView = nil;
//    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"NewMainViewController"];
    self.window.rootViewController = [[HYTabBarViewController alloc] init];
//    [self.window.rootViewController.tabBarController setSelectedIndex:0];
    
//    self.window.rootViewController.tabBarController.viewControllers[].tabBarItem.badgeValue = @"1";
}

- (void)logOut
{
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
