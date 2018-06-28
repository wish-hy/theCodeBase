//
//  PurseRecharge.m
//  huabi
//
//  Created by TeamMac2 on 17/3/27.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "PurseRecharge.h"
#import "Newyuanmeng-Swift.h"

#import "MySDKHelper.h"
#import "RechargeCell.h"
#import "NoticeView.h"
#import "UPAPayViewController.h"

@interface PurseRecharge ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *backBtn;
    UIButton *homeBtn;
    UILabel *title;

}


@property (nonatomic,strong)UITableView *tableV;

@property (nonatomic,strong)NSString *package;

@property (nonatomic,strong)NSString *paymentId;  // 支付方式
@property (nonatomic,strong)NSString *reCharge;   //充值金额
@property (nonatomic,strong)NSString *zengSong;

/** 记录上一次点击的标题按钮 */
@property (nonatomic, weak)UIButton *selectButton;

@property (nonatomic,strong)UIView *titleView;   //headerView

@property (nonatomic,strong)UIView *taocanView;   // 五个按钮

@property (nonatomic,strong)RechargeCell *recharge;

@end

@implementation PurseRecharge


- (void)viewDidLoad {
    self.paymentId = @"29";
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"refreshTableView" object:nil];
    
}

-(void)refreshTableView
{
//    NSLog(@"%@",_reCharge);
    [_tableV reloadData];
}

