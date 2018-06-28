//
//  YGTools.h
//  FindingSomething
//
//  Created by 韩伟 on 16/5/12.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YGTools : UIViewController
{
    void (^ _onTouched)();
}

+ (instancetype)sharedInstance;



//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string;

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string;

// app 名称
- (NSString *)getAppName;

// app 版本
- (NSString *)getAppVersion;


// 移除所有子视图
- (void)removeAllSubViews:(UIView *)faView;

@end
