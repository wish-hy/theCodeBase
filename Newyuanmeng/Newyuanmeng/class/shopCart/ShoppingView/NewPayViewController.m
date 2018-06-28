//
//  NewPayViewController.m
//  huabi
//
//  Created by 刘桐林 on 2017/1/10.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "NewPayViewController.h"
#import "Newyuanmeng-Swift.h"
#import "MySDKHelper.h"
#import "NoticeView.h"
#import "NewPayCell.h"
#import "NewPayHeadView.h"
#import "NewPayImageCell.h"
#import "IntegralOrderDetailController.h"



@interface NewPayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UITableView *payTableView;
    NSInteger rowCount;
    float rate;
    NSArray <NSString *>*titleArr;
    NSDictionary *orderInfo;
    UITextField *account;
    NSInteger selectType;//发票类型
    NSString *addressName;
    NSString *address;
    NSInteger addressID;
    NSString *freight;
    NSString *goodPrice;
    NSString *mobile;
    UIButton *pay;
    UILabel *allPrice;
    UILabel *goodsCount;
    UILabel *goodsPrice;
    UILabel *addressNameLbl;
    UILabel *addressLbl;
    UILabel *mobilelbl;
    UICollectionView *goodsCollection;
    NSMutableArray <NSString *>*imgs;
    NSMutableDictionary *orderIdsNew;
    UIView *chooseView;
    UIButton *btn1;
    
    NSInteger paymentid;    //支付方式id
    NSString *isinvoice;    //是否需要发票 0不需要 1需要
    NSString *voucher;   //优惠券id
    NSString *promid;     //订单优惠
    NSString *userremark; //用户留言
    
}
@end

@implementation NewPayViewController

-(void)getGoodsData
{
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    orderIdsNew = [[NSMutableDictionary alloc]init];
    if (self.isGoods) {
        keys = @[@"cart_type",@"user_id"];
        values = @[@"goods",@(self.userID)];
    }else{
        keys = @[@"selectids",@"user_id"];
        values = @[self.orderids,@(self.userID)];
    }
    [MySDKHelper postAsyncWithURL:@"/v1/order_confirm" withParamBodyKey:keys withParamBodyValue:values needToken:self.accessToken postSucceed:^(NSDictionary *result) {
//        NSLog(@"%@",result);
        orderInfo = [[NSDictionary alloc]initWithDictionary:result[@"content"]];
        [self setInfoWithData];
    } postCancel:^(NSString *error) {
        [NoticeView showMessage:error];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color_white;
    titleArr = [[NSArray alloc]init];
    orderInfo = [[NSDictionary alloc]init];
    imgs = [[NSMutableArray alloc]init];
    titleArr = @[@"配送费",@"发票信息",@"支付方式"];
    rowCount = 0;
    rate = 0;
    selectType = 0;
    address = @"";
    addressName = @"";
    addressID = 0;
    mobile = @"";
    isinvoice = @"0";
    paymentid = 35;
    voucher = @"";
    promid = @"";
    userremark = @"";
    goodPrice = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderAddress:) name:@"orderAddress" object:nil];
    
    [self initSetting];
    [self getGoodsData];
}