-(void)getRequest
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    [MySDKHelper postAsyncWithURL:@"/v1/dopay" withParamBodyKey:@[@"user_id",@"payment_id",@"recharge",@"recharge_type",@"package"] withParamBodyValue:@[userId,self.paymentId,_recharge.money.text,@"1",self.package] needToken:token postSucceed:^(NSDictionary *result) {
        NSDictionary *res = [NSDictionary dictionaryWithDictionary:result[@"content"]];
        if ([res[@"payment_id"] intValue] == 29)   // 微信支付
        {
            NSDictionary *info = [NSDictionary dictionaryWithDictionary:res[@"senddata"]];
            [WXPayHelper payForWXPayWithViewController:self withAppid:[NSString stringWithFormat:@"%@",info[@"appid"]] withPartnerid:[NSString stringWithFormat:@"%@",info[@"partnerid"]] withPrepayid:[NSString stringWithFormat:@"%@",info[@"prepayid"]] withPrivateKey:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withTimeStamp:[[NSString stringWithFormat:@"%@",info[@"timestamp"]]intValue] withNonceStr:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withSign:[NSString stringWithFormat:@"%@",info[@"sign"]]];
        }
        else if ([res[@"payment_id"] intValue] == 28)
        {
            NSDictionary *info = [NSDictionary dictionaryWithDictionary:res[@"senddata"]];
            NSLog(@"%@",info);
            NSData * getJsonData = [[NSString stringWithFormat:@"%@",info[@"biz_content"]] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",content);
            //选中商品
            //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
            //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
            //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
            /*============================================================================*/
            /*=======================需要填写商户app申请的===================================*/
            /*============================================================================*/
            //    NSString *appID =
            //    NSString *privateKey = @"";
            /*============================================================================*/
            /*============================================================================*/
            /*============================================================================*/
            
            /*
             *生成订单信息及签名
             */
            //将商品信息赋予AlixPayOrder的成员变量
            Order* order = [Order new];
            
            // NOTE: app_id设置
            order.app_id = [NSString stringWithFormat:@"%@",info[@"app_id"]];
            
            // NOTE: 支付接口名称
            order.method = [NSString stringWithFormat:@"%@",info[@"method"]];
            
            // NOTE: 参数编码格式
            order.charset = [NSString stringWithFormat:@"%@",info[@"charset"]];
            
            // NOTE: 当前时间点
            NSDateFormatter* formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //    order.timestamp = [formatter stringFromDate:[NSDate date]];
            order.timestamp = [NSString stringWithFormat:@"%@",info[@"timestamp"]];
            // NOTE: 支付版本
            order.version = [NSString stringWithFormat:@"%@",info[@"version"]];
            
            // NOTE: sign_type设置
            order.sign_type = [NSString stringWithFormat:@"%@",info[@"sign_type"]];
            
            order.notify_url = [NSString stringWithFormat:@"%@",info[@"notify_url"]];
            
            // NOTE: 商品数据
            order.biz_content = [BizContent new];
            order.biz_content.body = [NSString stringWithFormat:@"%@",content[@"body"]];
            order.biz_content.subject = [NSString stringWithFormat:@"%@",content[@"subject"]];
            order.biz_content.out_trade_no = [NSString stringWithFormat:@"%@",content[@"out_trade_no"]]; //订单ID（由商家自行制定）
            order.biz_content.timeout_express = [NSString stringWithFormat:@"%@",content[@"timeout_express"]]; //超时时间设置
            order.biz_content.total_amount = [NSString stringWithFormat:@"%@",content[@"total_amount"]]; //商品价格
            
            //将商品信息拼接成字符串
//            NSString *orderInfo = [order orderInfoEncoded:NO];
//            NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
            
            // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
            //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
            //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
            //    NSString *signedString = [signer signString:orderInfo];
            NSString *signedString = [NSString stringWithFormat:@"%@",info[@"sign"]];
            // NOTE: 如果加签成功，则继续执行支付
            if (signedString != nil) {
                //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
                //        NSString *appScheme = appScheme;
                
                // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//                NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                         orderInfoEncoded, signedString];
                
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",info[@"builddata"]] fromScheme:AliAppID callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
        }
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}

-(void)creatUI
{
    self.view.backgroundColor = [UIColor grayColor];
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.view addSubview:self.tableV];
    
    UIView *navgation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44 + 20)];
    navgation.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navgation];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 - 40, 25, 80, 25)];
    title.font = [UIFont systemFontOfSize:15];
    [title setTintColor:[UIColor blackColor]];
    title.textAlignment = NSTextAlignmentCenter;
    [title setText:@"充值中心"];
    [self.view addSubview:title];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 25, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"ic_back-1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(ScreenWidth - 40, 25, 25, 25);
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"backbackmain"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    
    [self initWithTableTitle];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    UIButton *recharge = [UIButton buttonWithType:UIButtonTypeCustom];
    recharge.frame = CGRectMake((ScreenWidth - (ScreenWidth - 40))/2.f,20, ScreenWidth - 40, 40);
    [recharge addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    [recharge setTitle:@"立即充值" forState:UIControlStateNormal];
    [recharge setTitle:@"立即充值.." forState:UIControlStateHighlighted];
    [recharge setBackgroundColor:[UIColor colorWithRed:8/255.f green:182/255.f blue:3/255.f alpha:1]];
    [view addSubview:recharge];
    _tableV.tableFooterView = view;
    
}

-(void)initWithTableTitle
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 100, 40)];
    title.text = @"充值套餐";
    [titleView addSubview:title];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
    UIImage *img = [UIImage imageNamed:@"card"];
    imgV.image = img;
    [titleView addSubview:imgV];
    
    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(10, 80, ScreenWidth-10, 1)];
    xian.backgroundColor = [UIColor grayColor];
    [titleView addSubview:xian];
    
    // 五个按钮
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * ScreenWidth/5+5, 100, ScreenWidth/5-10, ScreenWidth/5-10);
        button.tag = 1000 + i;
        NSArray *buttonArray = @ [@"自定义",@"￥套餐一\n 500",@"  套餐二\n 1000",@"  套餐三\n 2000",@"  商家二维码\n3600"];
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;// 居中
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"taocan_bg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"taocan_bg01"] forState:UIControlStateSelected];

        [button addTarget:self action:@selector(titlesViewCurrentSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        if (button.tag == 1000) {
            [self titlesViewCurrentSelectedButton:button];
        }
    }
    
    self.titleView = titleView;
    _tableV.tableHeaderView = self.titleView;
}

