//
//  HYScrollImageView.m
//  study
//
//  Created by hy on 2018/4/19.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYScrollImageView.h"
#import "HYRecommendViewCell.h"
@interface HYScrollImageView ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;

@property (strong ,nonatomic)UIView *backGround;

@property (strong ,nonatomic)UILabel *titles;

@end

@implementation HYScrollImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height - 180) delegate:self placeholderImage:[HYToolsKit createImageWithColor:RandomColor]];
    //    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    _cycleScrollView.autoScrollTimeInterval = 3.0;
    [self addSubview:_cycleScrollView];
    
    _backGround = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 180, ScreenWidth, 160)];
    //    _backGround.backgroundColor = [UIColor yellowColor];
    [self addSubview:_backGround];
    
    
    _titles = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 40)];
    _titles.text = @"主题推荐";
    _titles.textColor = [UIColor blackColor];
    [self.backGround addSubview:_titles];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake(self.backGround.frame.size.height, self.backGround.frame.size.height - 50);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:_collectionView];
    _collectionView.frame = CGRectMake(0, 40, ScreenWidth, self.backGround.frame.size.height - 50);
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[HYRecommendViewCell class] forCellWithReuseIdentifier:@"HYRecommendViewCell"];
    
    [self.backGround addSubview:_collectionView];
    
    _countDownItem = @[@"http://p7mm0t0oh.bkt.clouddn.com/zhuti1.png",@"http://p7mm0t0oh.bkt.clouddn.com/zhuti2.png",@"http://p7mm0t0oh.bkt.clouddn.com/zhuti3.png",@"http://p7mm0t0oh.bkt.clouddn.com/zhuti1.png",@"http://p7mm0t0oh.bkt.clouddn.com/zhuti2.png",@"http://p7mm0t0oh.bkt.clouddn.com/zhuti3.png"];
}

-(void)setImageGroupArray:(NSArray *)imageGroupArray
{
    _imageGroupArray = imageGroupArray;
    _cycleScrollView.placeholderImage = [HYToolsKit createImageWithColor:RandomColor];
    if (imageGroupArray.count == 0) {
        return;
    }
    _cycleScrollView.imageURLStringsGroup = _imageGroupArray;
}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HYLog(@"点击了%zd轮播图",index);
    self.banner(index);
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}

-(NSArray *)countDownItem
{
    if (!_countDownItem) {
        _countDownItem = [NSArray array];
    }
    return _countDownItem;
}

#pragma mark -- uicollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _countDownItem.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYRecommendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYRecommendViewCell" forIndexPath:indexPath];
    cell.urlStr = _countDownItem[indexPath.row];
    
    cell.backgroundColor = RandomColor;
    return cell;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//    if (_isPointBuy) {  // 普通积分购买
//        self.didSelect(str,YES);
//    }else{
//        self.didSelect(str,NO);
//    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}


@end