-(void)setInfoWithData
{
    NSInteger row = 0;
    NSArray *addresslist = [[NSArray alloc]initWithArray:orderInfo[@"addresslist"]];
    for (int i = 0; i < addresslist.count; i++) {
        if ([addresslist[i][@"is_default"]integerValue] == 1) {
            row = i;
            break;
        }
    }
    if (addresslist.count > 0) {
        addressID = [addresslist[row][@"id"]integerValue];
        addressName = [NSString stringWithFormat:@"%@",addresslist[row][@"accept_name"]];
        address = [NSString stringWithFormat:@"%@\n%@",addresslist[row][@"address"],addresslist[row][@"addr"]];
        mobile = [NSString stringWithFormat:@"%@",addresslist[row][@"mobile"]];
        mobilelbl.text = mobile;
        //        if (mobile.length > 9) {
        //            mobilelbl.text = [NSString stringWithFormat:@"%@******%@",[mobile substringToIndex:3],[mobile substringFromIndex:9]];
        //        }else{
        //            if ([mobile isEqualToString:@"(null)"] || [mobile isEqualToString:@""] ) {
        //                mobile = @"";
        //            }
        //            if (mobile.length > 4) {
        //                mobilelbl.text = [NSString stringWithFormat:@"%@****",[mobile substringToIndex:(mobile.length - 4)]];
        //            }
        //        }
        if (![addressName isEqualToString:@""]) {
            addressNameLbl.text = addressName;
        }else{
            addressNameLbl.text = @"暂无收货人";
            mobilelbl.text = @"";
        }
        if (![address isEqualToString:@""]) {
            addressLbl.text = address;
        }else{
            addressLbl.text = @"请添加地址！";
        }
    }
    NSInteger count = 0;
    CGFloat price = 0.0;
    CGFloat goodsweight = 0.0;
    if (self.isGoods){
        NSDictionary *cartInfo = orderInfo[@"cartlist"][self.goodsID];
        CGFloat wig = [cartInfo[@"weight"] integerValue];
        count = count + [cartInfo[@"num"] integerValue];
        [imgs addObject:[NSString stringWithFormat:@"%@", cartInfo[@"img"]]];
        price = price + [cartInfo[@"real_price"] floatValue];
        goodsweight = goodsweight + count*wig;
        [orderIdsNew setValue:cartInfo[@"num"] forKey:[NSString  stringWithFormat:@"%@",cartInfo[@"id"]]];
    }else{
        NSArray *cartlist = [[NSArray alloc]initWithArray:orderInfo[@"cartlist"]];
        for (int i = 0; i<cartlist.count; i++) {
            CGFloat wig = [cartlist[i][@"weight"] integerValue];
            count = count + [cartlist[i][@"num"] integerValue];
            [imgs addObject:[NSString stringWithFormat:@"%@", cartlist[i][@"img"]]];
            price = price + [cartlist[i][@"real_price"] floatValue];
            goodsweight = goodsweight + count*wig;
            [orderIdsNew setValue:cartlist[i][@"num"] forKey:[NSString  stringWithFormat:@"%@",cartlist[i][@"id"]]];
        }
    }
    rate = [orderInfo[@"tax"] integerValue] / 100.0;
    NSLog(@"所需现金%f,%f",_cash,_point);
 if ([_isIntegral isEqualToString:@"YES"]) {
        
        goodsPrice.text = [NSString stringWithFormat:@"¥%.2f+%.2f积分",_cash,_point];
    }else{
        if (_point > 0) {
            goodsPrice.text = [NSString stringWithFormat:@"¥%.2f+%.2f积分",_cash,_point];
        }else{
            goodsPrice.text = [NSString stringWithFormat:@"¥%.2f",price];
        }
        
    }
    goodPrice = [NSString stringWithFormat:@"%.2f", price];
    allPrice.text = [NSString stringWithFormat:@"¥%@",goodPrice];
    goodsCount.text = [NSString stringWithFormat:@"共%ld件",(long)count];
    [goodsCollection  reloadData];
    [MySDKHelper postAsyncWithURL:@"/v1/order_calculate_fare" withParamBodyKey:@[@"id",@"weight",@"product",@"user_id"] withParamBodyValue:@[@(addressID),@(goodsweight),orderIdsNew,@(self.userID)] needToken:self.accessToken postSucceed:^(NSDictionary *result) {
        freight = [NSString stringWithFormat:@"¥%.2f",[result[@"content"][@"fee"] floatValue]];
        goodPrice = [NSString stringWithFormat:@"%.2f",[result[@"content"][@"fee"] floatValue]+price];
	if ([_isIntegral isEqualToString:@"YES"]) {
            allPrice.text = [NSString stringWithFormat:@"¥%.2f",_cash];
        }else{
            if (_point > 0) {
                allPrice.text = [NSString stringWithFormat:@"¥%.2f",_cash];
            }else{
                allPrice.text = [NSString stringWithFormat:@"¥%@",goodPrice];
            }
            
        }
        [payTableView reloadData];
    } postCancel:^(NSString *error) {
        
    }];
}

