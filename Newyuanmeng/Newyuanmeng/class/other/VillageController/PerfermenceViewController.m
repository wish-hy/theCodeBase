//
//  PerfermenceViewController.m
//  huabi
//
//  Created by teammac3 on 2017/4/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "PerfermenceViewController.h"
#import "PNChartDelegate.h"
#import "PNChart.h"


@interface PerfermenceViewController ()<PNChartDelegate>

@property (nonatomic) PNLineChart * lineChart;
//数据
@property(nonatomic,strong)NSArray *xArr;
@property(nonatomic,strong)NSArray *yArr;

@end

@implementation PerfermenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    //创建导航栏
    [self createNavigationView];

}

//加载数据
- (void)setToken:(NSString *)token{
    _token = token;
    
    //创建视图
    [self createView];
}
#pragma mark - 创建视图
- (void)createView{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, ScreenWidth*0.169, 30)];
    label.text = @"选择时间";
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    
    CGFloat btnWidth = ScreenWidth*0.193;
    CGFloat spaceWidth = ScreenWidth*0.012;
    CGFloat baseX = label.frame.size.width;
    NSArray *titleArr = @[@"今天",@"昨天",@"最近7天",@"最近一个月"];
    for (int i = 0; i < 4; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(baseX+i*btnWidth+i*spaceWidth, 74, btnWidth, 30)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = [UIColor redColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = 1001 +i;
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
    _xArr = [NSArray array];
    _yArr = [NSArray array];
    
    NSArray *keys = [[NSArray alloc]init];
    NSArray *values = [[NSArray alloc]init];
    keys = @[@"user_id",@"token",@"district_id",@"type"];
    values = @[@(_user_id),_token,_district_id,@"1"];
    [MySDKHelper postAsyncWithURL:@"/v1/district_achievement" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//        NSLog(@"我是数据%@",result);
        
        NSDictionary *dic = result[@"content"][@"data"];
        _xArr = dic[@"x"];
        _yArr = dic[@"y"];
        
        //创建视图
        [self createLineChart];
    } postCancel:^(NSString *error) {
//        NSLog(@"我是错误%@",error);
        
    }];

}

//具体的图形创建
- (void)createLineChart{
    
    self.lineChart.backgroundColor = [UIColor whiteColor];
    self.lineChart.yGridLinesColor = [UIColor grayColor];
    self.lineChart.userInteractionEnabled = NO;
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor blackColor];
    }];
    
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 200.0)];
    self.lineChart.showCoordinateAxis = YES;
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.xLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:10];
    
    [self.lineChart setXLabels:_xArr];
    self.lineChart.yLabelColor = [UIColor blackColor];
    self.lineChart.xLabelColor = [UIColor blackColor];
    
    self.lineChart.showGenYLabels = NO;
    self.lineChart.showYGridLines = YES;
    
    NSInteger max = [[_yArr valueForKeyPath:@"@max.intValue"] integerValue];
    if (max < 100) {
        max = 100;
    }
    
    self.lineChart.yFixedValueMax = max;
    self.lineChart.yFixedValueMin = 0.0;
    //Y轴显示数字计算处理
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"¥0",@"0",@"0",@"0",@"", nil];
    NSInteger num = max;
    for (int i = 4; i >= 1; i--) {
        
        num -= max/5;
        NSString *str = [NSString stringWithFormat:@"¥%ld",num];
        NSString *numStr;
        NSInteger n = pow(10, str.length-2);
        if (num/n != 0 && num%n != 0) {
            
            numStr = [NSString stringWithFormat:@"¥%ld",(num/n+1)*n];
            [arr replaceObjectAtIndex:i  withObject:numStr];
        }else {
            
            
            [arr replaceObjectAtIndex:i  withObject:str];
        }
        
    }
        NSString *str = [NSString stringWithFormat:@"¥%ld",max];
        NSString *numStr;
        NSInteger n = pow(10, str.length-2);
        if (max/n != 0 && max%n != 0) {
            NSInteger arr4 = [[arr[4] substringFromIndex:1] integerValue];
            if ((max/n+1)*n > arr4) {
                numStr = [NSString stringWithFormat:@"¥%ld",(max/n+1)*n];
                [arr addObject:numStr];
            }

        }else {
            [arr addObject:str];
        }
    [self.lineChart setYLabels:arr];
    
    // Line Chart #1
    NSMutableArray *newDataArr = [NSMutableArray array];
    for (NSInteger i = _yArr.count-1; i >= 0; i--) {
        
        [newDataArr addObject:_yArr[i]];
    }
    NSArray *data01Array = newDataArr;
    data01Array = [[data01Array reverseObjectEnumerator] allObjects];
    PNLineChartData *data01 = [PNLineChartData new];
    
//    data01.rangeColors = @[
//                           [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(10, 30) color:[UIColor redColor]],
//                           [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(100, 200) color:[UIColor purpleColor]]
//                           ];
    data01.dataTitle = @"推广销售";
    data01.color = PNFreshGreen;
    data01.pointLabelColor = [UIColor blackColor];
    data01.alpha = 0.3f;
    data01.showPointLabel = YES;
    data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
    data01.itemCount = data01Array.count;
    data01.inflexionPointColor = PNRed;
    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01];
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor blackColor];
    }];
    
    
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
    
    
    [self.view addSubview:self.lineChart];
    
    self.lineChart.legendStyle = PNLegendItemStyleStacked;
    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    self.lineChart.legendFontColor = [UIColor redColor];
    
    UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
    [legend setFrame:CGRectMake(40, self.lineChart.frame.origin.y+self.lineChart.size.height+20, legend.frame.size.width, legend.frame.size.width)];
    [self.view addSubview:legend];
}

#pragma mark - 按钮响应事件
- (void)selectAction:(UIButton *)btn{
    
    UIButton *button = [self.view viewWithTag:btn.tag];
    for (UIButton *b in self.view.subviews) {
        
        Class class = NSClassFromString(@"UIButton");
        if ([b isKindOfClass:[class class]]) {
            if (button.tag == b.tag) {
                b.selected = YES;
                NSArray *keys = [[NSArray alloc]init];
                NSArray *values = [[NSArray alloc]init];
                keys = @[@"user_id",@"token",@"district_id",@"type"];
                values = @[@(_user_id),_token,_district_id,@(btn.tag-1000)];
                [MySDKHelper postAsyncWithURL:@"/v1/district_achievement" withParamBodyKey:keys withParamBodyValue:values needToken:_token postSucceed:^(NSDictionary *result) {
//                    NSLog(@"我是数据%@",result);
                    
                    NSDictionary *dic = result[@"content"][@"data"];
                    _xArr = dic[@"x"];
                    _yArr = dic[@"y"];
                    
                    [self.lineChart removeFromSuperview];
                    //创建视图
                    [self createLineChart];
                } postCancel:^(NSString *error) {
                    NSLog(@"我是错误%@",error);
                    
                }];

            }else{
                b.selected = NO;
            }
        }
    }
    
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
    title.text = @"专区业绩";
    [navView addSubview:title];
    
}

#pragma mark - 按钮事件
//导航栏按钮事件
- (void)backBtnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
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
