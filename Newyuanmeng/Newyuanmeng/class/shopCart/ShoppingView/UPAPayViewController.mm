//
//  UPAPayViewController.m
//  huabi
//
//  Created by TeamMac2 on 16/9/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "UPAPayViewController.h"
#import "PayTypeCell.h"
#import "MyManager.h"
#import "HuaBiViewController.h"
#import "NoticeView.h"
#import <UMSocialCore/UMSocialCore.h>

@interface UPAPayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *payTableView;
    NSMutableArray<NSDictionary *> *dicArr;
    NSDictionary *orderInfo;
    UIView *passView;
    UITextField *passText;
    NSInteger pay_password_open;
    NSInteger alipay;
    NSInteger wxPay;
    NSInteger jindianPay;
    NSInteger huadianPay;
    NSInteger applePay;
    NSInteger Unionpay;
    NSInteger balance;
    
}
@end

@implementation UPAPayViewController


-(void)getPaymentID{
    // 23 22 26 27     1 17 15 10
    NSString *type = @"";
        if (self.chongzhi)
        {
            type = @"recharge";
        }else{
            type = @"order";
        }
    
    [MySDKHelper postAsyncWithURL:@"/v1/paytype_list" withParamBodyKey:@[@"user_id",@"platform",@"type"] withParamBodyValue:@[self.userID,@"ios",type] needToken:_token postSucceed:^(NSDictionary *result) {
            NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:result[@"content"]];
            NSMutableArray<NSDictionary *> *list = [dic mutableArrayValueForKey:@"paytypelist"];

            for (int i = 0; i < list.count; i++)
            {
                NSMutableDictionary *di = [[NSMutableDictionary alloc] initWithDictionary:list[i]];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                [dic setObject:di[@"id"] forKey:@"id"];
                [dic setObject:di[@"description"] forKey:@"content"];
                if ([di[@"class_name"] isEqualToString:@"alipayapp"]){
                    [dic setObject:@"支付宝支付" forKey:@"title"];   // 支付宝支付名称
                    [dic setObject:@"zhifubao" forKey:@"icon"];
                    
                        if ([di[@"description"] isKindOfClass:[NSNull class]]) {
                            [dic setObject:@"支付宝支付" forKey:@"content"];
                        }
                    
                }
                else if ([di[@"class_name"] isEqualToString:@"wxpayapp"]){
                    [dic setObject:@"微信支付" forKey:@"title"];   //  微信支付名称
                     [dic setObject:@"weixin2" forKey:@"icon"];
                    
                        if ([di[@"description"] isKindOfClass:[NSNull class]])
                        {
                            [dic setObject:@"微信支付" forKey:@"content"];
                        }
                    
                }
                else if ([di[@"class_name"] isEqualToString:@"unionpayapp"])  //银联支付
                {
                    [dic setObject:@"银联支付" forKey:@"title"];
                    [dic setObject:@"yinlian" forKey:@"icon"];
                        if ([di[@"description"] isKindOfClass:[NSNull class]])
                        {
                            [dic setObject:@"银联支付" forKey:@"content"];
                        }
                }
                else if ([di[@"class_name"] isEqualToString:@"balance"])  //余额支付
                {
                    [dic setObject:@"余额支付" forKey:@"title"];
                    [dic setObject:@"card" forKey:@"icon"];
                    if ([di[@"description"] isKindOfClass:[NSNull class]])
                    {
                        [dic setObject:@"余额支付" forKey:@"content"];
                    }
                }
                else{
                    [dic setObject:di[@"pay_name"] forKey:@"title"];  // 其他
                    [dic setObject:di[@"logo"] forKey:@"icon"];
                    [dic setObject:di[@"description"] forKey:@"content"];
                }
                [dicArr addObject:dic];
            }
            
            [payTableView reloadData];
        } postCancel:^(NSString *error) {
        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pay_password_open = 0;
    alipay = 17;
    Unionpay = 15;
    wxPay = 18;
    huadianPay = 0;
    applePay = 0;
    jindianPay = 35;
    balance = 5;
    dicArr = [NSMutableArray array];
    orderInfo = [[NSDictionary alloc]init];
    [MyManager sharedMyManager].accessToken = self.token;
    [self getPaymentID];
    [self initSetting];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccesss:) name:@"AlipaySuccess" object:nil];
}

