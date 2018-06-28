//
//  NewGoodsListViewCell.m
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "NewGoodsListViewCell.h"
#import "FlashBuyModel.h"
#import "GoodsListDetailViewCell.h"
#import "FlashBuyModel.h"
@interface NewGoodsListViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* 底部 */
@property (strong , nonatomic)UIView *bottomLineView;

@end


@implementation NewGoodsListViewCell

#pragma mark - lazyload
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 1;
        layout.itemSize = CGSizeMake(self.frame.size.height * 0.65, self.frame.size.height * 0.9);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[GoodsListDetailViewCell class] forCellWithReuseIdentifier:@"GoodsListDetailViewCell"];
    }
    return _collectionView;
}

-(NSArray<FlashBuyModel *> *)countDownItem
{
    if (!_countDownItem) {
        _countDownItem = [NSArray array];
    }
    return _countDownItem;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    self.collectionView.backgroundColor = self.backgroundColor;
//    NSArray *countDownArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"CountDownShop.plist" ofType:nil]];
//    _countDownItem = [RecommendItem mj_objectArrayWithKeyValuesArray:countDownArray];
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomLineView];
    _bottomLineView.frame = CGRectMake(0, self.frame.size.height - 8, ScreenWidth, 8);
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Setter Getter Methods
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _countDownItem.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListDetailViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsListDetailViewCell" forIndexPath:indexPath];
    cell.recommendItem = _countDownItem[indexPath.row];
    return cell;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if (_isPointBuy) {  // 普通积分购买
        self.didSelect(str,YES);
    }else{
        self.didSelect(str,NO);
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

@end