/// 显示当前选中按钮
- (void)titlesViewCurrentSelectedButton:(UIButton *)currentSelectedButton{
    
    if (currentSelectedButton != self.selectButton)
    {
        self.selectButton.selected = NO;
        currentSelectedButton.selected = YES;
        self.selectButton = currentSelectedButton;
    }
    else
    {
        self.selectButton.selected = YES;
    }
    
    if (_selectButton.tag == 1000) {
        _package = @"0";
        _reCharge = @"";
        _zengSong = @"0";
    }
    else if (_selectButton.tag == 1001)
    {
        _package = @"1";
        _reCharge = @"1000";
        _zengSong = @"300";
    }
    else if (_selectButton.tag == 1002)
    {
        _package = @"2";
         _reCharge = @"3000";
        _zengSong = @"1050";
    }
    else if (_selectButton.tag == 1003)
    {
        _package = @"3";
         _reCharge = @"5000";
        _zengSong = @"2000";
    }
    else if (_selectButton.tag == 1004)
    {
        _package = @"4";
         _reCharge = @"10000";
        _zengSong = @"4500";
    }
    
    NSDictionary *dict = @{@"package":_package};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil userInfo:dict];
}

//  充值
-(void)recharge
{
    [self getRequest];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}


//-(void)payWithPlatform:(NSString *)row{
//    if ([row integerValue] == wxPay) {
////        NSLog(@"%d",[[NSString stringWithFormat:@"%@",orderInfo[@"timestamp"]]intValue]);
//        NSDictionary *info = [NSDictionary dictionaryWithDictionary:orderInfo[@"senddata"]];
//        [WXPayHelper payForWXPayWithViewController:self withAppid:[NSString stringWithFormat:@"%@",info[@"appid"]] withPartnerid:[NSString stringWithFormat:@"%@",info[@"partnerid"]] withPrepayid:[NSString stringWithFormat:@"%@",info[@"prepayid"]] withPrivateKey:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withTimeStamp:[[NSString stringWithFormat:@"%@",info[@"timestamp"]]intValue] withNonceStr:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withSign:[NSString stringWithFormat:@"%@",info[@"sign"]]];
//
//}


#pragma mark - private method
- (void)contentTextFieldDidEndEditing:(NSNotification *)noti {
    NSLog(@"点击了money");
}

#pragma mark - tableViewDataSours
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 5;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RechargeCell *cell = [RechargeCell creatCell:tableView];
    if (indexPath.row == 1) {
        _recharge = cell;
    }
    // 不高亮显示选中的cell
//    __weak typeof(self) weakSelf = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"充值对象";
        cell.money.text = @"银点";
        cell.money.enabled = NO;
    }
    else if (indexPath.row == 1)
    {
        cell.titleLabel.text = @"充值金额";
        cell.money.enabled = YES;
        cell.next.hidden = YES;
        cell.money.placeholder = @"请输入充值金额";
//        cell.block = ^(NSString *text) {
//            weakSelf.reCharge = text;
        cell.money.text = _reCharge;
//        };
        
    }
    else if (indexPath.row == 2)
    {
        cell.titleLabel.text = @"赠送银点";
        cell.money.text = _zengSong;
        cell.next.hidden = YES;
        cell.money.enabled = NO;
    }
    else if (indexPath.row == 3)
    {
        cell.titleLabel.text = @"支付方式";
        cell.money.text = @"微信支付";
        cell.money.enabled = NO;
    }
    else if (indexPath.row == 4)
    {
        cell.titleLabel.text = @"兑换比率";
        cell.money.text = @"1人民币=1银点";
        cell.next.hidden = YES;
        cell.money.enabled = NO;
    }
    

    return cell;
}


#pragma mark - tableViewDelegate
//4.设置每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if (indexPath.row == 3)
    {
//        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:@"" otherButtonTitles:@"", nil];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


-(void)gotoBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoHome:(UIButton *)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
