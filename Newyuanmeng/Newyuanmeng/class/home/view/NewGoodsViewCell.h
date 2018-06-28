//
//  NewGoodsViewCell.h
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//  新品专区

#import <UIKit/UIKit.h>
typedef void(^SelectBanner)();
typedef void(^SelectFount)();
@interface NewGoodsViewCell : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *banner;
@property (weak, nonatomic) IBOutlet UIImageView *everyDayFound;

@property (nonatomic, copy) SelectBanner selectBanner;

@property (nonatomic, copy) SelectFount selectFount;
@end
