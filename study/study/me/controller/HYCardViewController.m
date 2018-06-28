//
//  HYCardViewController.m
//  study
//
//  Created by hy on 2018/5/20.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYCardViewController.h"

@interface HYCardViewController ()

@end

@implementation HYCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchKlick)];
    [self.view addGestureRecognizer:tap];
    
    UIView *nav = [[UIView alloc] init];
    nav.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
//        make.height.mas_equalTo(ScreenWidth).multipliedBy(100);
//        make.width.mas_equalTo(ScreenHeight).multipliedBy(100);
    }];
}

-(void)touchKlick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
