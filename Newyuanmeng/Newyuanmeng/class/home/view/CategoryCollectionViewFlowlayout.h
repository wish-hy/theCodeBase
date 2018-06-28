//
//  CategoryCollectionViewFlowlayout.h
//  huabi
//
//  Created by hy on 2018/3/9.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryCollectionViewFlowlayoutDelegate <NSObject>

@optional

/* 头部高度 */
-(CGFloat)HeightOfSectionHeaderForIndexPath:(NSIndexPath *)indexPath;
/* 尾部高度 */
-(CGFloat)HeightOfSectionFooterForIndexPath:(NSIndexPath *)indexPath;

@end


@interface CategoryCollectionViewFlowlayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id<CategoryCollectionViewFlowlayoutDelegate>delegate;

@end
