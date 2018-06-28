//
//  VillagePayViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/29.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "VillagePayViewController.h"
#import "VillageIcon.h"

@interface VillagePayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,weak)UITableView *tableV;
@property(nonatomic,weak)NSString *payMethod;
@property(nonatomic,weak)UIButton *submitBtn;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *detailArr;
@property(nonatomic,strong)NSArray *iconArr;
//支付方式
@property(nonatomic,copy)NSString *payment_id;
@property(nonatomic,strong)NSDictionary *orderInfo;;
//记录支付方式
@property(nonatomic,assign)NSInteger payM;

@end

@implementation VillagePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    //创建导航栏
    [self createNavigationView];
    
    _orderInfo = [[NSDictionary alloc] init];
    _payment_id = [NSString string];
    _payM = 1;
}

//#pragma mark - 支付代码
//-(void)getPaymentID:(NSInteger)row{
//    // 23 22 26 27     1 17 15 10
//    [MySDKHelper postAsyncWithURL:@"/v1/paytype_list" withParamBodyKey:@[@"user_id",@"token",@"platform",@"type"] withParamBodyValue:@[@(_user_id),_token,@"ios",@"district"] needToken:_token postSucceed:^(NSDictionary *result) {
//        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:result[@"content"]];
//        NSMutableArray<NSDictionary *> *list = [dic mutableArrayValueForKey:@"paytypelist"];
//        NSDictionary *dic2 = [[NSDictionary alloc] initWithDictionary:list[row]];
//        _payment_id = dic2[@"id"];
//        [self dopayWithRow:row];
//    } postCancel:^(NSString *error) {
//
//    }];
//}
//-(void)dopayWithRow:(NSInteger)row{
//    NSArray<NSString *>*keys = [[NSArray alloc]init];
//    NSArray *values = [[NSArray alloc]init];
//    keys = @[@"user_id",@"token",@"apply_id",@"payment_id"];
//    values = @[@(_user_id),_token,_district_id,_payment_id];
//
//    [MySDKHelper postAsyncWithURL:@"/v1/pay_district" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//        _orderInfo = [[NSDictionary alloc]initWithDictionary:[result objectForKey:@"content"]];
//        [self payWithPlatform:row];
//    } postCancel:^(NSString *error) {
////        [NoticeView showMessage:error];
//    }];
//}
//-(void)payWithPlatform:(NSInteger)row{
//    if (row == 1) {
////        NSLog(@"%d",[[NSString stringWithFormat:@"%@",orderInfo[@"timestamp"]]intValue]);
//        NSDictionary *info = [NSDictionary dictionaryWithDictionary:_orderInfo[@"senddata"]];
//        [WXPayHelper payForWXPayWithViewController:self withAppid:[NSString stringWithFormat:@"%@",info[@"appid"]] withPartnerid:[NSString stringWithFormat:@"%@",info[@"partnerid"]] withPrepayid:[NSString stringWithFormat:@"%@",info[@"prepayid"]] withPrivateKey:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withTimeStamp:[[NSString stringWithFormat:@"%@",info[@"timestamp"]]intValue] withNonceStr:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withSign:[NSString stringWithFormat:@"%@",info[@"sign"]]];
//    }else if (row == 0){
//       
//        [self doAlipayPay];
//    }
//}

-(void)doAlipayPay{
    NSDictionary *info = [NSDictionary dictionaryWithDictionary:_orderInfo[@"senddata"]];
    NSData * getJsonData = [[NSString stringWithFormat:@"%@",info[@"biz_content"]] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:nil];
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
//    NSString *orderInfo = [order orderInfoEncoded:NO];
//    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    
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
//        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",info[@"builddata"]] fromScheme:AliAppID callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}


#pragma mark - 创建视图
- (void)setName:(NSString *)name{
    
    _name = name;
    _titleArr = @[
                  @[@"专区名称",@"入驻资金",@"支付方式"],
//                  @[@"银联支付",@"微信支付",@"支付宝支付"]
                  @[@"微信支付",@"支付宝支付"]
                  ];
    _detailArr = @[
                   @[name,@"10000元",_titleArr[1][0]],
//                   @[@"银联在线支付",@"微信APP支付",@"支付宝APP支付"],
                   @[@"微信APP支付",@"支付宝APP支付"]
                   ];
    _iconArr = @[
//                    @[icon_village_pay3,icon_village_pay2,icon_village_pay1],
//                    @[@"#cb97d7",@"#9cc96a",@"#fcc101"]
                 @[icon_village_pay2,icon_village_pay1],
                 @[@"#9cc96a",@"#fcc101"]
                ];
    //创建视图
    _isFirst = YES;
    [self createView];
    
}
- (void)createView{
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, ScreenWidth, 120) style:UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableV.rowHeight = 40;
    [self.view addSubview:tableV];
    self.tableV = tableV;
    
    //确认
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 50)];
    payButton.center = CGPointMake(ScreenWidth/2,tableV.frame.origin.y+tableV.frame.size.height+50);
    payButton.backgroundColor = [UIColor colorWithRed:118/255.0 green:202/255.0 blue:39/255.0 alpha:1];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    payButton.layer.cornerRadius = 8;
    [payButton addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    self.submitBtn = payButton;
    
}

#pragma mark - UITableViewDelegate方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.isFirst) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        NSArray *arr = _titleArr[1];
        return arr.count;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell = nil;
    if (cell == nil) {
        //第一组
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            
        }else if(indexPath.section == 1){//第二组
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
            cell.imageView.layer.cornerRadius = 2;
            cell.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(_iconArr[0][indexPath.row], 30, [UIColor colorWithHexString:_iconArr[1][indexPath.row]])];
            
        }
        cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.text = self.detailArr[indexPath.section][indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.section == 1) {
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        if (indexPath.section == 0 && indexPath.row == 2) {
            
            if (_payMethod == nil) {
                cell.detailTextLabel.text = self.detailArr[indexPath.section][indexPath.row];
            }else{
                cell.detailTextLabel.text = _payMethod;
            }
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        _isFirst = !_isFirst;

        CGRect frame1 = CGRectMake(0, 74, ScreenWidth, 120);
        NSArray *coun = self.titleArr[1];
        CGRect frame2 = CGRectMake(0, 74, ScreenWidth, 120+coun.count*40);
        self.tableV.frame = _isFirst?frame1:frame2;
        self.submitBtn.center = CGPointMake(ScreenWidth/2,_tableV.frame.origin.y+_tableV.frame.size.height+50);
        [self.tableV reloadData];
     }
    
    if (indexPath.section == 1) {
        
        _isFirst = !_isFirst;
        
        CGRect frame1 = CGRectMake(0, 74, ScreenWidth, 120);
        NSArray *coun = self.titleArr[1];
        CGRect frame2 = CGRectMake(0, 74, ScreenWidth, 120+coun.count*40);
        self.tableV.frame = _isFirst?frame1:frame2;
        self.submitBtn.center = CGPointMake(ScreenWidth/2,_tableV.frame.origin.y+_tableV.frame.size.height+50);
        _payMethod = self.titleArr[indexPath.section][indexPath.row];
        [self.tableV reloadData];
        
        //获取支付方式id
        if (indexPath.row == 0) {
            _payM = 1;
        }else{
            _payM = 0;
        }

    }
}

//组间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
    title.text = @"专区支付 ";
    [navView addSubview:title];
    
}
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - 按钮事件
//- (void)payButtonAction:(UIButton *)btn{
//
//    //调用支付事件
//    [self getPaymentID:_payM];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
