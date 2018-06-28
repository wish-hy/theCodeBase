//
//  HYTabBarViewController.m
//  Newyuanmeng
//
//  Created by hy on 2018/4/3.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYTabBarViewController.h"
#import "HYTabBar.h"
#import "Newyuanmeng-Swift.h"
#import "MapViewController.h"

@interface HYTabBarViewController ()<HYTabBarDelegate>

@end

@implementation HYTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI{
    [self setupVC];
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    //kvo形式添加自定义的 UITabBar
//    HYTabBar *tab = [HYTabBar instanceCustomTabBarWithType:HYItemUIType_Five];
//    tab.centerBtnTitle = @"";
//    [tab setCenterBtnIcon:@"map_nomer" centerBtnIconSelect:@"map_select"];
//    tab.tabDelegate = self;
//    [self setValue:tab forKey:@"tabBar"];
//
//    //去除顶部很丑的border
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
//
//    //自定义分割线颜色
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.tabBar.bounds.origin.x-0.5, self.tabBar.bounds.origin.y, self.tabBar.bounds.size.width+1, self.tabBar.bounds.size.height+2)];
//    bgView.layer.borderColor = [UIColor colorWithHexString:@"#eaeaea"].CGColor;
//    bgView.layer.borderWidth = 0.5;
//    [tab insertSubview:bgView atIndex:0];
//    tab.opaque = YES;
    
}
//-(void)setCenterButton{
//    self.selectedIndex = 2;
//    UITabBarItem *tabBarItem = self.tabBar.items[2];
//
//    UIImage *image = tabBarItem.image;
//    UIImage *selectimage = tabBarItem.selectedImage;
//
////    CGSize imageSize = CGSizeMake(AdaptedWidthValue(50),AdaptedWidthValue(50));
////
////    image = [image imageByScalingToSize:imageSize];
////    selectimage = [selectimage imageByScalingToSize:imageSize];
//
//    tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    tabBarItem.selectedImage = [selectimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    tabBarItem.imageInsets = UIEdgeInsetsMake(-10, 0, 10, 0); // 调整icon的位置
//    tabBarItem.titlePositionAdjustment = UIOffsetMake(0,0); // 调整icon下文本的位置
//
//    // 一个button到self.tabBar扩大主页tabBarItem的点击范围
//    CGFloat tabBarItemWidth = self.tabBar.width/5;
//    CGFloat homeUITabBarButtonX = tabBarItemWidth*2;
//    CGFloat homeUITabBarButtonY = -30;
//    UIButton *homeButton = [[UIButton alloc] initWithFrame:CGRectMake(homeUITabBarButtonX, homeUITabBarButtonY, tabBarItemWidth, tabBarItemWidth)];
//    //homeButton.backgroundColor = red_color;
//    homeButton.tag = 2;
//    [homeButton addTarget:self action:@selector(selectTabBarItem:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabBar addSubview:homeButton];

//}

//- (void)selectTabBarItem:(UIButton*)sender {
//    self.selectedIndex = sender.tag;
//
//    [self.homePageViewNavigationController popToRootViewControllerAnimated:YES];
//}

- (void)setupVC{
    
    [self addChildVc:[[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"NewMainViewController"] title:@"首页" image:@"\U0000e624" selectedImage:@"\U0000e625"];
    [self addChildVc:[[UIStoryboard storyboardWithName:@"Category" bundle:nil] instantiateViewControllerWithIdentifier:@"CategoryViewController"] title:@"分类" image:@"\U0000e61a" selectedImage:@"\U0000e62b"];
    
    
    MapViewController *map = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
    map.tabBarItem.image = [[UIImage imageNamed:@"map_nomer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    map.tabBarItem.selectedImage = [[UIImage imageNamed:@"map_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIEdgeInsets insets = UIEdgeInsetsMake(-20, 0, 0, 0);
    map.tabBarItem.imageInsets = insets;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:map];
    [self addChildViewController:nav];
    
    [self addChildVc:[[UIStoryboard storyboardWithName:@"ShopCart" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingTrolleyController"] title:@"购物车" image:@"\U0000e61b" selectedImage:@"\U0000e73c"];
    [self addChildVc:[[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCenterViewController"] title:@"我的" image:@"\U0000e628" selectedImage:@"\U0000e629"];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    // 设置子控制器的tabBarItem图片
//    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.image = [UIImage iconWithInfo:TBCityIconInfoMake(image, 30, CommonConfig.MainFontBlackColor)];
    // 禁用图片渲染
//    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage iconWithInfo:TBCityIconInfoMake(selectedImage, 30, CommonConfig.MainRedColor)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    // 为子控制器包装导航控制器
//    WBBaseNC *navigationVc = [[WBBaseNC alloc] initWithRootViewController:childVc];
//    // 添加子控制器
//    [self addChildViewController:navigationVc];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

//-(void)tabBar:(HYTabBar *)tabBar clickCenterButton:(UIButton *)sender{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击了中间按钮" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alert addAction:action];
    
//    MapViewController *map = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
//    map.hidesBottomBarWhenPushed = NO;
//    [self presentViewController:map animated:NO completion:nil];
    
//}



@end
