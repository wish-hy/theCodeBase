//
//  ChoosePayMents.m
//  huabi
//
//  Created by hy on 2018/1/16.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "ChoosePayMents.h"
#import "ChoosePayMentCell.h"
#import "Newyuanmeng-Swift.h"
#import "PaySuccessViewController.h"

@implementation ChoosePayMents

+ (instancetype)creatChoosePayMentView{
    {
        return [[[NSBundle mainBundle] loadNibNamed:@"ChoosePayMents" owner:self options:nil] firstObject];
    }
}

-(void)layoutSubviews
{
    _choosePayMentTableVIew.delegate = self;
    _choosePayMentTableVIew.dataSource = self;
    self.info = [NSMutableArray array];
    [self getPaymentID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccesss:) name:@"AlipaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpaySuccesss) name:@"wxpaySuccess" object:nil];
    [self.closeButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e692", 20, [UIColor blackColor])] forState:UIControlStateNormal];
    [self addPasswordView];
}

-(void)getPaymentID{
    NSString *type = @"";
    if (_isRedBag) {
        type = @"redbag";
    }else{
        type = @"offline";
    }
    [MySDKHelper postAsyncWithURL:@"/v1/paytype_list" withParamBodyKey:@[@"user_id",@"platform",@"type"] withParamBodyValue:@[@(CommonConfig.UserInfoCache.userId),@"ios",type] needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSMutableArray *list = result[@"content"][@"paytypelist"];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (int i = 0; i < list.count; i++)
        {
            NSMutableDictionary *di = list[i];
            
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
            else{
                [dic setObject:di[@"pay_name"] forKey:@"title"];  // 其他
                [dic setObject:di[@"logo"] forKey:@"icon"];
                [dic setObject:di[@"description"] forKey:@"content"];
            }
            [dataArr addObject:dic];
            
        }
        self.info = dataArr;
        [_choosePayMentTableVIew reloadData];
    } postCancel:^(NSString *error) {
    }];
}


- (IBAction)doPay:(id)sender {
    if (!_payment_id) {
        [NoticeView showMessage:@"请选择支付方式"];
    }
    if (_isRedBag) {
        [_redBagKeys addObject:@"payment_id"];
        [_redBagValues addObject:_payment_id];
        [MySDKHelper postAsyncWithURL:@"/v1/redbag_make" withParamBodyKey:_redBagKeys withParamBodyValue:_redBagValues needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            NSDictionary *Payinfo = result[@"content"];
            _Payinfo = Payinfo;
//            NSString *order_id = Payinfo[@"order_id"];
            
            if ([_payment_id isEqualToString:@"17"]) {
                [self doAlipayPay];
            }
            else if([_payment_id isEqualToString:@"18"])
            {
                NSDictionary *info = [NSDictionary dictionaryWithDictionary:_Payinfo[@"senddata"]];
                [WXPayHelper payForWXPayWithViewController:self withAppid:[NSString stringWithFormat:@"%@",info[@"appid"]] withPartnerid:[NSString stringWithFormat:@"%@",info[@"partnerid"]] withPrepayid:[NSString stringWithFormat:@"%@",info[@"prepayid"]] withPrivateKey:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withTimeStamp:[[NSString stringWithFormat:@"%@",info[@"timestamp"]]intValue] withNonceStr:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withSign:[NSString stringWithFormat:@"%@",info[@"sign"]]];
            }
            else if ([_payment_id isEqualToString:@"5"])
            {
                [self CheckPayVerify];
            }
            else{
                [NoticeView showMessage:@"支付方式不存在"];
            }
            
            
        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [NoticeView showMessage:error];
        }];
        
    }
    else
    {
        if ([_money isEqualToString:@""]) {
            [NoticeView showMessage:@"请输入支付金额"];
            return;
        }
        
        
        NSArray *keys = @[@"user_id",@"payment_id",@"order_amount",@"seller_id"];
        NSArray *values = @[@(CommonConfig.UserInfoCache.userId),_payment_id,_money,_sell_id];
        [MySDKHelper postAsyncWithURL:@"/v1/dopays" withParamBodyKey:keys withParamBodyValue:values needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
            NSDictionary *Payinfo = result[@"content"];
            _Payinfo = Payinfo;
//            NSString *order_id = Payinfo[@"order_id"];
            
            if ([_payment_id isEqualToString:@"17"]) {
                [self doAlipayPay];
            }
            else if([_payment_id isEqualToString:@"18"])
            {
                NSDictionary *info = [NSDictionary dictionaryWithDictionary:_Payinfo[@"senddata"]];
                [WXPayHelper payForWXPayWithViewController:self withAppid:[NSString stringWithFormat:@"%@",info[@"appid"]] withPartnerid:[NSString stringWithFormat:@"%@",info[@"partnerid"]] withPrepayid:[NSString stringWithFormat:@"%@",info[@"prepayid"]] withPrivateKey:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withTimeStamp:[[NSString stringWithFormat:@"%@",info[@"timestamp"]]intValue] withNonceStr:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withSign:[NSString stringWithFormat:@"%@",info[@"sign"]]];
                
            }
            else{
                [NoticeView showMessage:@"支付方式不存在"];
            }
            
            
        } postCancel:^(NSString *error) {
            NSLog(@"%@",error);
            [NoticeView showMessage:error];
        }];
    }
}

