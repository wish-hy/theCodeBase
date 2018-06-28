//
//  ElBrowser.h
//  RACMVVMDemo
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElBrowser : UIView

/**
 大图图片数组
 */
@property (nonatomic, strong) NSArray *originalUrls;

/**
 小的图片数组
 */
@property (nonatomic, strong) NSArray *smallUrls;

/**
 图片间距
 */
@property (nonatomic, assign) CGFloat margin;

/**
 控件宽度
 */
@property (nonatomic, assign) CGFloat width;

@end
