//
//  MyGeneralizeViewController.m
//  huabi
//
//  Created by teammac3 on 2017/4/1.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "MyGeneralizeViewController.h"
#import "VillageIcon.h"
#import "TBCityIconFont.h"

#import "DrawMoneyViewController.h"
#import "SaleViewController.h"
#import "IncomeModel.h"
#import "GSaleView.h"
#import "GWithDrawMoneyView.h"
//新增页面
#import "IncomeRecordViewController.h"
#import "MyInviteGenerController.h"

#import "MyInvitePModel.h"
#import "QRCodeView.h"

@interface MyGeneralizeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UIView *btnView;
@property(nonatomic,weak)UIScrollView *scrollV;
@property(nonatomic,copy)IncomeModel *model;
//邀请人员
@property(nonatomic,strong)NSMutableArray *modelArr;
//二维码视图
@property(nonatomic,strong)UIView *qrcV;

@end

@implementation MyGeneralizeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建导航栏
    [self createNavigationView];
    
}

#pragma mark - 加载数据
- (void)setToken:(NSString *)token{
    _token = token;
    _modelArr = [NSMutableArray array];
    
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"page"];
    values = @[@(_user_id),_token,@"1"];
    [MySDKHelper postAsyncWithURL:@"/v1/get_my_invite_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
        //                NSLog(@"我是数据%@",result);
        //解析
        NSArray *arr = result[@"content"];
        if (arr.count!=0) {
            for (NSDictionary *dic in result[@"content"][@"data"]) {
                MyInvitePModel *model = [[MyInvitePModel alloc] initWithDictionary:dic error:nil];
                [_modelArr addObject:model];
            }
        }
        
    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
        
    }];

    [self loadData];
}
- (void)loadData{
    
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token"];
    values = @[@(_user_id),_token];
    [MySDKHelper postAsyncWithURL:@"/v1/get_promoter_income_static" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
        //        NSLog(@"%@",result);
        //解析
        IncomeModel *model = [[IncomeModel alloc]initWithDictionary:result[@"content"] error:nil];
        self.model = model;
        //创建视图
        [self createView];
    } postCancel:^(NSString *error) {
        NSLog(@"我是错误%@",error);
        
    }];
    
}
#pragma mark - 创建视图
- (void)createView{
    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 230/2)];
//    imageV.image = [UIImage imageNamed:@"xiaoqu_bg"];
//    [self.view addSubview:imageV];
    
    //按钮背景
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 44)];
    btnView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:btnView];
    self.btnView = btnView;

    //按钮
    CGFloat width = ScreenWidth/2;
    CGFloat height = 76/2;
    NSArray *btnTitle = @[@"收益统计",@"提现记录"];
    
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
//    //添加第二页内容
//    [self addSecondPageContentView];
    //添加第三页内容
    [self addThreePageContentView];
    
    

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
        
        if ([self.shouYi isEqualToString:@"1"])
        {
            if (i == 0) {
                
                btn.selected = YES;
                btn.backgroundColor = [UIColor whiteColor];
                
            }
        } else {
            if (i == 1) {
                
                btn.selected = YES;
                btn.backgroundColor = [UIColor whiteColor];
                //切换视图
                //                [self.scrollV setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
                [self btnSelectAction:btn];
            }
        }
    }
    
}

//添加内容
//第三页
- (void)addThreePageContentView{

    GWithDrawMoneyView *ThreeV = [[GWithDrawMoneyView alloc] initWithFrame:CGRectMake(2*ScreenWidth, 0, ScreenWidth, self.scrollV.frame.size.height)];
    [ThreeV setUser_id:_user_id withToken:_token];
    [self.scrollV addSubview:ThreeV];
}
//第二页
- (void)addSecondPageContentView{
    
    GSaleView *secondV = [[GSaleView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollV.frame.size.height)];
    [secondV setUser_id:_user_id withToken:_token];
    [self.scrollV addSubview:secondV];
}
//第一页
- (void)addFirstPageContentView{
    
    //第一页
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.203)];
    headerView.backgroundColor = [UIColor whiteColor];
    //测试数据