// 余额支付
-(void)CheckPayVerify{
    [MySDKHelper postAsyncWithURL:@"/v1/check_verify" withParamBodyKey:@[@"user_id"] withParamBodyValue:@[@(CommonConfig.UserInfoCache.userId)] needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        NSDictionary *info = [[NSDictionary alloc]initWithDictionary:[result objectForKey:@"content"]];
        pay_password_open = [[NSString stringWithFormat:@"%@",info[@"pay_password_open"]] integerValue];
        if (pay_password_open != 1) {
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
    NSDictionary *info = [NSDictionary dictionaryWithDictionary:_Payinfo[@"senddata"]];
    [MySDKHelper postAsyncWithURL:@"/v1/pay_balance" withParamBodyKey:@[@"user_id",@"total_fee",@"order_no",@"pay_password"] withParamBodyValue:@[@(CommonConfig.UserInfoCache.userId),[NSString stringWithFormat:@"%@",info[@"total_fee"]],[NSString stringWithFormat:@"%@",info[@"order_no"]],passText.text] needToken:CommonConfig.Token postSucceed:^(NSDictionary *result) {
        [NoticeView showMessage:@"支付成功"];
        passText.text = @"";
        
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
        
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
        passText.text = @"";
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _info.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicArr = _info[indexPath.row];
    ChoosePayMentCell *cell = [ChoosePayMentCell creatCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payMentName.text = dicArr[@"title"];
    [cell.payMentIcon setImage:[UIImage imageNamed:dicArr[@"icon"]]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentCell.isSelect.selected = NO;
    NSDictionary *dicArr = _info[indexPath.row];
    ChoosePayMentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.currentCell = cell;
    
    if (cell.isSelect.selected == YES) {
        cell.isSelect.selected = NO;
    }else{
        cell.isSelect.selected = YES;
    }
    _payment_id = dicArr[@"id"];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

- (IBAction)closeButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeChooseView" object:nil];
    [self removeFromSuperview];
}


-(void)doAlipayPay{   //支付宝支付
    NSDictionary *info = [NSDictionary dictionaryWithDictionary:_Payinfo[@"senddata"]];
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
            
            NSLog(@"线下支付支付宝调用 %@",resultDic);
            
            
        }];
    }
}


-(void)wxpaySuccesss
{
    if ([_money isEqualToString:@""] || _money == nil || _Payinfo.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付结果" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alt = [UIAlertAction actionWithTitle:@"支付成功" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
        }];
        [alert addAction:alt];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        PaySuccessViewController *paySuccess = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySuccessViewController"];
        paySuccess.price = _money;
        paySuccess.order_id = _Payinfo[@"order_id"];
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:paySuccess animated:YES completion:nil];
    }
    
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
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    else if ([info[@"resultStatus"] isEqual: @"4000"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付信息" message:@"支付失败" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alert addAction:cancelAction];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    else if ([info[@"resultStatus"] isEqual: @"9000"])
    {
        if ([_money isEqualToString:@""] || _money == nil || _Payinfo.count == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付结果" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alt = [UIAlertAction actionWithTitle:@"支付成功" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
            }];
            [alert addAction:alt];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            PaySuccessViewController *paySuccess = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySuccessViewController"];
            paySuccess.price = _money;
            paySuccess.order_id = _Payinfo[@"order_id"];
            
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:paySuccess animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付信息" message:@"支付结果未知，请查询订单信息" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alert addAction:cancelAction];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}
-(void)addPasswordView{
    
    pay_password_open = 0;
    passView = [UIView new];
    passView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(self);
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
    passTitle.text = @"请输入余额支付密码";
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
    passText.layer.masksToBounds = YES;
    passText.placeholder = @"请输入余额支付密码";
    passText.layer.borderColor = HEXCOLOR(0xdfdfdf).CGColor;
    passText.layer.borderWidth= 2*ScaleWidth;
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
-(void)closeClick:(UIButton *)sender{
    [passText resignFirstResponder];
    passView.hidden = YES;
    passText.text = @"";
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
