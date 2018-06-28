//
//  MyCenterViewController.m
//  huabi
//
//  Created by huangyang on 2017/11/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "MyCenterViewController.h"
#import "TBCityIconFont.h"
#import "UIImage+TBCityIconFont.h"
#import "SingInViewController.h"
#import "Newyuanmeng-Swift.h"
#import "PurseViewController.h"
#import "MyInvitePModel.h"
//#import "ShoppingTrolleyController.h"
#import "MyInviteGenerController.h"
#import "ScanCodeOrderViewController.h"
#import "BecomeAgentsViewController.h"
#import "PaymentCodeViewController.h"
#import "ShopBalanceViewController.h"
#import "ShopManageViewController.h"
#import "VillageViewController.h"
#import "RechageCenterViewController.h"
#import "RedPacketViewController.h"
#import "ExampleVillageViewController.h"
#import "SettingViewController.h"
#import "ShopChatViewController.h"
#import "MessageListViewController.h"
#import "MyGeneralizeViewController.h"

#import <CoreTelephony/CTCellularData.h>

@interface MyCenterViewController ()

// image
@property (weak, nonatomic) IBOutlet CoreImageView *userImage;  // 头像
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIImageView *settlementImg;  // 结算图片
@property (weak, nonatomic) IBOutlet UIImageView *storeManagementImg;// 店铺管理
@property (weak, nonatomic) IBOutlet UIImageView *scanCodeOrderImg; // 扫码订单
@property (weak, nonatomic) IBOutlet UIImageView *shoppingCart;   //购物车

@property (weak, nonatomic) IBOutlet CoreImageView *membershipManagement; // 会员管理
@property (weak, nonatomic) IBOutlet CoreImageView *QrCodeForCollection;// 收款二维码
@property (weak, nonatomic) IBOutlet CoreImageView *shoppingManageImg;  // 商品管理
@property (weak, nonatomic) IBOutlet CoreImageView *PromotionCenter;  // 推广中心
//@property (weak, nonatomic) IBOutlet CoreImageView *treasureChest; // 宝箱
@property (weak, nonatomic) IBOutlet CoreImageView *redEnvelopeSystem;  //  红包系统
@property (weak, nonatomic) IBOutlet CoreImageView *cashierManagement;  // 收银管理

@property (weak, nonatomic) IBOutlet CoreImageView *myInvitation;  // 我的邀请
@property (weak, nonatomic) IBOutlet CoreImageView *myIncome;   // 我的收益
@property (weak, nonatomic) IBOutlet CoreImageView *withdrawalRecord;  // 提现记录
@property (weak, nonatomic) IBOutlet CoreImageView *dailyCheck;   // 每日签到
@property (weak, nonatomic) IBOutlet CoreImageView *productEvaluation;  // 商品评价

@property (weak, nonatomic) IBOutlet UIImageView *allOrder;
@property (weak, nonatomic) IBOutlet UIImageView *waitPay;
@property (weak, nonatomic) IBOutlet UIImageView *waitShipping;
@property (weak, nonatomic) IBOutlet UIImageView *waitReceive;
@property (weak, nonatomic) IBOutlet UIImageView *waitAppraise;


@property (nonatomic ,strong)NSDictionary *userInfoDIc;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Height;


//邀请人员
@property(nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.userInfoDIc = [NSDictionary dictionary];
    [self initWithButton];
    [self setInfo];
    [self addGestureRecinizer];
    [self initIcon];
    
    self.height.constant = 0;
    self.viewHeigh.constant = 620;
    
//    [self referAPP];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refershInfo) name:@"DownloadImageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeader) name:@"referHeaderImage" object:nil];
}

-(void)referAPP
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];

    NSLog(@"当前版本号：%@",appVersion);
    NSArray *keys = @[@"current_version"];
    NSArray *values = @[appVersion];
    [MySDKHelper postAsyncWithURL:@"/v1/version_update" withParamBodyKey:keys withParamBodyValue:values needToken:@"" postSucceed:^(NSDictionary *result) {
        NSDictionary * dic = result[@"content"];
        NSLog(@"%@",dic[@"enforce"]);
        NSString *enforece = [NSString stringWithFormat:@"%@",dic[@"enforce"]];
        if ([enforece isEqualToString:@"1"]) {
////            if (![appVersion isEqualToString:@"newversion"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle: [NSString stringWithFormat:@"发现新版本 %@",dic[@"newversion"]] message:[NSString stringWithFormat:@"最新版本大小: %@",dic[@"packagesize"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:dic[@"downloadurl"]];
                    [[UIApplication sharedApplication] openURL:url];
                }];
                UIAlertAction *cancer = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];

                [alert addAction:sure];
                [alert addAction:cancer];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window.rootViewController presentViewController:alert animated:YES completion:nil];
