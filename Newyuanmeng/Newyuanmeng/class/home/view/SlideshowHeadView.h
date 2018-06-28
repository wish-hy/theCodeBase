//
//  SlideshowHeadView.h
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//  轮播图

#import <UIKit/UIKit.h>

typedef void(^ClickBanner)(NSInteger i);

@interface SlideshowHeadView : UICollectionReusableView

/* 轮播图数组 */
@property (copy , nonatomic)NSArray *imageGroupArray;

@property (nonatomic, copy) ClickBanner banner;

@end
