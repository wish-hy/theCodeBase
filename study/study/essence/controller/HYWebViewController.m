//
//  HYWebViewController.m
//  study
//
//  Created by hy on 2018/5/23.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYWebViewController.h"

@interface HYWebViewController ()

@end

@implementation HYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _webTitle;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urls]];
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:web];
    web.dataDetectorTypes = UIDataDetectorTypeAll;
    [web loadRequest:request];
}



@end