////            }
////            else
////            {
////                NSLog(@"当前版本不需要更新");
////            }
        }
        else
        {
            NSLog(@"当前版本不需要更新");
        }
    
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}


-(void)refershInfo
{
    NSLog(@"刷新数据");
    [self setInfo];
}

-(void)setHeader
{
    NSString *imgStr = [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"MyHeader"];
    // 拿到沙盒路径图片
    UIImage *header = [[UIImage alloc] initWithContentsOfFile:imgStr];
    self.userImage.image = header;
}

-(void)setInfo
{
    if (CommonConfig.isLogin) {
        [CommonConfig deleteAvatar];
        NSArray *keys = @[@"user_id"];
        NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
        NSLog(@"%@-----%@--------%@",keys,values,CommonConfig.Token);
        [SVProgressHUD showWithStatus:@"正在获取用户资料"];
        
        [MySDKHelper postAsyncWithURL:@"/v1/userinfo" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            NSLog(@"登录信息请求成功%@",result);
            [SVProgressHUD dismiss];
            self.userInfoDIc = result[@"content"][@"userinfo"];
            self.userName.text = self.userInfoDIc[@"nickname"];
            NSLog(@"用户名：%@",self.userInfoDIc[@"nickname"]);
            
            NSString *urlString = @"";

            if ([self.userInfoDIc[@"avatar"] rangeOfString:@"http"].location != NSNotFound) {
                urlString = _userInfoDIc[@"avatar"];
            }else{
                urlString = [NSString stringWithFormat:@"%@%@",imgHost,self.userInfoDIc[@"avatar"]];
            }
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            
            // 本地沙盒目录
            NSString *path = NSHomeDirectory();
            // 本地沙盒具体路径
            NSString *imageFilePath = [path stringByAppendingString:@"/Documents/MyHeader.jpg"];
            // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
            BOOL success = [UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath  atomically:YES];
//            BOOL success = [UIImagePNGRepresentation(image) writeToFile:imageFilePath atomically:YES];
            if (success){
                NSLog(@"图片写入本地成功");
            }
            
           int a = [self.userInfoDIc[@"is_business"] intValue];
            NSLog(@"用户级别 %d",a);
            if (a == 0)
            {
                NSLog(@"会员");
                self.height.constant = 0;
                self.viewHeigh.constant = 620;
                self.view2Height.constant = 208;
            }else if (a == 1){
                NSLog(@"代理商");
                self.height.constant = 208;
                self.viewHeigh.constant = 780;
                self.view2Height.constant = 124;
            }else{
                NSLog(@"经销商");
                self.height.constant = 208;
                self.viewHeigh.constant = 780;
                self.view2Height.constant = 124;
            }
            
            [self setHeader];

        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            self.userName.text = @"未登录";
            self.height.constant = 0;
            self.view2Height.constant = 208;
            self.viewHeigh.constant = 620;
            self.userImage.image = [UIImage imageNamed:@"wode2"];
            CommonConfig.isLogin = NO;
            [SVProgressHUD dismiss];
            [NoticeView showMessage:error];
            
        }];
    }else
    {
        self.userName.text = @"未登录";
        self.userImage.image = [UIImage imageNamed:@"wode2"];
        self.height.constant = 0;
        self.view2Height.constant = 208;
    }
}



// 签到送积分
- (IBAction)signInAndSendPoints:(CornerButton *)sender
{
    if (CommonConfig.isLogin)
    {
        SingInViewController *singIn = [[SingInViewController alloc] init];
        singIn.user_id = CommonConfig.UserInfoCache.userId;
        singIn.token = CommonConfig.Token;
        singIn.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:singIn animated:YES];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
   
}
- (IBAction)seeMore:(UIButton *)sender {
    if (CommonConfig.isLogin) {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
        OrderViewController *order = [stroy instantiateViewControllerWithIdentifier:@"OrderViewController"];
        order.status = @"all";
        [self.navigationController pushViewController:order animated:YES];
    }else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVc.isGoods = true;
        [self.navigationController pushViewController:loginVc animated:YES];
        NSLog(@"请登录");
    }
}
  
