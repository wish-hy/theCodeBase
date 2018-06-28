//
//  VillageIntroductionViewController.m
//  huabi
//
//  Created by teammac3 on 2017/3/28.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "VillageIntroductionViewController.h"
#import "ApplyForViewController.h"

@interface VillageIntroductionViewController ()<UIWebViewDelegate>

@end

@implementation VillageIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    //创建导航栏
    [self createNavigationView];
    
    //创建视图
    [self createContentView];
}

#pragma mark - 创建视图
- (void)createContentView{
    
    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];

    NSURL *url = [NSURL URLWithString:@"https://buy-d.cn/district_introduce.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webV.delegate = self;
    [webV loadRequest:request];

    [self.view addSubview:webV];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //隐藏网页某一些元素
    NSString *str = @" document.getElementById('widget_sub_navs').style.display='none';document.getElementById('widget_tabbar').style.display='none';document.getElementsByTagName('body')[0].style.padding='0px';";
    [webView stringByEvaluatingJavaScriptFromString:str];
}
//拦截webView点击事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        //获取请求链接
        NSURL *url = [request URL];
        NSString *str = [url absoluteString];
        if (url != NULL && [str rangeOfString:@"/user/apply_for_district"].location != NSNotFound) {
            //跳转到申请入驻页面
            ApplyForViewController *applyVC = [[ApplyForViewController alloc] init];
            applyVC.user_id = _user_id;
            applyVC.token = _token;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
            
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - 导航栏
- (void)createNavigationView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
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
    title.text = @"了解专区";
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
