//
//  ExampleVillageViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/28.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ExampleVillageViewController.h"
#import "VillageIcon.h"
#import "TBCityIconFont.h"

#import "DrawMoneyViewController.h"
#import "GeneralizeViewController.h"
#import "SaleViewController.h"
#import "OperatorViewController.h"
#import "PerfermenceViewController.h"
#import "PromoterCodeController.h"

@interface ExampleVillageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UIView *btnView;
@property(nonatomic,weak)UIScrollView *scrollV;

@end

@implementation ExampleVillageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建导航栏
    [self createNavigationView];
    
    //创建视图
    [self createView];
    
}

#pragma mark - 创建视图
- (void)createView{
    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 230/2)];
//    imageV.image = [UIImage imageNamed:@"xiaoqu_bg"];
//    [self.view addSubview:imageV];
    
    //按钮背景
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 44)];
//    btnView.backgroundColor = [UIColor colorWithRed:118/255.0 green:203/255.0 blue:39/255.0 alpha:1];
    btnView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:btnView];
    self.btnView = btnView;
    
    //按钮
    CGFloat width = ScreenWidth/3;
    CGFloat height = 76/2;
    NSArray *btnTitle = @[@"专区管理",@"专区收益",@"专区记录"];
    for (int i = 0; i < btnTitle.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 6, width, height)];
        btn.tag = 1000 + i;
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateSelected];
        
        [btn setTitleColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:236/255.0 green:90/255.0 blue:63/255.0 alpha:1]] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 2;
        [btn addTarget:self action:@selector(btnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
        
        if (i == 0) {
            
            btn.selected = YES;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    
    //创建滑动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, btnView.frame.origin.y+btnView.frame.size.height, ScreenWidth, ScreenHeight-159)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(btnTitle.count*ScreenWidth, ScreenHeight-159);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    self.scrollV = scrollView;
    //添加第一页内容
    [self addFirstPageContentView];
    //添加第二页内容
    [self addSecondPageContentView];
    //添加第三页内容
    [self addThreePageContentView];
}
#pragma mark 颜色转换为图片

- (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

//添加内容
- (void)addThreePageContentView{
    
    //第三页
    CGFloat btnWidth = ScreenWidth*0.12;//0.12是按钮在屏幕的比例,所有小数都是屏幕适配需要
    CGFloat spaceWidth = ScreenWidth*0.17;
    NSArray *titleArr = @[@"销售记录",@"收益记录",@"提现记录"];
    NSArray *iconArr = @[icon_village_sale,icon_village_eanerings,icon_village_withDraw];
    NSArray *bgColorArr = @[@"#3F92EC",@"#EC963F",@"#9FE02F"];
    for (int i = 0; i < titleArr.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(2*ScreenWidth+ScreenWidth*0.14+(i*btnWidth)+(i*spaceWidth), ScreenHeight*0.072, btnWidth, btnWidth)];
            
        btn.layer.cornerRadius = btnWidth/2;
        btn.tag = 3000 + i;
        [setButtonIcon setButtonIcon:btn withText:iconArr[i] withSize:btnWidth/2 withColor:[UIColor whiteColor] withBgColor:[UIColor colorWithHexString:bgColorArr[i]]];
        [btn addTarget:self action:@selector(threePageAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollV addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, ScreenHeight*0.068)];
        label.center = CGPointMake(btn.center.x, btn.center.y+btn.frame.size.height/2+20);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.text = titleArr[i];
        [self.scrollV addSubview:label];
    }

    
}
- (void)addSecondPageContentView{
    
    //第二页
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.203)];
    headerView.backgroundColor = [UIColor whiteColor];
    //测试数据
    NSArray *priceArr;
    if (_haveVillage) {
        priceArr = @[_model.frezze_income,_model.valid_income,_model.settled_income];
    }else{
        priceArr = @[@"0.00",@"0.00",@"0.00"];
    }
    NSArray *iconArr = @[icon_village_unlock,icon_village_income,icon_village_closeAccount];
    NSArray *iconColor = @[@"#35B7F0",@"EC5A3F",@"5769CE"];
    NSArray *titleArr = @[@"待解锁",@"可用收益",@"已结算"];
    CGFloat btnWidth = ScreenWidth*0.217;//配屏
    CGFloat spaceWidth = ScreenWidth*0.12;
    for (int i = 0; i < iconArr.count; i++) {
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*btnWidth+i*spaceWidth+ScreenWidth*0.072, ScreenHeight*0.033, ScreenWidth*0.193, ScreenHeight*0.038)];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.font = [UIFont systemFontOfSize:11];
        priceLabel.text = priceArr[i];
        [headerView addSubview:priceLabel];
        if (_haveVillage) {
            priceLabel.hidden = NO;
        }else{
            priceLabel.hidden = YES;
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.193, ScreenHeight*0.054)];
        btn.center = CGPointMake(priceLabel.center.x, priceLabel.center.y+priceLabel.frame.size.height/2+btn.frame.size.height/2+10);
        btn.tag = 2000 + i;
        [setButtonIcon setButtonIcon:btn withText:iconArr[i] withSize:ScreenHeight*0.054 withColor:[UIColor colorWithHexString:iconColor[i]] withBgColor:[UIColor whiteColor]];
        [headerView addSubview:btn];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.193, ScreenHeight*0.038)];
        titleLabel.center = CGPointMake(btn.center.x, headerView.frame.size.height-21);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = titleArr[i];
        [headerView addSubview:titleLabel];
        
        if (i == 1) {
            
            priceLabel.textColor = [UIColor colorWithHexString:@"#4c8912"];
            titleLabel.textColor = [UIColor colorWithHexString:@"#29a409"];
        }

    }
    
    //tableView
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollV.frame.size.height) style:UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableHeaderView = headerView;
    tableV.backgroundColor = [UIColor colorWithHexString:@"#e4e4e4"];
    tableV.scrollEnabled = NO;
    [self.scrollV addSubview:tableV];
    
}
- (void)addFirstPageContentView{
    
    //第一页
    CGFloat btnWidth = ScreenWidth*0.12;//0.12是按钮在屏幕的比例,所有小数都是屏幕适配需要
    CGFloat spaceWidth = ScreenWidth*0.17;
    NSArray *titleArr = @[@"专区信息",@"专区业绩",@"代理商",@"经销商",@"激活码"];
    NSArray *iconArr = @[icon_village_information,icon_village_performance,icon_village_generalize,icon_village_expend,icon_village_activation];
    NSArray *bgColorArr = @[@"#EC5A3F",@"#EC963F",@"#3F92EC",@"#EC963F",@"#ECB53F"];
    for (int i = 0; i < titleArr.count; i++) {
        
        UIButton *btn;

        if (i <= i%3) {
            
            btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*0.14+(i*btnWidth)+(i*spaceWidth), ScreenHeight*0.072, btnWidth, btnWidth)];
            
        }else{
            btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*0.14+(i%3*btnWidth)+(i%3*spaceWidth), ScreenHeight*0.072+i/3*ScreenHeight*0.19, btnWidth, btnWidth)];
        }
        btn.layer.cornerRadius = btnWidth/2;
        btn.tag = 1000 + i;
        [setButtonIcon setButtonIcon:btn withText:iconArr[i] withSize:btnWidth/2 withColor:[UIColor whiteColor] withBgColor:[UIColor colorWithHexString:bgColorArr[i]]];
        [btn addTarget:self action:@selector(firstButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollV addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, ScreenHeight*0.068)];
        label.center = CGPointMake(btn.center.x, btn.center.y+btn.frame.size.height/2+20);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.text = titleArr[i];
        [self.scrollV addSubview:label];
    }
    
}