- (void)userInfo:(id)sender  // 登录  用户信息
{
    if (CommonConfig.isLogin)
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        InfoViewController *info = [stroy instantiateViewControllerWithIdentifier:@"InfoViewController"];
            info.img = self.userImage.image;
//            NSLog(@"%@",self.userInfoDIc[@"avatar"]);
//        if ([self.userInfoDIc[@"avatar"] rangeOfString:@"http"].location != NSNotFound) {
//            info.imgStr = self.userInfoDIc[@"avatar"];
//        }
//        else
//        {
//            info.imgStr = [NSString stringWithFormat:@"%@%@",imgHost,self.userInfoDIc[@"avatar"]];
//        }
//        NSLog(@"%@",[NSString stringWithFormat:@"%@%@",imgHost,self.userInfoDIc[@"avatar"]]);
        [self.navigationController pushViewController:info animated:YES];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}


-(void)jieSuanZhongXin   // 钱袋
{
    
    if (CommonConfig.isLogin) {
        PurseViewController *purse = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"PurseViewController"];
        purse.isShow = @"1";
        purse.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:purse animated:YES];
    }else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVc.isGoods = true;
        [self.navigationController pushViewController:loginVc animated:YES];
        NSLog(@"请登录");
    }
}

-(void)dianPuGuanLi   // 充值中心  成为代理商
{
    if (CommonConfig.isLogin) {
        if ([self.userInfoDIc[@"is_business"] intValue] == 0) {
            UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            RechageCenterViewController *rechageCenter = [stroy instantiateViewControllerWithIdentifier:@"RechageCenterViewController"];
            rechageCenter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rechageCenter animated:YES];
        }else{
            [NoticeView showMessage:@"您已经是代理商了"];
        }
    }else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVc.isGoods = true;
        [self.navigationController pushViewController:loginVc animated:YES];
        NSLog(@"请登录");
    }
}

-(void)saoYiSaoClick    // 扫码订单
{
    if (CommonConfig.isLogin) {
        NSLog(@"saoYiSaoClick");
        ScanCodeOrderViewController *scanCode = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanCodeOrderViewController"];
        scanCode.type = @"1";
        scanCode.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanCode animated:YES];
    }else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVc.isGoods = true;
        [self.navigationController pushViewController:loginVc animated:YES];
        NSLog(@"请登录");
    }
}

-(void)yaoQinmaClick  // 购物车
{
    NSLog(@"yaoQinmaClick");
    ShoppingTrolleyController *shoppIng = [[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingTrolleyController"];
    shoppIng.isPush = YES;
    shoppIng.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppIng animated:YES];
    
}

// 订单
-(void)quanBuDingDan
{
    NSLog(@"quanBuDingDan");
    if (CommonConfig.isLogin) {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
        OrderViewController *order = [stroy instantiateViewControllerWithIdentifier:@"OrderViewController"];
        order.status = @"all";
        [self.navigationController pushViewController:order animated:YES];
    }else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVc.isGoods = true;
        [self.navigationController pushViewController:loginVc animated:YES];
        NSLog(@"请登录");
    }
}
-(void)waitPayClick
{
    NSLog(@"waitPayClick");
    if (CommonConfig.isLogin)
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
        OrderViewController *order = [stroy instantiateViewControllerWithIdentifier:@"OrderViewController"];
        order.status = @"unpay";
        [self.navigationController pushViewController:order animated:YES];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void)waitShippingCLick
{
    NSLog(@"waitShippingCLick");
    if (CommonConfig.isLogin)
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
        OrderViewController *order = [stroy instantiateViewControllerWithIdentifier:@"OrderViewController"];
        order.status = @"undelivery";
        [self.navigationController pushViewController:order animated:YES];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void)waitReceiveClick
{
    NSLog(@"waitReceiveClick");
    if (CommonConfig.isLogin)
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
        OrderViewController *order = [stroy instantiateViewControllerWithIdentifier:@"OrderViewController"];
        order.status = @"unreceived";
        [self.navigationController pushViewController:order animated:YES];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void)waitAppraiseClick
{
    NSLog(@"waitAppraiseClick");
    if (CommonConfig.isLogin)
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"ShopCart" bundle:nil];
        OrderViewController *order = [stroy instantiateViewControllerWithIdentifier:@"OrderViewController"];
        order.status = @"comment";
        [self.navigationController pushViewController:order animated:YES];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}

