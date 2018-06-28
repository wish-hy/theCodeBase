//
//  HYScrollImageView.h
//  study
//
//  Created by hy on 2018/4/19.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBanner)(NSInteger i);

typedef void(^DidSelect)(NSString *str);

@interface HYScrollImageView : UICollectionReusableView

/* 轮播图数组 */
@property (copy , nonatomic)NSArray *imageGroupArray;

@property (nonatomic, copy) ClickBanner banner;

/* collection */
@property (strong , nonatomic)UICollectionView *collectionView;

/* 数据 */
@property (strong , nonatomic)NSArray *countDownItem;

@property (nonatomic, copy) DidSelect didSelect;

@end
