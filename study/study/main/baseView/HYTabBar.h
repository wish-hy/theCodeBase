//
//  HYTabBar.h
//  fileManager
//
//  Created by hy on 2018/3/28.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Click)(void);

@interface HYTabBar : UITabBar

@property (nonatomic,copy)Click click;
@end