- (void)initSetting{
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    title.textColor = [UIColor blackColor];
    title.text = @"在线支付";
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [back setImage:[UIImage imageNamed:@"ic_back-1"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    [self setTable];
}

-(void)backClick:(UIButton *)sender{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    [self.navigationController popViewControllerAnimated:true];
}

-(void)cancelClick:(UIButton *)sender{
    passView.hidden = YES;
    passText.text = @"";
    [NoticeView showMessage:@"取消支付"];
}

-(void)sureClick:(UIButton *)sender{

   passView.hidden = YES;
    [self payBalance];
}

-(void)closeClick:(UIButton *)sender{
    [passText resignFirstResponder];
    passView.hidden = YES;
    passText.text = @"";
}

-(void)setTable{
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80*ScaleWidth)];
    payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    payTableView.showsVerticalScrollIndicator = NO;
    payTableView.showsHorizontalScrollIndicator = NO;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTableView.bounces = NO;
    payTableView.delegate = self;
    payTableView.dataSource = self;
    payTableView.tag = 0;
    payTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payTableView];
    payTableView.tableHeaderView = head;
    
    UILabel *headTitle = [UILabel new];
    headTitle.textColor = [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    headTitle.font = [UIFont systemFontOfSize:28*ScaleWidth];
    headTitle.text = @"订单金额";
    if (self.chongzhi) {
        headTitle.text = @"充值金额";
    }
    headTitle.textColor = [UIColor blackColor];
    headTitle.textAlignment = NSTextAlignmentLeft;
    [head addSubview:headTitle];
    [headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(head.mas_left).mas_offset(23*ScaleWidth);
        make.centerY.mas_equalTo(head);
        
    }];
    
    UILabel *headPrice = [UILabel new];
    headPrice.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    headPrice.font = [UIFont systemFontOfSize:30*ScaleWidth];
    headPrice.text = [NSString stringWithFormat:@"%@元",self.price];
    headPrice.textAlignment = NSTextAlignmentRight;
    [head addSubview:headPrice];
    [headPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(head.mas_right).mas_offset(-22*ScaleWidth);
        make.centerY.mas_equalTo(head);
        
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [head addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(head.mas_top).mas_offset(0);
        make.centerX.mas_equalTo(head);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [head addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(head.mas_bottom).mas_offset(0);
        make.centerX.mas_equalTo(head);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(ScreenWidth);
    }];
    [self addPasswordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"dicArr count %ld",(unsigned long)dicArr.count);
    return dicArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  110*ScaleWidth;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeCell"];
    if (cell == nil) {
        cell = [[PayTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayTypeCell"];
    }
    cell.tag = indexPath.row;
    if (indexPath.row != dicArr.count - 1) {
        cell.line1.hidden = YES;
    }else{
        cell.line1.hidden = NO;
    }
    if (dicArr.count != 0) {
        BOOL isupay = NO;
        NSDictionary *dic = dicArr[indexPath.row];
//        if ([dic[@"id"] integerValue] == applePay) {
//            isupay = YES;
//        }
        [cell setCellTitleWithNumb:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]] content:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]] icon:[NSString stringWithFormat:@"%@",[dic objectForKey:@"icon"]] isUpay:isupay];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = dicArr[indexPath.row];
    if ([[NSString stringWithFormat:@"%@",dic[@"id"]] integerValue] == huadianPay){
        [self huabiCheck];
    }else{
        NSLog(@"非华币支付");
        [self dopayWithRow:[NSString stringWithFormat:@"%@",dic[@"id"]]];
        NSLog(@"支付方式id  %@",[NSString stringWithFormat:@"%@",dic[@"id"]]);
    }
}

