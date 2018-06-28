//
//  HYTabBar.m
//  fileManager
//
//  Created by hy on 2018/3/28.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYTabBar.h"


@interface HYTabBar ()
// 发布按钮
@property (nonatomic, strong) UIButton *publishBtn;

@end

@implementation HYTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置背景图片
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"publish_nomer"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"publish_selected"] forState:UIControlStateHighlighted];
        [publishButton sizeToFit];
        // 监听按钮点击（发布按钮）
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        //        publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        [self addSubview:publishButton];
        self.publishBtn = publishButton;
        
    }
    return self;
}


- (void)publishClick
{
    self.click();
}


/**
 *  重写layoutSubviews方法，布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // TabBar的尺寸
    CGFloat width = self.frame.size.width;
    CGFloat height = 49;
    // 设置发布按钮的位置
    self.publishBtn.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置索引
    int index = 0;
    // 按钮的尺寸
    CGFloat tabBarButtonW = self.frame.size.width / 5;
    CGFloat tabBarButtonH = 49;
    CGFloat tabBarButtonY = 0;
    
    // 设置四个TabBarButton的frame
    for (UIView *tabBarButton in self.subviews) {
        if (![NSStringFromClass(tabBarButton.class) isEqualToString:@"UITabBarButton"]) continue;
        
        // 计算那妞X的值
        CGFloat tabBarButtonX = index * tabBarButtonW;
        
        if (index >= 2) {
            tabBarButtonX += tabBarButtonW; // 给后面2个button增加一个宽度的X值
        }
        tabBarButton.frame = CGRectMake(tabBarButtonX, tabBarButtonY, tabBarButtonW, tabBarButtonH);
        index++;
        
    }
    
    
    
    //    HYLog(@"---------begin");
    //    for (UIView *subview in self.subviews) {
    //        if (![NSStringFromClass(subview.class) isEqualToString:@"UITabBarButton"]) continue;
    //        HYLog(@"%@",subview);
    //    }
    //    HYLog(@"----------end");
    
    
    
}

@end
