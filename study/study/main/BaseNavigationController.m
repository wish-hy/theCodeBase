//
//  BaseNavigationController.m
//  fileManager
//
//  Created by hy on 2018/3/14.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+(void)initialize{
    //获取当前的导航条---获取到正在显示的导航条
    UINavigationBar *navBar = [UINavigationBar appearance];
    
//    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBackground"] forBarMetrics:UIBarMetricsDefault];
    
//     UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    
    //设置文字颜色
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //获取当前的导航按钮---获取到正在显示的导航按钮
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    item.tintColor = [UIColor blackColor];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
//    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB_Color(66, 66, 66)} forState:UIControlStateNormal];
}

//#pragma mark - 修改返回按钮
//// 拦截push过去的控制器 修改其控制器 左上角返回按钮的样式
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"back" highImage:@"back"];
    }
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

//设置电池兰高亮显示
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn sizeToFit];
    
//    btn.size = CGSizeMake(40, 40);
    // 设置按钮内边距
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