-(void)huiYuanClick  // 收款二维码
{
    if (CommonConfig.isLogin) {
        NSLog(@"huiYuanClick");
        PaymentCodeViewController *paymengCode = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentCodeViewController"];
        paymengCode.name = self.userName.text;
        paymengCode.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:paymengCode animated:YES];
    }else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];

        LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVc.isGoods = true;
        [self.navigationController pushViewController:loginVc animated:YES];
        NSLog(@"请登录");
    }
 
}

-(void)shouKuanMaClick  // 推广中心
{
        if (CommonConfig.isLogin) {
            NSLog(@"推广中心");
            NSArray *keys = @[@"user_id"];
            NSArray *values = @[@(CommonConfig.UserInfoCache.userId)];
            [MySDKHelper postAsyncWithURL:@"/v1/get_district_list" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
                NSLog(@"推广列表%@",result[@"content"][@"userinfo"]);
                NSMutableArray *section2Content = [NSMutableArray array];
                //解析
                for (NSDictionary *dic in result[@"content"][@"district"]) {
                    VillageListModel *model = [[VillageListModel alloc] initWithDictionary:dic error:nil];
                    [section2Content addObject:model];
                }
                //        VillageListViewController *villagelist = [[VillageListViewController alloc] init];
                //        villagelist.hidesBottomBarWhenPushed = YES;
                //        villagelist.user_id = CommonConfig.UserInfoCache.userId;
                //        villagelist.token = CommonConfig.Token;
                ExampleVillageViewController *exampleVVC = [[ExampleVillageViewController alloc] init];
                exampleVVC.hidesBottomBarWhenPushed = YES;
                exampleVVC.haveVillage = YES;
                exampleVVC.user_id = CommonConfig.UserInfoCache.userId;
                exampleVVC.token = CommonConfig.Token;
                exampleVVC.model = section2Content[0];
                [self.navigationController pushViewController:exampleVVC animated:YES];
                
            } postCancel:^(NSString *error) {
                NSLog(@"%@",error);
                [NoticeView showMessage:error];
                VillageViewController *village = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"VillageViewController"];
                village.hidesBottomBarWhenPushed = YES;
                //        village.user_id = CommonConfig.UserInfoCache.userId;
                //        village.token = CommonConfig.Token;
                [self.navigationController pushViewController:village animated:YES];
                
            }];
        }else
        {
            UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
            LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginVc.isGoods = true;
            [self.navigationController pushViewController:loginVc animated:YES];
            NSLog(@"请登录");
        }


}
-(void)shopManager  // 商家管理
{
        if (CommonConfig.isLogin) {
            NSLog(@"shopManager");
            ShopManageViewController *shopManager = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"ShopManageViewController"];
            shopManager.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopManager animated:YES];
        }else
        {
            UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
            LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginVc.isGoods = true;
            [self.navigationController pushViewController:loginVc animated:YES];
            NSLog(@"请登录");
        }


    
}
-(void)huiYuanQuanYiClick // 收款订单  商家
{
        if (CommonConfig.isLogin) {
            NSLog(@"huiYuanQuanYiClick");
            ScanCodeOrderViewController *scanCode = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanCodeOrderViewController"];
            scanCode.type = @"2";
            scanCode.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scanCode animated:YES];
        }else
        {
            UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
            LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginVc.isGoods = true;
            [self.navigationController pushViewController:loginVc animated:YES];
            NSLog(@"请登录");
        }


}
//-(void)tuiGuangClick
//{
//    NSLog(@"tuiGuangClick");
//}
-(void)redEnvelopeSystemClick
{
        if (CommonConfig.isLogin) {
            NSLog(@"红包");
            RedPacketViewController *redPacket = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"RedPacketViewController"];
            redPacket.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:redPacket animated:YES];
        }else
        {
            UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
            LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginVc.isGoods = true;
            [self.navigationController pushViewController:loginVc animated:YES];
            NSLog(@"请登录");
        }


    
}
-(void)hongBaoClick    // 结算中心
{
        if (CommonConfig.isLogin) {
            NSLog(@"saoYiSaoClick");
            NSLog(@"结算");
            ShopBalanceViewController *shopBalance = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"ShopBalanceViewController"];
            shopBalance.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopBalance animated:YES];
        }else
        {
            UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
            LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginVc.isGoods = true;
            [self.navigationController pushViewController:loginVc animated:YES];
            NSLog(@"请登录");
        }
    
}