//    NSLog(@"%@,%@,%@",_model.frezze_income,_model.valid_income,_model.settled_income);
    NSArray *priceArr = @[_model.frezze_income,_model.valid_income,_model.settled_income];
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
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.scrollV.frame.size.height) style:UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableHeaderView = headerView;
    tableV.backgroundColor = [UIColor colorWithHexString:@"#e4e4e4"];
    tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    tableV.scrollEnabled = NO;
    [self.scrollV addSubview:tableV];
    
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
#pragma mark - UITableViewDelegate方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return _modelArr.count+1;
//    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor redColor];
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 0) {
            cell.textLabel.text = @"申请提现";
            cell.detailTextLabel.text = @"点击申请";
        }else {
            
            cell.textLabel.text = @"收益记录";
            cell.detailTextLabel.text = @"查看更多";
        }
    }
    return cell;
}
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        
        float money = [_model.valid_income floatValue];
        if (money > 0) {
            DrawMoneyViewController *drawMoneyVC = [[DrawMoneyViewController alloc] init];
            drawMoneyVC.user_id = _user_id;
            drawMoneyVC.token = _token;
            drawMoneyVC.district_id = @"0";
            drawMoneyVC.money = _model.valid_income;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:drawMoneyVC animated:YES];
        }else{
            [self promptMessage:@"无可取资金"];
        }
    }else {
        
        IncomeRecordViewController *incomeRC = [[IncomeRecordViewController alloc] init];
        incomeRC.user_id = _user_id;
        incomeRC.token = _token;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:incomeRC animated:YES];
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
    [self.view addSubview:promptM];
    [UIView animateWithDuration:3 animations:^{
        promptM.alpha = 0;
    } completion:^(BOOL finished) {
        [promptM removeFromSuperview];
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//组间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
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
    title.text = @"用户必备";
    [navView addSubview:title];
    
//    //菜单按钮
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-35, 30, 25, 25)];
//    //    [backBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e61e", 50, [UIColor redColor])] forState:UIControlStateNormal];
//    UIFont *rightIcon = [UIFont fontWithName:@"iconfont" size:28];
//    rightBtn.titleLabel.font = rightIcon;
//    [rightBtn setTitle:@"\U0000e60e" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:rightBtn];
}

#pragma mark - 按钮事件
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)rightBtnAction:(UIButton *)btn{
//    
//    MyInviteGenerController *myinviteC = [[MyInviteGenerController alloc] init];
//    myinviteC.user_id = _user_id;
//    myinviteC.token = _token;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:myinviteC animated:YES];
//}

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

#pragma mark - 按钮事件
- (void)inviteAction:(UIButton *)btn{
    
    //创建二维码
    //拼接字符串
    if (_qrcV == nil) {
        _qrcV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _qrcV.backgroundColor = [UIColor blackColor];
        _qrcV.alpha = 0.6;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_qrcV addGestureRecognizer:tap];
        [self.view.window addSubview:_qrcV];
        
        //获取专区id
        NSArray *keys = [[NSArray alloc]init];
        NSArray *values = [[NSArray alloc]init];
        keys = @[@"user_id",@"token"];
        values = @[@(_user_id),_token];
        [MySDKHelper postAsyncWithURL:@"/v1/is_district_promoter" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
            //                NSLog(@"我是数据%@",result);
            //解析
            if (result[@"content"] != nil) {
                
                NSString *str = [NSString stringWithFormat:@"%@%@/invitor_role/promoter",myInviteStr,result[@"content"][@"promoter_id"]];
//                NSLog(@"打印————%@",str);
                CGFloat viewWidth = 230;
                QRCodeView *qrcV = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, viewWidth,viewWidth) withLinkStr:str];
                qrcV.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                [_qrcV addSubview:qrcV];
            }
        } postCancel:^(NSString *error) {
            NSLog(@"我是错误%@",error);
        }];
    }
    
}

////触摸事件
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [_qrcV removeFromSuperview];
//}
- (void)tapAction{
    
    [_qrcV removeFromSuperview];
    _qrcV = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //时间颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



@end
