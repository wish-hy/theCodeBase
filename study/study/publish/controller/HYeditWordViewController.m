//
//  HYeditWordViewController.m
//  study
//
//  Created by hy on 2018/5/18.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYeditWordViewController.h"
#import "LMWordViewController.h"

@interface HYeditWordViewController ()
@property (nonatomic ,strong) LMWordViewController *wordViewController;
@end

@implementation HYeditWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _wordViewController = [[LMWordViewController alloc] init];
    [self setUpUI];
}

-(void)setUpUI
{
    UIView *nav = [[UIView alloc] init];
    nav.frame = CGRectMake(0, 0, ScreenWidth, NAV_SaferHeight);
    nav.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:nav];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 20, 44, 44);
    [back setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:back];
    
}


-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