// 用户必备
-(void)woDeYaoQinClick   // 我的邀请
{
//    ShopChatViewController *chat = [[ShopChatViewController alloc] init];
//    chat.hidesBottomBarWhenPushed = YES;
//    chat.conversationType = ConversationType_PRIVATE;
//    chat.title = @"测试";
//    [self.navigationController pushViewController:chat animated:YES];
    NSLog(@"我的邀请");
    if (CommonConfig.isLogin)
    {
        MyInviteGenerController *myinviteC = [[MyInviteGenerController alloc] init];
        myinviteC.user_id = CommonConfig.UserInfoCache.userId;
        myinviteC.token = CommonConfig.Token;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myinviteC animated:YES];
          self.hidesBottomBarWhenPushed = NO;
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void)woDeShouYiClick   // 我的收益
{
    NSLog(@"woDeShouYiClick");
    if (CommonConfig.isLogin)
    {
        
//                NSArray *keys = @[@"user_id",@"page"];
//                NSArray *values = @[@(CommonConfig.UserInfoCache.userId),@"1"];
//                [MySDKHelper postAsyncWithURL:@"/v1/get_my_invite_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {

            MyGeneralizeViewController *mygeneralize = [[MyGeneralizeViewController alloc] init];
            mygeneralize.user_id = CommonConfig.UserInfoCache.userId;
            mygeneralize.token = CommonConfig.Token;
            mygeneralize.shouYi = @"1";
            mygeneralize.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mygeneralize animated:YES];
                    
//                } postCancel:^(NSString *error) {
//                    NSLog(@"%@",error);
//        //            [SVProgressHUD dismiss];
//                    [NoticeView showMessage:error];
//
//                }];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}

-(void)tiXianJiLuClick  // 提现
{
    NSLog(@"提现记录");
    if (CommonConfig.isLogin)
    {
        
        MyGeneralizeViewController *mygeneralize = [[MyGeneralizeViewController alloc] init];
        mygeneralize.user_id = CommonConfig.UserInfoCache.userId;
        mygeneralize.token = CommonConfig.Token;
        mygeneralize.shouYi = @"";
        mygeneralize.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mygeneralize animated:YES];

    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void)meiRiQianDaoClick  // 签到
{
    NSLog(@"每日签到");
    if (CommonConfig.isLogin)
    {
        SingInViewController *singIn = [[SingInViewController alloc] init];
        singIn.user_id = CommonConfig.UserInfoCache.userId;
        singIn.token = CommonConfig.Token;
        singIn.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:singIn animated:YES];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void)pingJiaClick   // 激活码激活
{
    NSLog(@"pingJiaClick");
    BecomeAgentsViewController *agents = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"BecomeAgentsViewController"];
    agents.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:agents animated:YES];
}
//  控制器分类方法  隐藏tabbar
//- (void)pushViewController:(nonnull UIViewController *)viewController {
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewController animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//    viewController.hidesBottomBarWhenPushed = YES;
//}