-(void)refreshOrderAddress:(NSNotification *)notification
{
    NSDictionary *info = notification.object;
    addressID = [info[@"id"] integerValue];
    addressName = info[@"accept_name"];
    mobile = info[@"mobile"];
    address =  [NSString stringWithFormat:@"%@\n%@", info[@"address"], info[@"addr"]];
    mobilelbl.text = mobile;
    if (![addressName isEqualToString:@""]) {
        addressNameLbl.text = addressName;
    }else{
        addressNameLbl.text = @"暂无收货人";
        mobilelbl.text = @"";
    }
    if (![address isEqualToString:@""]) {
        addressLbl.text = address;
    }else{
        addressLbl.text = @"请添加地址！";
    }
}


- (void)initSetting{
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    title.textColor = [UIColor blackColor];
    title.text = @"确认订单";
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
    
    UIView *topline = [UIView new];
    topline.backgroundColor = HEXCOLOR(0xdfdfdf);
    [self.view addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(64);
        make.height.mas_equalTo(2*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self setTable];
}

-(void)backClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)backMainClick:(UIButton *)sender{
    [(AppDelegate*)[UIApplication sharedApplication].delegate showMainPage];
}


-(void)payClick:(UIButton *)sender{
    if ([isinvoice  isEqual: @"1"] && [account.text isEqualToString:@""]) {
        [NoticeView showMessage:@"请输入发票抬头"];
        return;
    }
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    NSMutableArray *values = [[NSMutableArray alloc]init];
    [keys addObject:@"user_id"];
    [values addObject:@(self.userID)];
    [keys addObject:@"address_id"];
    [values addObject:@(addressID)];
    [keys addObject:@"payment_id"];
    [values addObject:@(paymentid)];
    if (self.isGoods ){
        [keys addObject:@"cart_type"];
        [values addObject:@"goods"];
    }else{
        [keys addObject:@"selectids"];
        [values addObject:self.orderids];
    }
    [keys addObject:@"is_invoice"];
    [values addObject:isinvoice];
    if(![voucher  isEqual: @""]){
        [keys addObject:@"voucher"];
        [values addObject:voucher];
    }
    if(![promid  isEqual: @""]){
        [keys addObject:@"prom_id"];
        [values addObject:promid];
    }
    if(![userremark  isEqual: @""]){
        [keys addObject:@"user_remark"];
        [values addObject:userremark];
    }
    if([isinvoice  isEqual: @"1"]){
        [keys addObject:@"invoice_type"];
        [values addObject:[NSString stringWithFormat:@"%ld", (long)selectType]];
    }
    if([isinvoice  isEqual: @"1"]){
        [keys addObject:@"invoice_title"];
        [values addObject:account.text];
    }
    //  积分购买
    if ([_isIntegral isEqualToString:@"YES"] || _point > 0)
    {
                // userDefaults中取数据
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        //    NSString *token = [userDefaults objectForKey:@"token"];
        
            NSArray *key1 = [[NSArray alloc]init];
            NSArray *value1 = [[NSArray alloc]init];
            key1 = @[@"user_id",@"page",@"type"];
            value1 = @[user_id,@"1",@"out"];

            [MySDKHelper postAsyncWithURL:@"/v1/huabi" withParamBodyKey:key1 withParamBodyValue:value1 needToken:self.accessToken postSucceed:^(NSDictionary *result) {
        //        //        NSLog(@"%@",result);
                NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:result[@"content"][@"customer"]];
                float userPoint_coin = [dic[@"point_coin"] floatValue];
                
                
                if (userPoint_coin < self.point)
                {
                    
                    [NoticeView showMessage:@"积分不足"];
                }
                else
                {
                    NSString *type = @"";
                    if (_isQiangGou) {
                        type = @"pointflash";
                    }else{
                        type = @"pointbuy";
                    }
                    
                    [keys addObject:@"type"];
                    [values addObject:type];
                    [keys addObject:@"id"];
                    [values addObject: self.shoppingID];
                    [keys addObject:@"product_id"];
                    [values addObject:@[self.goodsID]];
                    
                    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"确定支付" message:@"确认支付直接扣除积分购买" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertCtr addAction:[UIAlertAction actionWithTitle:@"确定支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                       
                        [MySDKHelper postAsyncWithURL:@"/v1/order_submit" withParamBodyKey:keys withParamBodyValue:values needToken:self.accessToken postSucceed:^(NSDictionary *result) {
                            NSLog(@"积分购！！%@",result);
                            UPAPayViewController *payControl = [UPAPayViewController alloc];
                            payControl.price = [allPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
                            payControl.orderID = result[@"content"];
                            payControl.userID = [NSString stringWithFormat:@"%ld", (long)self.userID];
                            payControl.token = self.accessToken;
                            payControl.chongzhi = NO;
                            payControl.bePromoter = NO;
                            [self.navigationController pushViewController:payControl animated:YES];
                        } postCancel:^(NSString *error) {
                            NSLog(@"错误提示！ %@",error);
                            [NoticeView showMessage:error];
                        }];
                    }]];
                    
                    [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                    
                    [self presentViewController:alertCtr animated:YES completion:nil];
                }
            } postCancel:^(NSString *error) {
                [NoticeView showMessage:error];
            }];
    }
    else
    {    // 普通购买
    
            [keys addObject:@"type"];
            [values addObject:@"order"];
            [keys addObject:@"product_id"];
            [values addObject:self.goodsID];
        
        [MySDKHelper postAsyncWithURL:@"/v1/order_submit" withParamBodyKey:keys withParamBodyValue:values needToken:self.accessToken postSucceed:^(NSDictionary *result) {
                    NSLog(@"普通购买** %@",result);
            UPAPayViewController *payControl = [UPAPayViewController alloc];
            payControl.price = [allPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
            payControl.orderID = result[@"content"];
            payControl.userID = [NSString stringWithFormat:@"%ld", (long)self.userID];
            payControl.token = self.accessToken;
            payControl.chongzhi = NO;
            payControl.bePromoter = NO;
            [self.navigationController pushViewController:payControl animated:YES];
            
        } postCancel:^(NSString *error) {
            [NoticeView showMessage:error];
        }];
    }
}


