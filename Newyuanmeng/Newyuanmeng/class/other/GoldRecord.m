//
//  GoldRecord.m
//  huabi
//
//  Created by TeamMac2 on 17/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "GoldRecord.h"
#import "GoldAllViewController.h"
#import "GoldGainViewController.h"
#import "GoldSpendingViewController.h"
#import "Newyuanmeng-Swift.h"
@interface GoldRecord ()
{
    UILabel *title;
    UIButton *backBtn;
    UIButton *homeBtn;
}

@property(nonatomic,strong)UISegmentedControl *segmentedControl;
@property(nonatomic,strong)GoldAllViewController *allVC;
@property(nonatomic,strong)GoldGainViewController *gainVC;
@property(nonatomic,strong)GoldSpendingViewController *spendingVC;
@property(nonatomic,assign)NSInteger myTag;
@end

@implementation GoldRecord



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTag = 1;
    [self createUI];
    
    
}

-(GoldAllViewController *)allVC
{
    if (_allVC == nil) {
        _allVC = [GoldAllViewController new];
        _allVC.userID = _userID;
        _allVC.token = _token;
    }
    return _allVC;
}

-(GoldGainViewController *)gainVC
{
    if (_gainVC == nil) {
        _gainVC = [GoldGainViewController new];
        _gainVC.userID = _userID;
        _gainVC.token = _token;
        [self addChildViewController:_gainVC];
    }
    return _gainVC;
}

-(GoldSpendingViewController *)spendingVC
{
    if (_spendingVC == nil) {
        _spendingVC = [GoldSpendingViewController new];
        _spendingVC.userID = _userID;
        _spendingVC.token = _token;
        [self addChildViewController:_spendingVC];
    }
    return _spendingVC;
}

-(UISegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"获得",@"支出"]];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl setTintColor:[UIColor orangeColor]];
        id selectedTexAttri = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13.0],NSForegroundColorAttributeName : [UIColor whiteColor]};
        id unseletedTexAttri = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13.0],NSForegroundColorAttributeName :[UIColor orangeColor]};
        [_segmentedControl setTitleTextAttributes:selectedTexAttri forState:UIControlStateSelected];
        [_segmentedControl setTitleTextAttributes:unseletedTexAttri forState:UIControlStateNormal];
        [_segmentedControl addTarget:self action:@selector(segmentClick) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

-(void)segmentClick
{
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index == 0) {
        if (self.myTag == 2) {
            [self flipFromViewController:self.gainVC toViewController:self.allVC options:UIViewAnimationOptionTransitionNone];
            self.myTag = 1;
        }else if (self.myTag == 3){
            [self flipFromViewController:self.spendingVC toViewController:self.allVC options:UIViewAnimationOptionTransitionNone];
            self.myTag = 1;
        }
        
    }else if (index == 1){
        if (self.myTag == 1) {
            [self flipFromViewController:self.allVC toViewController:self.gainVC options:UIViewAnimationOptionTransitionNone];
            self.myTag = 2;
        }else if (self.myTag == 3){
            [self flipFromViewController:self.spendingVC toViewController:self.gainVC options:UIViewAnimationOptionTransitionNone];
            self.myTag = 2;
        }
        
    }else if (index == 2){
        if (self.myTag == 1) {
            [self flipFromViewController:self.allVC toViewController:self.spendingVC options:UIViewAnimationOptionTransitionNone];
            self.myTag = 3;
        }else if (self.myTag == 2){
            [self flipFromViewController:self.gainVC toViewController:self.spendingVC options:UIViewAnimationOptionTransitionNone];
            self.myTag = 3;
        }
    }
    NSLog(@"当前是第%ld页",(long)self.myTag);
}

-(void)flipFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC options:(UIViewAnimationOptions)options
{
    [self.view addSubview:toVC.view];
    toVC.view.frame = CGRectMake(0, 94, ScreenWidth, ScreenHeight - 138);
    
    __weak typeof(fromVC) weakFromVC = fromVC;
    [self transitionFromViewController:fromVC toViewController:toVC duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        [weakFromVC.view removeFromSuperview];
    }];
    
}

-(void)createUI
{
    
    self.allVC.view.frame = CGRectMake(0, 94,ScreenWidth, ScreenHeight - 138);
    [self addChildViewController:_allVC];
    [self.view addSubview:self.allVC.view];
    
    self.segmentedControl.frame = CGRectMake(10, 64,ScreenWidth - 25, 30.0);
    [self.view addSubview:self.segmentedControl];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 - 40, 25, 80, 25)];
    [title setTintColor:[UIColor blackColor]];
    [title setText:@"余额记录"];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:title];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 25, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"ic_back-1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(ScreenWidth - 40, 25, 25, 25);
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"backbackmain"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
}

-(void)gotoBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoHome:(UIButton *)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
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