- (void)initIcon
{
    [TBCityIconFont setFontName:@"iconfont"];
    _settlementImg.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e9a8", 30, [UIColor blackColor])];
    _storeManagementImg.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e72a", 30, [UIColor blackColor])];
    _scanCodeOrderImg.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e8cc", 30, [UIColor blackColor])];
    _shoppingCart.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e688", 30, [UIColor blackColor])];
    
    
    _membershipManagement.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e699", 25, [UIColor whiteColor])];
    _membershipManagement.backgroundColor = [UIColor colorWithHexString:@"ea4f2f"];
    
    _QrCodeForCollection.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e67a", 25, [UIColor whiteColor])];
    _QrCodeForCollection.backgroundColor = [UIColor colorWithHexString:@"e8bd4f"];
    
    _shoppingManageImg.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e67f", 25, [UIColor whiteColor])];
    _shoppingManageImg.backgroundColor = [UIColor colorWithHexString:@"4fa9e8"];
    
    _PromotionCenter.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e656", 25, [UIColor whiteColor])];
    _PromotionCenter.backgroundColor = [UIColor colorWithHexString:@"f39e4d"];
//    _treasureChest.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6a1", 25, [UIColor whiteColor])];
//    _treasureChest.backgroundColor = [UIColor colorWithHexString:@"b1c36e"];
    _redEnvelopeSystem.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e7d5", 25, [UIColor whiteColor])];
    _redEnvelopeSystem.backgroundColor = [UIColor colorWithHexString:@"e8bd4f"];
    _cashierManagement.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e69c", 25, [UIColor whiteColor])];
    _cashierManagement.backgroundColor = [UIColor colorWithHexString:@"e63253"];
    
    
    
    _myInvitation.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e68c", 25, [UIColor whiteColor])];
    _myInvitation.backgroundColor = [UIColor colorWithHexString:@"4fe8b4"];
    _myIncome.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e694", 25, [UIColor whiteColor])];
    _myIncome.backgroundColor = [UIColor colorWithHexString:@"e8bd4f"];
    _withdrawalRecord.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e684", 25, [UIColor whiteColor])];
    _withdrawalRecord.backgroundColor = [UIColor colorWithHexString:@"4fa9e8"];
    _dailyCheck.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e679", 25, [UIColor whiteColor])];
    _dailyCheck.backgroundColor = [UIColor colorWithHexString:@"f39e4d"];
    _productEvaluation.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e661", 25, [UIColor whiteColor])];
    _productEvaluation.backgroundColor = [UIColor colorWithHexString:@"a8bb5f"];
}



-(void)setting
{
    NSLog(@"设置");
    if (CommonConfig.isLogin)
    {
//        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//        InfoViewController *info = [stroy instantiateViewControllerWithIdentifier:@"InfoViewController"];
////        info.imgStr = self.userInfoDIc[@"avatar"];
//        info.img = self.userImage.image;
////          if ([self.userInfoDIc[@"avatar"] rangeOfString:@"http"].location != NSNotFound) {
////              info.imgStr = self.userInfoDIc[@"avatar"];
////          }
////          else
////          {
////              info.imgStr = [NSString stringWithFormat:@"%@%@",imgHost,self.userInfoDIc[@"avatar"]];
////          }
////        NSLog(@"%@",[NSString stringWithFormat:@"%@%@",imgHost,self.userInfoDIc[@"avatar"]]);
//        [self.navigationController pushViewController:info animated:YES];
        SettingViewController *setting = [[SettingViewController alloc] init];
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
        
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *login = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
}

-(void)messageClick
{
    NSLog(@"消息");
    if (CommonConfig.isLogin)
    {
//        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//        MessageViewController *messageVC = [stroy instantiateViewControllerWithIdentifier:@"MessageViewController"];
//        messageVC.isShow = false;
//        messageVC.isSystem = false;
//        messageVC.isFirst = false;
//        messageVC.isCollect = false;
//        [self.navigationController pushViewController:messageVC animated:YES];
        MessageListViewController *message = [[MessageListViewController alloc] init];
        message.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:message animated:YES];
    }
    else
    {
        UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        LoginViewController *loginVc = [stroy instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVc.isGoods = true;
        [self.navigationController pushViewController:loginVc animated:YES];
        NSLog(@"请登录");
    }
}

-(void)addGestureRecinizer
{
//    self.money.userInteractionEnabled = YES;
//    UITapGestureRecognizer *money = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myIncomeClick)];
//    [self.money addGestureRecognizer:money];
    
    self.userImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *userIn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfo:)];
    [self.userImage addGestureRecognizer:userIn];
    
    self.userName.userInteractionEnabled = YES;
    UITapGestureRecognizer *user = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfo:)];
    [self.userName addGestureRecognizer:user];
    
    // 结算中心
    self.settlementImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *Tui = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jieSuanZhongXin)];
    [self.settlementImg addGestureRecognizer:Tui];
    
    self.storeManagementImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *shou = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dianPuGuanLi)];
    [self.storeManagementImg addGestureRecognizer:shou];
    
    self.scanCodeOrderImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *saoYiSao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saoYiSaoClick)];
    [self.scanCodeOrderImg addGestureRecognizer:saoYiSao];
    
    self.shoppingCart.userInteractionEnabled = YES;
    UITapGestureRecognizer *yaoQin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yaoQinmaClick)];
    [self.shoppingCart addGestureRecognizer:yaoQin];
    
    // 我的订单
    self.allOrder.userInteractionEnabled = YES;
    UITapGestureRecognizer *daiFu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quanBuDingDan)];
    [self.allOrder addGestureRecognizer:daiFu];
    
    self.waitPay.userInteractionEnabled = YES;
    UITapGestureRecognizer *daiFa = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitPayClick)];
    [self.waitPay addGestureRecognizer:daiFa];
    
    self.waitShipping.userInteractionEnabled = YES;
    UITapGestureRecognizer *daiShou = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitShippingCLick)];
    [self.waitShipping addGestureRecognizer:daiShou];
    
    self.waitReceive.userInteractionEnabled = YES;
    UITapGestureRecognizer *daiPin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitReceiveClick)];
    [self.waitReceive addGestureRecognizer:daiPin];
    
    self.waitAppraise.userInteractionEnabled = YES;
    UITapGestureRecognizer *shouHou = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitAppraiseClick)];
    [self.waitAppraise addGestureRecognizer:shouHou];
    
    // 商家必备
    self.membershipManagement.userInteractionEnabled = YES;
    UITapGestureRecognizer *menmerShip = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huiYuanClick)];
    [self.membershipManagement addGestureRecognizer:menmerShip];
    
    self.QrCodeForCollection.userInteractionEnabled = YES;
    UITapGestureRecognizer *qrCode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouKuanMaClick)];
    [self.QrCodeForCollection addGestureRecognizer:qrCode];
    
    self.shoppingManageImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *myHope = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopManager)];
    [self.shoppingManageImg addGestureRecognizer:myHope];
    
    self.PromotionCenter.userInteractionEnabled = YES;
    UITapGestureRecognizer *quanYi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huiYuanQuanYiClick)];
    [self.PromotionCenter addGestureRecognizer:quanYi];
    
