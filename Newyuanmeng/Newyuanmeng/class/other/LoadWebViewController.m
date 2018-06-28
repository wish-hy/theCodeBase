//
//  LoadWebViewController.m
//  Newyuanmeng
//
//  Created by hy on 2018/4/7.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "LoadWebViewController.h"

@interface LoadWebViewController ()

@end

@implementation LoadWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_Url]];
    [self.view addSubview:web];
    [web loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
