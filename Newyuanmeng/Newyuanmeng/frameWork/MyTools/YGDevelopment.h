//
//  Development.h
//  FindingSomething
//
//  Created by 韩伟 on 16/5/12.
//  Copyright © 2016年 韩伟. All rights reserved.
//


#ifndef YGDevelopment_h
#define YGDevelopment_h

/*************************** 常用的 IPHONE 属性 *******************************************/
#define ScreenWidth   ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define ScreenHeight  ([[UIScreen mainScreen] bounds].size.height)// 屏幕高度
#define ScaleWidth   ([[UIScreen mainScreen] bounds].size.width/720.0) // 屏幕宽度
#define ScaleHeight  ([[UIScreen mainScreen] bounds].size.height/1334.0)// 屏幕高度
#define AppleDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])   // 系统的AppleDelegate

#define AppTool       ([Tools sharedInstance])   
#define TableViewCell         @"TableViewCell"

#define StatusBarH                        20                  // 状态栏的高度
#define NaviBarH                          44                  // 工具栏的高度
#define TabH                              49                  // 底部工具栏高度
#define Space                             20*ScaleWidth                  // 默认距离


#define IMAGE(img)  [UIImage imageNamed:img]                  // 图片
//#define MyFontSize(fontSize) [UIFont fontWithName:@"FZXQJW--GB1-0" size:fontSize] // 设置fontSize
#define MyFontSize(fontSize) [UIFont systemFontOfSize:fontSize] // 设置fontSize
#define MyItalicFontSize(fontSize) [UIFont italicSystemFontOfSize:fontSize] //斜体

#define CloseImg [UIImage imageNamed:@"chacha"]

// 默认头像
#define DefaultImg            @"icon_default_head.png" 

/***************************   RGB 颜色生成器  *******************************************/
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]                                //16进制color 使用方法：HEXCOLOR(0xffffff)

#define color_main              HEXCOLOR(0x336799)              //主色调
#define color_background        HEXCOLOR(0xf0f0f0)              //背景颜色
#define color_alert_background  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]//提示框背景颜色
#define color_red_shen          HEXCOLOR(0xc40000)              //深红色
#define color_red_light         HEXCOLOR(0xa53764)              //酒红色
#define color_title_main        HEXCOLOR(0x333333)              //字体颜色
#define color_title_Gray        HEXCOLOR(0xaaaaaa)              //字体颜色浅灰
#define color_title_Light       HEXCOLOR(0x666666)              //字体颜色浅灰
#define color_title_yellow      HEXCOLOR(0xffd102)              //字体颜色橘黄
#define color_title_black       HEXCOLOR(0x020202)              //字体颜色黑色
#define color_title_black_light HEXCOLOR(0x505050)              //字体颜色黑色
#define color_Border_Line       HEXCOLOR(0xcccccc)              //边框颜色
#define color_Table_Back        HEXCOLOR(0xefefef)              //背景色
#define color_Bottom_Line       HEXCOLOR(0xe5e5e5)              //横线背景色
#define color_Center_Line       HEXCOLOR(0x9a9a9a)              //竖线背景色
#define color_Navigation_Right  HEXCOLOR(0x8a8a8a)              //导航栏右键色
#define color_Navigation_Left   HEXCOLOR(0x8a8a8a)              //导航栏左键色
#define color_Navigation_Center HEXCOLOR(0xffffff)              //导航栏标题色
#define color_tabbar_select     HEXCOLOR(0xc40000)
#define color_tabbar_normal     HEXCOLOR(0x333333)

#define color_white             [UIColor whiteColor]            //白色
#define color_clear             [UIColor clearColor]            //无色
#define color_black             [UIColor blackColor]            //黑色
#define color_green             HEXCOLOR(0x45a728)  
#define color_gray              HEXCOLOR(0x999999)              //绿色
#define color_blue              [UIColor blueColor]             //蓝色

// 生成RGB颜色值
#define UIColorFromRGB(rgbValue, rgbAlpha) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:rgbAlpha]

#define UserDefaultAllowRing                   @"messagePush"                //允许铃声

// 黑色字体颜色
#define ColorWithBlack 0x363636
// 灰色字体颜色
#define ColorWithGeneralCharacter 0x6c6c6c
// 浅灰字体颜色
#define ColorWithLightGray 0x9A9A9A


// 全图绿色
#define ColorWithGreen 0x32be5a
// 全图红色
#define ColorWithHongSe 0xcb0a1b
// 全图深绿色
#define ColorWithGreenDeep 0x287450
// UITabBar背景色
#define ColorWithTabBar 0xf7f7f7
// 分界线的颜色
#define ColorWithBottomLine 0xcacaca
// 全图蓝绿色
#define ColorWithBlueAndGreen 0x08c0c2
// 全图橘黄色
#define ColorWithOrange 0xf74c31
// 全图黄色
#define ColorWithYellow 0xFFC332
// 黄色
#define ColorWithBackgroundYellow 0xffc332
// 全图蓝色
#define ColorWithBlue 0x2d9aff
// 天蓝色
#define ColorWithBlueTian 0x2d90ff
// table背景色
#define ColorWithTable 0xF0F0F0
// 积分颜色
#define ColorWithIntegral 0xFFAF3D
// 紫色
#define ColorWithZise 0xc776ff
// 灰色
#define ColorWithHuiSe 0xadadad
// 粉色
#define ColorWithFenSe 0xff4eb2
// 红色
#define ColorWithRed 0xEF262C
// 详情视图灰色背景
#define ColorWithInfoBackground 0xCCCCCC
// 橙色
#define ColorWithChengSe 0xff6530
//深橘黄色
#define ColorWithDeepOrange 0xff6530

// 主页背景
#define ColorWithIndex 0xf5f5f5


// 颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define RandomColor LVColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/*************************** 常用的 IPHONE 字体 *******************************************/
// 字体大小
#define FontSizeBigSuper           ([UIFont systemFontSize] + 10)// 超级大
#define FontSizeBigThree           ([UIFont systemFontSize] + 4) // 大大
#define FontSizeBigTwo             ([UIFont systemFontSize] + 2) // 大
#define FontSizeBigOne             ([UIFont systemFontSize] + 1) // 中大
#define FontSizeNormal             ([UIFont systemFontSize])     // 普通
#define FontSizeSmallOne           ([UIFont systemFontSize] - 1) // 中小
#define FontSizeSmallTwo           ([UIFont systemFontSize] - 2) // 小
#define FontSizeSmallThree         ([UIFont systemFontSize] - 4) // 小小
//#define FontName                   @"FZXQJW--GB1-0"
#define FontName                   @"Helvetica"

#define banner_Height 110

#endif /* Development_h */




/**

// 系统内部推送，不记录在通知栏中
[AppTool sendNotificationWithShowText:@"0000" andVoice:NO andOnTouch:^{
    NSLog(@"--------------");
}];

*/
