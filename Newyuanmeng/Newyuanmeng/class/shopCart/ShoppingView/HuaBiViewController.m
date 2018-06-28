//
//  HuaBiViewController.m
//  huabi
//
//  Created by TeamMac2 on 16/12/14.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "HuaBiViewController.h"
#import "PayTypeCell.h"
#import "HuaBiHeadView.h"
#import "Newyuanmeng-Swift.h"
#import "MySDKHelper.h"
#import "NoticeView.h"

@interface HuaBiViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *payTableView;
    NSInteger rowCount;
    NSMutableArray<NSDictionary *> *headArr;
    NSDictionary *orderInfo;
    UITextField *account;
    NSString *selectType;
    UIView *passView;
    UITextField *passText;
    NSInteger pay_password_open;

}
@end

@implementation HuaBiViewController

-(void)addPasswordView{
    pay_password_open = 0;
    passView = [UIView new];
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
    passTitle.text = @"请输入金点支付密码";
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
//    passText.placeholder = @"请输入金点支付密码";
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
        passText.text = @"";
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
        passText.text = @"";
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    headArr = [[NSMutableArray alloc]initWithObjects:@{@"title":@"订单金额",@"content":[NSString stringWithFormat:@"¥%@",self.price],@"text":@""},@{@"title":@"人民币支付金额",@"content":@"微信支付",@"text":[NSString stringWithFormat:@"%@元",self.otherpayAmount]},@{@"title":@"华点支付金额",@"content":[NSString stringWithFormat:@"%@华点",self.huabipayAmount],@"text":@""},@{@"title":@"商城华点帐号",@"content":self.shophuabiaccount,@"text":@""}, nil];
    orderInfo = [[NSDictionary alloc]init];
    NSLog(@"%@  %@",self.price,self.orderID);
    rowCount = 0;
    selectType = 0;
    [self cellSelectSection:0 reload:NO];
    // Do any additional setup after loading the view.
    [self initSetting];

}

-(void)huabiPay{
    [MySDKHelper postAsyncWithURL:@"/v1/paytype_list" withParamBodyKey:@[@"user_id",@"platform"] withParamBodyValue:@[self.userID,@"ios"] needToken:self.token postSucceed:^(NSDictionary *result) {
        NSLog(@"%@",result);
//        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:result[@"content"]];
        [payTableView reloadData];
    } postCancel:^(NSString *error) {

    }];
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

    UIButton *main = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-44, 20, 44, 44)];
    [main setImage:[UIImage imageNamed:@"index"] forState:UIControlStateNormal];
    [main addTarget:self action:@selector(backMainClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:main];

    [self setTable];
}

-(void)backClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)backMainClick:(UIButton *)sender{

    [(AppDelegate*)[UIApplication sharedApplication].delegate showMainPage];
}