//    self.treasureChest.userInteractionEnabled = YES;
//    UITapGestureRecognizer *shiMin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuiGuangClick)];
//    [self.treasureChest addGestureRecognizer:shiMin];
//    
    self.redEnvelopeSystem.userInteractionEnabled = YES;
    UITapGestureRecognizer *menDian = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redEnvelopeSystemClick)];
    [self.redEnvelopeSystem addGestureRecognizer:menDian];
//
    self.cashierManagement.userInteractionEnabled = YES;
    UITapGestureRecognizer *baoDan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hongBaoClick)];
    [self.cashierManagement addGestureRecognizer:baoDan];
    
    // 用户必备
    self.myInvitation.userInteractionEnabled = YES;
    UITapGestureRecognizer *qianBao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(woDeYaoQinClick)];
    [self.myInvitation addGestureRecognizer:qianBao];
    
    self.myIncome.userInteractionEnabled = YES;
    UITapGestureRecognizer *woDeJiFen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(woDeShouYiClick)];
    [self.myIncome addGestureRecognizer:woDeJiFen];
    
    self.withdrawalRecord.userInteractionEnabled = YES;
    UITapGestureRecognizer *gouWuChe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tiXianJiLuClick)];
    [self.withdrawalRecord addGestureRecognizer:gouWuChe];
    
    self.dailyCheck.userInteractionEnabled = YES;
    UITapGestureRecognizer *keFu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meiRiQianDaoClick)];
    [self.dailyCheck addGestureRecognizer:keFu];
    
    self.productEvaluation.userInteractionEnabled = YES;
    UITapGestureRecognizer *jiLu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pingJiaClick)];
    [self.productEvaluation addGestureRecognizer:jiLu];
    
    
}
-(void)initWithButton
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    view.backgroundColor = [UIColor colorWithHexString:@"e94f37"];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"个人中心";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(ScreenWidth/2 - 60, 25, 120, 30);
    [view addSubview:label];
    
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
    [setting setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e693", 25, [UIColor whiteColor])] forState:UIControlStateNormal];
    [setting addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    [setting sizeToFit];
    //    setting.size = CGSizeMake(25, 25);
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:setting];
    setting.frame = CGRectMake(5, 20, 30, 30);
    [view addSubview:setting];
    
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    [message setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e66f", 25, [UIColor whiteColor])] forState:UIControlStateNormal];
    [message addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    [message sizeToFit];
    //    message.size = CGSizeMake(25, 25);
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:message];
    message.frame = CGRectMake(ScreenWidth - 35, 20, 30, 30);
    [view addSubview:message];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (CommonConfig.isLogin) {
        [self setHeader];
    }
    [self refershInfo];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
