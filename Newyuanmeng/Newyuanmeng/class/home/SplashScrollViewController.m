//
//  SplashScrollViewController.m
//  Newyuanmeng
//
//  Created by hy on 2018/4/4.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "SplashScrollViewController.h"
#import "Newyuanmeng-Swift.h"

@interface SplashScrollViewController ()
@property (nonatomic, strong) UIScrollView *splashScroll;
@end

@implementation SplashScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor yellowColor];
    _splashScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    _splashScroll.backgroundColor = [UIColor redColor];
    _splashScroll.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight);
    _splashScroll.userInteractionEnabled = YES;
    _splashScroll.pagingEnabled = YES;
    _splashScroll.bounces = NO;
    _splashScroll.showsVerticalScrollIndicator = NO;
    _splashScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_splashScroll];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loding1"]];
    image1.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loding2"]];
    image2.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);

    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loding3"]];
    image3.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth * 2 + ScreenWidth/2 - (200 * ScreenWidth / 750.0)/2, (ScreenHeight - 80 * (ScreenWidth / 750.0))/2 + 500 * ScreenWidth / 750.0, 200 * ScreenWidth / 750.0, 80 * ScreenWidth / 750.0);
    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = CommonConfig.MainGreenColor;
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(btnShowMainPage) forControlEvents:UIControlEventTouchUpInside];
    
    [_splashScroll addSubview:image1];
    [_splashScroll addSubview:image2];
    [_splashScroll addSubview:image3];
    [_splashScroll addSubview:btn];
}

//-(UIScrollView *)splashScroll
//{
//    if (!_splashScroll) {
//
//    }
//    return _splashScroll;
//}

-(void)btnShowMainPage
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
}

@end