-(void)huabiCheck{
    NSMutableArray<NSDictionary *> *news = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dicArr) {
        if ([[NSString stringWithFormat:@"%@",dic[@"id"]] integerValue] != huadianPay){
            [news addObject:dic];

        }
    }
    NSLog(@"%@",news);
    [MySDKHelper postAsyncWithURL:@"/v1/huabipay_info" withParamBodyKey:@[@"order_id",@"user_id"] withParamBodyValue:@[self.orderID,self.userID] needToken:[MyManager sharedMyManager].accessToken postSucceed:^(NSDictionary *result) {
        NSDictionary *info = [[NSDictionary alloc]initWithDictionary:[result objectForKey:@"content"]];
        HuaBiViewController *huabi = [[HuaBiViewController alloc]init];
        huabi.userID = self.userID;
        huabi.orderID = self.orderID;
        huabi.price = self.price;
        huabi.alipay = alipay;
        huabi.wxPay = wxPay;
        huabi.applePay = applePay;
        huabi.jindianPay = jindianPay;
        huabi.huadianPay = huadianPay;
        huabi.dicArr = news;
        huabi.huabipayAmount = [NSString stringWithFormat:@"%@",info[@"huabipay_amount"]];
        huabi.otherpayAmount = [NSString stringWithFormat:@"%@",info[@"otherpay_amount"]];
        huabi.shophuabiaccount = [NSString stringWithFormat:@"%@",info[@"shop_huabi_account"]];
        [self.navigationController pushViewController:huabi animated:YES];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}

-(void)dopayWithRow:(NSString *)row{
    NSArray *keys = [NSArray array];
    NSMutableArray *values = [NSMutableArray array];
    if (self.chongzhi) {
//        if (self.taocanchongzhi) {
//            if (self.recommend == nil) {
        NSString *package = [NSString stringWithFormat:@"%ld",_package];
        NSLog(@"  row:%@,   userID:%@,   token:%@,     充值金额:%@,    充值套餐:%ld",row,self.userID,self.token,self.price,self.package);
        
        keys = @[@"payment_id",@"user_id",@"recharge",@"package",@"base_rate"];
        [values addObject:row];
        [values addObject:_userID];
        [values addObject:_price];
        [values addObject:package];
        [values addObject:_base_rate];
//        values = @[row,_userID,_price,package,_base_rate];

    }else if(self.bePromoter){
        keys = @[@"user_id",@"token",@"payment_id",@"gift",@"address_id",@"reference",@"invitor_role"];
        values = [@[_userID,_token,row,_pInfo[@"gift"],_pInfo[@"address_id"],_pInfo[@"reference"],_pInfo[@"invitor_role"]]mutableCopy];
    }else{
        keys = @[@"order_id",@"payment_id",@"user_id"];
        values = [@[self.orderID,row,self.userID]mutableCopy];
    }
    
    
//    if (!self.bePromoter) {
//        //购买接口
        [MySDKHelper postAsyncWithURL:@"/v1/dopay" withParamBodyKey:keys withParamBodyValue:values needToken:[MyManager sharedMyManager].accessToken postSucceed:^(NSDictionary *result) {
            orderInfo = [[NSDictionary alloc]initWithDictionary:[result objectForKey:@"content"]];
            
            NSLog(@"row == %@",row);
            [self payWithPlatform:row];
        } postCancel:^(NSString *error) {
            NSLog(@"支付方式未接入");
            [NoticeView showMessage:error];
        }];
//    }else{//专区支付接口
//        NSLog(@"进来");
//
//        [MySDKHelper postAsyncWithURL:@"/v1/pay_district" withParamBodyKey:keys withParamBodyValue:values needToken:[MyManager sharedMyManager].accessToken postSucceed:^(NSDictionary *result) {
//            orderInfo = [[NSDictionary alloc]initWithDictionary:[result objectForKey:@"content"]];
//
//            [self payWithPlatform:row];
//        } postCancel:^(NSString *error) {
//            [NoticeView showMessage:error];
//        }];

//    }

}

-(void)payWithPlatform:(NSString *)row{
    if ([row integerValue] == wxPay) {
        NSDictionary *info = [NSDictionary dictionaryWithDictionary:orderInfo[@"senddata"]];
      [WXPayHelper payForWXPayWithViewController:self withAppid:[NSString stringWithFormat:@"%@",info[@"appid"]] withPartnerid:[NSString stringWithFormat:@"%@",info[@"partnerid"]] withPrepayid:[NSString stringWithFormat:@"%@",info[@"prepayid"]] withPrivateKey:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withTimeStamp:[[NSString stringWithFormat:@"%@",info[@"timestamp"]]intValue] withNonceStr:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withSign:[NSString stringWithFormat:@"%@",info[@"sign"]]];
        
    }else if ([row integerValue] == alipay){
        [self doAlipayPay];
    }else if ([row integerValue] == Unionpay){
        [self UnionpayMent];
    }else if ([row integerValue] == balance)
    {
        [self CheckPayVerify];
    }
    else{
        [NoticeView showMessage:@"支付方式不存在"];
    }
//        else if ([row integerValue] == applePay){
//
//    }
}

// 余额支付
-(void)CheckPayVerify{
    [MySDKHelper postAsyncWithURL:@"/v1/check_verify" withParamBodyKey:@[@"user_id"] withParamBodyValue:@[self.userID] needToken:self.token postSucceed:^(NSDictionary *result) {
        NSDictionary *info = [[NSDictionary alloc]initWithDictionary:[result objectForKey:@"content"]];
        pay_password_open = [[NSString stringWithFormat:@"%@",info[@"pay_password_open"]] integerValue];
        if (pay_password_open == 0) {
            [self payBalance];
        }else{
            passText.text = @"";
            passView.hidden = NO;
        }
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}

-(void)payBalance{
    NSDictionary *info = [NSDictionary dictionaryWithDictionary:orderInfo[@"senddata"]];
    [MySDKHelper postAsyncWithURL:@"/v1/pay_balance" withParamBodyKey:@[@"user_id",@"total_fee",@"order_no",@"pay_password"] withParamBodyValue:@[self.userID,[NSString stringWithFormat:@"%@",info[@"total_fee"]],[NSString stringWithFormat:@"%@",info[@"order_no"]],passText.text] needToken:self.token postSucceed:^(NSDictionary *result) {
        [NoticeView showMessage:@"支付成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        passText.text = @"";
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
        passText.text = @"";
    }];
}

-(void)UnionpayMent
{
    [NoticeView showMessage: @"支付方式待接入"];
}



-(void)doAlipayPay{   //支付宝支付
    NSDictionary *info = [NSDictionary dictionaryWithDictionary:orderInfo[@"senddata"]];
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
            [NoticeView showMessage:resultDic[@"memo"]];
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

-(void)addPasswordView{
    
    passView = [[UIView alloc] init];
    passView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.mas_equalTo(self.view);
    }];
    UIButton *close = [UIButton new];
    [close addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [passView addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(passView);
        make.width.height.mas_equalTo(passView);
    }];
    
    UIView *back = [UIView new];
    back.backgroundColor = [UIColor whiteColor];
    [passView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(passView);
        make.height.mas_equalTo(300*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth-200*ScaleWidth);
    }];
    
    UILabel *passTitle = [UILabel new];
    passTitle.textColor = HEXCOLOR(0x303030);
    passTitle.text = @"请输入支付密码";
    passTitle.font = [UIFont systemFontOfSize:32*ScaleWidth];
    passTitle.textAlignment = NSTextAlignmentCenter;
    [back addSubview:passTitle];
    [passTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(back);
        make.width.mas_equalTo(back);
        make.top.mas_equalTo(back.mas_top).mas_offset(40*ScaleWidth);
        
    }];
    
    passText = [UITextField new];
    passText.textColor = HEXCOLOR(0x8a8a8a);
    passText.font = [UIFont systemFontOfSize:30*ScaleWidth];
    passText.textAlignment = NSTextAlignmentLeft;
    passText.borderStyle = UITextBorderStyleRoundedRect;
    passText.delegate = self;
    passText.layer.cornerRadius = 10*ScaleWidth;
    passText.layer.borderWidth= 2*ScaleWidth;
    passText.layer.borderColor = HEXCOLOR(0xdfdfdf).CGColor;
    passText.layer.masksToBounds = YES;
    //    passText.placeholder = @"请输入金点支付密码";
    [passText setValue:HEXCOLOR(0x8a8a8a) forKeyPath:@"_placeholderLabel.textColor"];
    [passText setValue:[UIFont systemFontOfSize:30*ScaleWidth] forKeyPath:@"_placeholderLabel.font"];
    [back addSubview:passText];
    [passText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passTitle.mas_bottom).mas_offset(40*ScaleWidth);
        make.right.mas_equalTo(back.mas_right).mas_offset(-60*ScaleWidth);
        make.left.mas_equalTo(back.mas_left).mas_offset(60*ScaleWidth);
        make.height.mas_equalTo(80*ScaleWidth);
    }];
    
    UIButton *cancel = [UIButton new];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:HEXCOLOR(0x303030) forState:UIControlStateNormal];
    [cancel setTitleColor:HEXCOLOR(0xffa200) forState:UIControlStateHighlighted];
    cancel.titleLabel.font = [UIFont systemFontOfSize:32*ScaleWidth];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(back.mas_bottom).mas_offset(0*ScaleWidth);
        make.left.mas_equalTo(back.mas_left).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(80*ScaleWidth);
        make.width.mas_equalTo((ScreenWidth - 202*ScaleWidth)/2.0);
    }];
    
    UIButton *sure = [UIButton new];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:HEXCOLOR(0x303030) forState:UIControlStateNormal];
    [sure setTitleColor:HEXCOLOR(0xffa200) forState:UIControlStateHighlighted];
    sure.titleLabel.font = [UIFont systemFontOfSize:32*ScaleWidth];
    [sure addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(back.mas_bottom).mas_offset(0*ScaleWidth);
        make.right.mas_equalTo(back.mas_right).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(80*ScaleWidth);
        make.width.mas_equalTo((ScreenWidth - 202*ScaleWidth)/2.0);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = HEXCOLOR(0xefefef);
    [back addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sure.mas_top).mas_offset(-2*ScaleWidth);
        make.centerX.mas_equalTo(back);
        make.width.mas_equalTo(back);
        make.height.mas_equalTo(2*ScaleWidth);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = HEXCOLOR(0xefefef);
    [back addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sure.mas_top).mas_offset(0*ScaleWidth);
        make.centerX.mas_equalTo(back);
        make.width.mas_equalTo(2*ScaleWidth);
        make.bottom.mas_equalTo(sure.mas_bottom).mas_offset(0*ScaleWidth);
    }];
    
    passView.hidden = YES;
}

//AlipaySuccess
-(void)paySuccesss:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSLog(@"%@",info);
    
    if ([info[@"resultStatus"] isEqual: @"6001"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付信息" message:@"用户已取消" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([info[@"resultStatus"] isEqual: @"4000"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付信息" message:@"支付失败" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([info[@"resultStatus"] isEqual: @"9000"])
    {
//        PaySuccessViewController *paySuccess = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySuccessViewController"];
//        paySuccess.price = _money;
//        paySuccess.order_id = _Payinfo[@"order_id"];
//
//        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//        [root presentViewController:paySuccess animated:YES completion:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付信息" message:@"支付成功" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付信息" message:@"支付结果未知，请查询订单信息" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!passView.hidden) {
        [passText resignFirstResponder];
    }
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