-(void)chooseAddress:(UIButton *)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    AddressViewController *controller = [story instantiateViewControllerWithIdentifier:@"AddressViewController"];
    controller.isGoods = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)setTable{
    
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, (184+168)*ScaleWidth)];
    foot.backgroundColor = HEXCOLOR(0xffffff);
    payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-50) style:UITableViewStylePlain];
    payTableView.showsVerticalScrollIndicator = NO;
    payTableView.showsHorizontalScrollIndicator = NO;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTableView.bounces = NO;
    payTableView.delegate = self;
    payTableView.dataSource = self;
    payTableView.tag = 0;
    payTableView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:payTableView];
    payTableView.tableHeaderView = foot;
    
    UILabel *buyer = [UILabel new];
    buyer.textColor = HEXCOLOR(0x8a8a8a);
    buyer.font = [UIFont systemFontOfSize:13];
    buyer.textAlignment = NSTextAlignmentLeft;
    buyer.text = @"收货人  ";
    [foot addSubview:buyer];
    [buyer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(foot.mas_top).mas_offset(29*ScaleWidth);
        make.left.mas_equalTo(foot.mas_left).mas_offset(42*ScaleWidth);
        make.width.mas_equalTo(120*ScaleWidth);
        
    }];
    
    mobilelbl = [UILabel new];
    mobilelbl.textColor = HEXCOLOR(0x303030);
    mobilelbl.font = [UIFont systemFontOfSize:15];
    mobilelbl.textAlignment = NSTextAlignmentRight;
    mobilelbl.text = @"";
    [foot addSubview:mobilelbl];
    [mobilelbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(buyer);
        make.right.mas_equalTo(foot.mas_right).mas_offset(-36*ScaleWidth);
        
    }];

    addressNameLbl = [UILabel new];
    addressNameLbl.textColor = HEXCOLOR(0x303030);
    addressNameLbl.font = [UIFont systemFontOfSize:15];
    addressNameLbl.textAlignment = NSTextAlignmentLeft;
    addressNameLbl.text = @"暂无收货人";
    [foot addSubview:addressNameLbl];
    [addressNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(buyer);
        make.left.mas_equalTo(buyer.mas_right).mas_offset(0*ScaleWidth);
        
    }];
    
    addressLbl = [UILabel new];
    addressLbl.textColor = HEXCOLOR(0x8a8a8a);
    addressLbl.font = [UIFont systemFontOfSize:13];
    addressLbl.textAlignment = NSTextAlignmentLeft;
    addressLbl.text = @"请添加地址！";
    addressLbl.numberOfLines = 0;
    [foot addSubview:addressLbl];
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressNameLbl.mas_bottom).mas_offset(34*ScaleWidth);
        make.left.mas_equalTo(buyer.mas_left).mas_offset(0*ScaleWidth);
        make.right.mas_equalTo(foot.mas_right).mas_offset(-100*ScaleWidth);
    }];
    
    goodsPrice = [UILabel new];
    goodsPrice.textColor = HEXCOLOR(0xff0000);
    goodsPrice.font = [UIFont systemFontOfSize:13];
    goodsPrice.textAlignment = NSTextAlignmentRight;
    goodsPrice.text = @"¥0.00";
    [foot addSubview:goodsPrice];
    [goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(foot.mas_top).mas_offset(230*ScaleWidth);
        make.right.mas_equalTo(foot.mas_right).mas_offset(-100*ScaleWidth);
        
    }];
    
    goodsCount = [UILabel new];
    goodsCount.textColor = HEXCOLOR(0x303030);
    goodsCount.font = [UIFont systemFontOfSize:13];
    goodsCount.textAlignment = NSTextAlignmentRight;
    goodsCount.text = @"共0件";
    goodsCount.numberOfLines = 0;
    [foot addSubview:goodsCount];
    [goodsCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodsPrice.mas_bottom).mas_offset(16*ScaleWidth);
        make.right.mas_equalTo(foot.mas_right).mas_offset(-100*ScaleWidth);
    }];
    
    UIImageView *icons = [UIImageView new];
    [icons setImage:[UIImage imageNamed:@"c213"]];
    [foot addSubview:icons];
    
    UIButton *chooseAddr = [UIButton new];
    [chooseAddr addTarget:self action:@selector(chooseAddress:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:chooseAddr];
    [chooseAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.mas_equalTo(foot);
        make.top.mas_equalTo(foot.mas_top).mas_offset(0);
        make.height.mas_equalTo(184*ScaleWidth);
    }];
    
    [icons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(foot.mas_right).mas_offset(-36*ScaleWidth);
        make.centerY.mas_equalTo(addressLbl);
        make.width.mas_equalTo(16*ScaleWidth);
        make.height.mas_equalTo(16*ScaleWidth);
    }];
    
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //定义每个UICollectionView 的大小
    layout.itemSize = CGSizeMake(100*ScaleWidth, ScaleWidth*100);
    //定义每个UICollectionView 横向的间距
    layout.minimumLineSpacing = 22*ScaleWidth;
    //定义每个UICollectionView 纵向的间距
    layout.minimumInteritemSpacing = 0*ScaleWidth;
    layout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;

    goodsCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 220*ScaleWidth, ScreenWidth-300*ScaleWidth, 100*ScaleWidth) collectionViewLayout:layout];
    goodsCollection.tag = 0;
    goodsCollection.scrollEnabled = YES;
    goodsCollection.bounces = YES;
    goodsCollection.backgroundColor = [UIColor clearColor];
    goodsCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    goodsCollection.dataSource = self;
    goodsCollection.delegate = self;
    goodsCollection.showsVerticalScrollIndicator = NO;
    goodsCollection.showsHorizontalScrollIndicator = NO;
    goodsCollection.layer.masksToBounds = NO;
    [goodsCollection registerClass:[NewPayImageCell class] forCellWithReuseIdentifier:@"NewPayImageCell"];
    [foot addSubview:goodsCollection];

	  //查看订单详情
    UIButton *seeOrder = [UIButton new];
    [seeOrder addTarget:self action:@selector(seeOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:seeOrder];
    [seeOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.mas_equalTo(foot);
        make.width.mas_equalTo(foot);
        make.top.mas_equalTo(chooseAddr.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(168*ScaleWidth);
    }];
    
    
    pay = [UIButton new];
    [pay setTitle:@"立即下单" forState:UIControlStateNormal];
    [pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pay.titleLabel.font = [UIFont systemFontOfSize:15];
    pay.backgroundColor = HEXCOLOR(0xff0000);
    [pay addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pay];
    [pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        make.width.mas_equalTo(145);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *text = [UILabel new];
    text.textColor = HEXCOLOR(0x8a8a8a);
    text.font = [UIFont systemFontOfSize:13];
    text.textAlignment = NSTextAlignmentLeft;
    text.text = @"合计: ";
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(22*ScaleWidth);
        make.height.mas_equalTo(50);
        
    }];
    
    allPrice = [UILabel new];
    allPrice.textColor = HEXCOLOR(0xff0000);
    allPrice.font = [UIFont systemFontOfSize:13];
    allPrice.textAlignment = NSTextAlignmentLeft;
    allPrice.text = @"¥0.00";
    [self.view addSubview:allPrice];
    [allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(text.mas_right).mas_offset(0);
        make.height.mas_equalTo(50);
        
    }];

    UIView *topline = [UIView new];
    topline.backgroundColor = HEXCOLOR(0xdfdfdf);
    [self.view addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(pay.mas_top).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(2*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    chooseView = [UIView new];
    chooseView.backgroundColor = color_clear;
    chooseView.layer.masksToBounds = YES;
    [self.view addSubview:chooseView];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.height.mas_equalTo(self.view);
    }];
    
    btn1 = [UIButton new];
    [btn1 setTitle:@"个人" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    btn1.backgroundColor = HEXCOLOR(0x303030);
    [btn1 addTarget:self action:@selector(choosePayType:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 0;
    [chooseView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(chooseView.mas_right).mas_offset(0);
        make.top.mas_equalTo(chooseView.mas_top).mas_offset(64+(184+168+120+80+80+80)*ScaleWidth);
        make.width.mas_equalTo(130*ScaleWidth);
        make.height.mas_equalTo(80*ScaleWidth);
    }];
    
    UIView *btnline = [UIView new];
    btnline.backgroundColor = HEXCOLOR(0xdfdfdf);
    [chooseView addSubview:btnline];
    [btnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(btn1.mas_bottom).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(2*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitle:@"公司" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    btn2.backgroundColor = HEXCOLOR(0xff0000);
    [btn2 addTarget:self action:@selector(choosePayType:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 1;
    [chooseView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(chooseView.mas_right).mas_offset(0);
        make.top.mas_equalTo(btn1.mas_bottom).mas_offset(0*ScaleWidth);
        make.width.mas_equalTo(130*ScaleWidth);
        make.height.mas_equalTo(80*ScaleWidth);
    }];
    chooseView.hidden = YES;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
//查看订单详情
- (void)seeOrderAction:(UIButton *)btn{
    
    IntegralOrderDetailController *orderVC = [[IntegralOrderDetailController alloc] init];
    NSDictionary *cartInfo = orderInfo[@"cartlist"][self.goodsID];
    if ([_isIntegral isEqualToString:@"YES"]) {
        NSString *price = [NSString stringWithFormat:@"¥%.2f+%.2f积分",_cash,_point];
        [orderVC setGoodsName:cartInfo[@"name"] withGoodsImg:cartInfo[@"img"] withGoodsNum:cartInfo[@"num"] withPrice:price];
    }else{
        [orderVC setGoodsName:cartInfo[@"name"] withGoodsImg:cartInfo[@"img"] withGoodsNum:cartInfo[@"num"] withPrice:cartInfo[@"price"]];
    }
    [self.navigationController pushViewController:orderVC animated:YES];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    CGFloat height = keyboardRect.size.height;
    //获取动画时间
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        payTableView.contentOffset = CGPointMake(0, (186+168+80+80)*ScaleWidth);

    } completion:^(BOOL finished) {

    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    //获取动画时间
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        payTableView.contentOffset = CGPointMake(0, 0);
    }  completion:^(BOOL finished) {

    }];
}


-(void)choosePayType:(UIButton *)sender
{
    selectType = sender.tag;
    chooseView.hidden = YES;
    [payTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!chooseView.hidden) {
        chooseView.hidden = YES;
    }
    if ([account isEditing]) {
        [account resignFirstResponder];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArr.count;
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
    return  80*ScaleWidth;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPayCell"];
    if (cell == nil) {
        cell = [[NewPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewPayCell"];
    }
    cell.tag = indexPath.row;
    if (indexPath.row == 0) {
        cell.cellTitle.text = @"税率";
        cell.cellIcon.hidden = YES;
        cell.cellcontent.hidden = NO;
        cell.cellcontent.text = [NSString stringWithFormat:@"%.2f%@",(rate*100), @"%"];
        cell.cellInvoice.hidden = YES;
        cell.celltext.hidden = YES;
    }else if (indexPath.row == 1) {
        cell.cellTitle.text = @"发票类型";
        cell.cellIcon.hidden = NO;
        cell.cellcontent.hidden = YES;
        cell.cellInvoice.hidden = NO;
        cell.celltext.hidden = YES;
        if (selectType == 0) {
            [cell reset:@"个人"];
        }else{
            [cell reset:@"公司"];
        }
        cell.singleClick = ^(NSInteger tag){
            chooseView.hidden = NO;
            [btn1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(chooseView.mas_top).mas_offset(64+(184+168+120+80+80+80)*ScaleWidth-payTableView.contentOffset.y);
            }];
        };
    }else if (indexPath.row == 2) {
        cell.cellTitle.text = @"发票抬头";
        cell.cellIcon.hidden = YES;
        cell.cellcontent.hidden = YES;
        cell.cellInvoice.hidden = YES;
        cell.celltext.hidden = NO;
        account = cell.celltext;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return  0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 120*ScaleWidth;
    }
    return 80*ScaleWidth;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NewPayHeadView *head = [NewPayHeadView HeaderViewWithTableView:tableView withIdentifier:[NSString stringWithFormat:@"NewPayHeadView %ld",(long)section]];
    head.tag = section;
    if (section == 0) {
        head.switchs.hidden = YES;
        head.headcontent.hidden = NO;
        head.headTitle.text = @"配送费";
        head.headcontent.textColor = HEXCOLOR(0x303030);
        head.headcontent.text = freight;
    }else if (section == 1) {
        head.switchs.hidden = NO;
        head.headcontent.hidden = YES;
        head.headTitle.text = @"发票信息";
        head.singleClick = ^(BOOL isOn){
            if (isOn) {
                rowCount = 3;
                isinvoice = @"1";
                float goodsPrices = [goodPrice floatValue];
                float totalPrice = (rate+1) * goodsPrices;
                allPrice.text = [NSString stringWithFormat:@"¥%.2f",totalPrice];
            }else{
                rowCount = 0;
                isinvoice = @"0";
                allPrice.text = [NSString stringWithFormat:@"¥%@",goodPrice];
            }
            [payTableView reloadData];
        };
    }else if (section == 2) {
        head.switchs.hidden = YES;
        head.headcontent.hidden = NO;
        head.headTitle.text = @"支付方式";
        head.headcontent.textColor = HEXCOLOR(0xff0000);
        head.headcontent.text = @"在线支付";
    }
   
    return head;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imgs.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(100*ScaleWidth, 100*ScaleWidth);
    return  size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(0, 30*ScaleWidth, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"NewPayImageCell";
//    NSLog(@"cellForItemAtIndexPath %ld %l(long)d %@",collectionView.tag,indexPath.section,cellID);
    
    NewPayImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.tag = indexPath.row;
    if (indexPath.row < imgs.count) {
        [cell.icon setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[MySDKHelper getFullImageURL:imgs[indexPath.row]]]]]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"么么么么木 %ld(long) %ld",collectionView.tag,indexPath.section);

}

@end
