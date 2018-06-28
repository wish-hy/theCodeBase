//
//  HYTabBarController.m
//  fileManager
//
//  Created by hy on 2018/3/28.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYTabBarController.h"
#import "HYTabBar.h"
#import "BaseNavigationController.h"
#import "HYPublishViewController.h"
#import "HYHomeViewController.h"
#import "HYEssenceViewController.h"
#import "HYCategoryViewController.h"
#import "HYMineViewController.h"
#import "HYPublishViewController.h"

@interface HYTabBarController ()

@end

@implementation HYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUpItem];
    [self setUpChildVc];
    
    // 处理tabBar
    [self setUpTabBar];
}

/**
 *  处理tabBar  设置中间特殊按钮  如不需要注释即可
 */
- (void)setUpTabBar
{
    HYTabBar *tabbar = [[HYTabBar alloc] init];
//    [tabbar setShadowImage:[UIImage new]];
    [tabbar setBackgroundImage:[HYToolsKit createImageWithColor:[UIColor whiteColor]]];
    [self setValue:tabbar forKey:@"tabBar"];
    tabbar.click = ^{
        HYPublishViewController *publish = storyboardWith(@"Publish", @"HYPublishViewController");
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:publish];
        [self presentViewController:nav animated:YES completion:nil];
    };
    
}

/**
 *  设置Item的属性
 */
- (void)setUpItem
{
    // UIControlStateNormal情况下的文字属性
    NSMutableDictionary *normalAtrrs = [NSMutableDictionary dictionary];
    // 文字颜色
    normalAtrrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // UIControlStateSelected情况的文字属性
    NSMutableDictionary *selectedAtrrs = [NSMutableDictionary dictionary];
    // 文字颜色
    selectedAtrrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 统一给所有的UITabBatItem设置文字属性
    // 只有后面带有UI_APPEARANCE_SELECTOR方法的才可以通过appearance来设置
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAtrrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAtrrs forState:UIControlStateSelected];
    
}

/**
 *  设置setUpChildVc的属性，添加所有的子控件
 */
- (void)setUpChildVc
{
    [self setUpChildVc:[[HYHomeViewController alloc] init] title:@"首页" image:@"home_nomer" selectedImage:@"home_selected"];
    [self setUpChildVc:[[HYEssenceViewController alloc] init] title:@"专题" image:@"special_nomer" selectedImage:@"special_selected"];
    [self setUpChildVc:[[HYCategoryViewController alloc] init] title:@"活动" image:@"activity_nomer" selectedImage:@"activity_selected"];
    [self setUpChildVc:[[HYMineViewController alloc] init] title:@"我的" image:@"me_nomer" selectedImage:@"me_selected"];
    
}

- (void)setUpChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 包装一个导航控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    // 设置子控制器的tabBarItem
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    // 随机色  可注释
//    nav.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0];
    nav.view.backgroundColor = [UIColor whiteColor];
    // 设置子控制器的图片  如图片颜色显示不对
//    childVc.tabBarItem.image = [UIImage imageNamed:image];
//    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字的样式
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
//    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:36/255.0 green:55/255.0 blue:107/255.0 alpha:1.0];
//    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
        // 不知干嘛用
//        vc.tabBarItem.title = title;
//        vc.tabBarItem.image = [UIImage imageNamed:image];
//        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
//        vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0];
    
}


@end