-(void)payClick:(UIButton *)sender{
    if ([account.text isEqualToString:@""]) {
        [NoticeView showMessage:@"请输入帐号"];
        return;
    }
    [MySDKHelper postAsyncWithURL:@"/v1/huabipay" withParamBodyKey:@[@"order_id",@"huabi_account",@"user_id"] withParamBodyValue:@[self.orderID,account.text,self.userID] needToken:self.token postSucceed:^(NSDictionary *result) {
        self.orderID = [NSString stringWithFormat:@"%@",result[@"content"]];
        [self payWithPlatform:selectType];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
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

    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300*ScaleWidth)];
    foot.backgroundColor = HEXCOLOR(0xffffff);
    payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    payTableView.showsVerticalScrollIndicator = NO;
    payTableView.showsHorizontalScrollIndicator = NO;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTableView.bounces = NO;
    payTableView.delegate = self;
    payTableView.dataSource = self;
    payTableView.tag = 0;
    payTableView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:payTableView];
    payTableView.tableFooterView = foot;

    UIButton *pay = [[UIButton alloc]initWithFrame:CGRectMake(80*ScaleWidth, 170*ScaleWidth, ScreenWidth-160*ScaleWidth, 100*ScaleWidth)];
    [pay setTitle:@"确认支付" forState:UIControlStateNormal];
    [pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pay.titleLabel.font = [UIFont systemFontOfSize:30*ScaleWidth];
    pay.backgroundColor = HEXCOLOR(0xff0000);
    [pay addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:pay];

    UILabel *text = [UILabel new];
    text.textColor = HEXCOLOR(0x8a8a8a);
    text.font = [UIFont systemFontOfSize:30*ScaleWidth];
    text.textAlignment = NSTextAlignmentLeft;
    text.text = @"您的华点帐号";
    [foot addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(foot.mas_top).mas_offset(0);
        make.left.mas_equalTo(foot.mas_left).mas_offset(30*ScaleWidth);
        make.height.mas_equalTo(120*ScaleWidth);

    }];

    account = [UITextField new];
    account.textColor = HEXCOLOR(0x8a8a8a);
    account.font = [UIFont systemFontOfSize:30*ScaleWidth];
    account.textAlignment = NSTextAlignmentLeft;
    account.borderStyle = UITextBorderStyleNone;
    account.delegate = self;
    account.placeholder = @"请输入华点支付账号";
    [account setValue:HEXCOLOR(0x8a8a8a) forKeyPath:@"_placeholderLabel.textColor"];
    [account setValue:[UIFont systemFontOfSize:30*ScaleWidth] forKeyPath:@"_placeholderLabel.font"];
    [foot addSubview:account];
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(foot.mas_top).mas_offset(0);
        make.right.mas_equalTo(foot.mas_right).mas_offset(-30*ScaleWidth);
        make.left.mas_equalTo(text.mas_right).mas_offset(30*ScaleWidth);
        make.height.mas_equalTo(120*ScaleWidth);
    }];

    UIView *topline = [UIView new];
    topline.backgroundColor = HEXCOLOR(0xdfdfdf);
    [foot addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(foot);
        make.top.mas_equalTo(account.mas_bottom).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(2*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];

    [self addPasswordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [account resignFirstResponder];
    if (!passView.hidden) {
        [passText resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return headArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return rowCount;
    }
    return 0;
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
    if (indexPath.row == self.dicArr.count - 1 || indexPath.row == 0) {
        cell.line1.hidden = YES;
    }else{
        cell.line1.hidden = NO;
    }
    if (self.dicArr.count != 0) {
        BOOL isupay = NO;
        NSDictionary *dic = self.dicArr[indexPath.row];
        if ([dic[@"id"] integerValue] == self.applePay) {
            isupay = YES;
        }
        [cell setCellTitleWithNumb:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]] content:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]] icon:[NSString stringWithFormat:@"%@",[dic objectForKey:@"icon"]] isUpay:isupay];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cellSelectSection:indexPath.row reload:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return  0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 120*ScaleWidth;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HuaBiHeadView *head = [HuaBiHeadView HeaderViewWithTableView:tableView withIdentifier:@"HuaBiHeadView"];
    head.tag = section;
    head.select.tag = section;
    [head.select addTarget:self action:@selector(headSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    if (section == 0) {
        head.topline.hidden = NO;
    }else{
        head.topline.hidden = YES;
    }
    if (headArr.count != 0) {
        NSDictionary *dic = headArr[section];
        [head setHeadInfo:[NSString stringWithFormat:@"%@",dic[@"title"]] content:[NSString stringWithFormat:@"%@",dic[@"content"]] text:[NSString stringWithFormat:@"%@",dic[@"text"]] section:section];
    }
    return head;
}

-(void)headSelectClick:(UIButton *)sender{
    if (sender.tag == 1) {
        if (rowCount == 0) {
            [self reloadPayTable:self.dicArr.count];
        }
    }else{

    }
}

-(void)reloadPayTable:(NSInteger)count{
    rowCount = count;
    [payTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)cellSelectSection:(NSInteger)section reload:(BOOL)reload{
    NSDictionary *dic = self.dicArr[section];
    selectType = [NSString stringWithFormat:@"%@",dic[@"id"]];
    [self reloadHeadInfo:[NSString stringWithFormat:@"%@",dic[@"title"]] text:[NSString stringWithFormat:@"%@元",self.otherpayAmount] section:section];
    if (reload) {
        [self reloadPayTable:0];
//        [payTableView reloadData];
    }
}

-(void)reloadHeadInfo:(NSString *)content text:(NSString *)text section:(NSInteger)section
{

    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithDictionary:headArr[1]];
    if (![content isEqualToString:@""]) {
        [data setObject:content forKey:@"content"];
    }
    if (![text isEqualToString:@""]) {
        [data setObject:text forKey:@"text"];
    }
    [headArr removeObjectAtIndex:1];
    [headArr insertObject:data atIndex:1];
}

-(void)dopayWithRow:(NSString *)row{
    [MySDKHelper postAsyncWithURL:@"/v1/dopay" withParamBodyKey:@[@"order_id",@"payment_id",@"user_id"] withParamBodyValue:@[self.orderID,row,self.userID] needToken:self.token postSucceed:^(NSDictionary *result) {
        orderInfo = [[NSDictionary alloc]initWithDictionary:[result objectForKey:@"content"]];

        [self payWithPlatform:row];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}

-(void)payWithPlatform:(NSString *)row{
    if ([row integerValue] == self.wxPay) {
        NSLog(@"%d",[[NSString stringWithFormat:@"%@",orderInfo[@"timestamp"]]intValue]);
        NSDictionary *info = [NSDictionary dictionaryWithDictionary:orderInfo[@"senddata"]];
        [WXPayHelper payForWXPayWithViewController:self withAppid:[NSString stringWithFormat:@"%@",info[@"appid"]] withPartnerid:[NSString stringWithFormat:@"%@",info[@"partnerid"]] withPrepayid:[NSString stringWithFormat:@"%@",info[@"prepayid"]] withPrivateKey:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withTimeStamp:[[NSString stringWithFormat:@"%@",info[@"timestamp"]]intValue] withNonceStr:[NSString stringWithFormat:@"%@",info[@"noncestr"]] withSign:[NSString stringWithFormat:@"%@",info[@"sign"]]];
    }else if ([row integerValue] == self.alipay){
        [self doAlipayPay];
    }else if ([row integerValue] == self.jindianPay){
        [self CheckPayVerify];
    }else if ([row integerValue] == self.applePay){

    }
}


-(void)doAlipayPay{
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
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

