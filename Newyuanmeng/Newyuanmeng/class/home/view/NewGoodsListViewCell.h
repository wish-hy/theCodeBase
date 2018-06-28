//
//  NewGoodsListViewCell.h
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//

typedef void(^DidSelect)(NSString *str ,BOOL isPointBuy);
#import <UIKit/UIKit.h>

@class FlashBuyModel;


@interface NewGoodsListViewCell : UICollectionViewCell

/* collection */
@property (strong , nonatomic)UICollectionView *collectionView;

/* 推荐商品数据 */
@property (strong , nonatomic)NSArray<FlashBuyModel *> *countDownItem;

@property (nonatomic, copy) DidSelect didSelect;

@property (nonatomic, assign) BOOL isPointBuy;
@end
