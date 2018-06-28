//
//  HYLayout.h
//  study
//
//  Created by hy on 2018/4/21.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooter;

@class HYLayout;

@protocol HYWaterfallLayoutDelegate <NSObject>

@required
//计算item高度的代理方法，将item的高度与indexPath传递给外界
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@optional
//区列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout colCountForSectionAtIndex:(NSInteger)section;

//区内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;

//垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

//设置区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HYLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

//设置区尾大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HYLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface HYLayout : UICollectionViewLayout

//代理，用来计算item的高度
@property (nonatomic, weak) id<HYWaterfallLayoutDelegate> delegate;

@property(nonatomic, assign)UIEdgeInsets sectionInset;//内边距
@property(nonatomic, assign)CGFloat lineSpacing;//行间距
@property(nonatomic, assign)CGFloat itemSpacing;//垂直间距
@property(nonatomic, assign)CGFloat colCount;//列数

@property (nonatomic) BOOL stickyHeader;
@end
