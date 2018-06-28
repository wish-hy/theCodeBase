//
//  GoodsYouLikeCell.h
//  huabi
//
//  Created by hy on 2018/3/9.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlashBuyModel;

@interface GoodsYouLikeCell : UICollectionViewCell

/* 推荐数据 */
@property (strong , nonatomic)FlashBuyModel *youLikeItem;

@end
