//
//  MoreCategoryViewCell.m
//  huabi
//
//  Created by hy on 2018/3/9.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "MoreCategoryViewCell.h"


#import "GoodsHandheldCell.h"

#import "CategoryCollectionViewFlowlayout.h"

@interface MoreCategoryViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,CategoryCollectionViewFlowlayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MoreCategoryViewCell

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        CategoryCollectionViewFlowlayout *flowlayout = [[CategoryCollectionViewFlowlayout alloc] init];
        flowlayout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.frame = self.bounds;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpBase];
    }
    return self;
}

#pragma mark - initialize
- (void)setUpBase
{
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = self.backgroundColor;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}


@end