#pragma mark - UITableViewDelegate方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"申请提现";
        cell.detailTextLabel.text = @"点击申请";
        cell.textLabel.textColor = [UIColor redColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float money = [_model.valid_income floatValue];
    if (_haveVillage && money > 0) {
        DrawMoneyViewController *drawMoneyVC = [[DrawMoneyViewController alloc] init];
        drawMoneyVC.user_id = _user_id;
        drawMoneyVC.token = _token;
        drawMoneyVC.district_id = _model.district_id;
        drawMoneyVC.money = _model.valid_income;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:drawMoneyVC animated:YES];
    }else{
        
        if (_haveVillage) {
            [self promptMessage:@"没有可提取金额"];
        }else{
            //提示
            [self promptMessage:@"抱歉，您还没有入驻专区，不能查看更多了。"];
        }
        
    }
   
}

//组间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UIScrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //计算页码
    NSInteger pageNum = scrollView.contentOffset.x/ScreenWidth;
    //调用按钮方法实现按钮切换
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 1000 + pageNum;
    [self btnSelectAction:btn];
}

#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    //    navView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 25, 25)];
    //    [backBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e61e", 50, [UIColor redColor])] forState:UIControlStateNormal];
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
    title.text = @"专区";
    [navView addSubview:title];
}

