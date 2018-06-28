//
//  HYTabBar.h
//  Newyuanmeng
//
//  Created by hy on 2018/4/3.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

//tab页面个数
typedef NS_ENUM(NSInteger, HYItemUIType) {
    HYItemUIType_Three = 3,//底部3个选项
    HYItemUIType_Five = 5,//底部5个选项
};

@class HYTabBar;

@protocol HYTabBarDelegate <NSObject>

-(void)tabBar:(HYTabBar *)tabBar clickCenterButton:(UIButton *)sender;

@end

@interface HYTabBar : UITabBar

@property (nonatomic, weak) id<HYTabBarDelegate> tabDelegate;
@property (nonatomic, strong) NSString *centerBtnTitle;


-(void)setCenterBtnIcon:(NSString *)centerBtnIconNomer centerBtnIconSelect:(NSString *)centerBtnIconSelect;

+(instancetype)instanceCustomTabBarWithType:(HYItemUIType)type;

@end