#pragma mark - 按钮事件
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//切换页面
- (void)btnSelectAction:(UIButton *)btn{
    
    UIButton *button = [self.btnView viewWithTag:btn.tag];
    //按钮切换
    for (UIButton *b in self.btnView.subviews) {
        Class class = NSClassFromString(@"UIButton");
        if ([b isKindOfClass:class]) {
            if (button.tag == b.tag) {
                b.selected = YES;
                b.backgroundColor = [UIColor whiteColor];
            }else {
                b.selected = NO;
                b.backgroundColor = [UIColor clearColor];
            }
            
        }
        
    }
    
    //切换视图
    [self.scrollV setContentOffset:CGPointMake((btn.tag-1000)*ScreenWidth, 0) animated:NO];
}

//第一页按钮事件
- (void)firstButtonAction:(UIButton *)btn{
    
    if (btn.tag-1000 == 2) {
        // 代理商
        if (_haveVillage) {
//            NSArray *keys = [[NSArray alloc]init];
//            NSArray *values = [[NSArray alloc]init];
//            keys = @[@"user_id",@"token"];
//            values = @[@(_user_id),_token];
//            [MySDKHelper postAsyncWithURL:@"/v1/is_district_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
                //                NSLog(@"我是数据%@",result);
//                if (result[@"content"][@"is_promoter"]) {
                    GeneralizeViewController *generalizeVC = [[GeneralizeViewController alloc] init];
//                    [generalizeVC setUser_id:_user_id withToken:_token withDistrict_id:_model.district_id];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:generalizeVC animated:YES];
//                }else{
//
//                    //提示
//                    [self promptMessage:@"您还不是推广员"];
//                }
                
//            } postCancel:^(NSString *error) {
//                NSLog(@"我是错误%@",error);
//
//            }];

        }else {
            
            //提示
            [self promptMessage:@"抱歉，您还没有入驻专区，不能查看更多了。"];

        }
        
     }
    if (btn.tag-1000 == 3) {
        if (_haveVillage) { // 经销商
            OperatorViewController *operatorVC = [[OperatorViewController alloc] init];
//            [operatorVC setUser_id:_user_id withToken:_token withDistrict_id:_model.district_id];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:operatorVC animated:YES];
        }else{
            
            //提示
            [self promptMessage:@"抱歉，您还没有入驻专区，不能查看更多了。"];
        }
        
    }
    if (btn.tag-1000 == 0) {
        if (_haveVillage) {
            // 专区信息
            [self promptMessage:@"正在建设中"];
        }else{
            [self promptMessage:@"抱歉，您还没有入驻专区，不能查看更多了。"];
        }
        
    }
    if (btn.tag-1000 == 1) {
        if (_haveVillage) {  // 专区业绩
            PerfermenceViewController *perfermenceVC = [[PerfermenceViewController alloc]init];
            perfermenceVC.district_id = _model.district_id;
            perfermenceVC.user_id = _user_id;
            perfermenceVC.token = _token;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:perfermenceVC animated:YES];
        }else{
            [self promptMessage:@"抱歉，您还没有入驻专区，不能查看更多了。"];
        }
    }
    if (btn.tag - 1000 == 4) {
        PromoterCodeController *promoter = [[PromoterCodeController alloc] init];
        promoter.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:promoter animated:YES];
    }
}

//提示视图
- (void)promptMessage:(NSString *)prompt{
    
    UILabel *promptM = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    promptM.center = CGPointMake(ScreenWidth/2, ScreenHeight-ScreenHeight/4);
    promptM.text = prompt;
    promptM.font = [UIFont systemFontOfSize:12];
    promptM.layer.borderWidth = 1;
    promptM.layer.borderColor = [UIColor darkGrayColor].CGColor;
    promptM.layer.cornerRadius = 5;
    promptM.textAlignment = NSTextAlignmentCenter;
    promptM.textColor = [UIColor blackColor];
    promptM.numberOfLines = 0;
    [self.view addSubview:promptM];
    [UIView animateWithDuration:3 animations:^{
        promptM.alpha = 0;
    } completion:^(BOOL finished) {
        [promptM removeFromSuperview];
    }];
    
}

//第三页按钮事件
- (void)threePageAction:(UIButton *)btn{
    
    if (_haveVillage) {
        SaleViewController *saleVC = [[SaleViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        //    saleVC.index = btn.tag - 3000;
        [saleVC setViewIndexTitle:btn.tag-3000];
        [saleVC setIndex:btn.tag-3000 withUser_id:_user_id withToken:_token withDistrict_id:_model.district_id];
        [self.navigationController pushViewController:saleVC animated:YES];
    }else{
        [self promptMessage:@"抱歉，您还没有入驻专区，不能查看更多了。"];
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
