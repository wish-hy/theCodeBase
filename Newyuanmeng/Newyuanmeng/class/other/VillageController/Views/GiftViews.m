//
//  GiftViews.m
//  huabi
//
//  Created by teammac3 on 2017/6/9.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "GiftViews.h"
#import "GiftModel.h"
#import "VillageIcon.h"

@interface GiftViews ()<UICollectionViewDelegate,UICollectionViewDataSource>

//商品名
@property(nonatomic,weak)UILabel *nameL;
@property(nonatomic,weak)UICollectionView *collectionV;
//选中视图
@property(nonatomic,strong)UIView *selectV;

@end
@implementation GiftViews

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
    }
    return self;
}

#pragma mark - 加载视图数据
- (void)setModelArr:(NSArray *)modelArr{
    _modelArr = modelArr;
    [self createUI];
}

#pragma mark - 创建UI
- (void)createUI{
    
    UILabel *titleL = [UILabel new];
    titleL.textColor = [UIColor redColor];
    titleL.font = [UIFont systemFontOfSize:11];
    titleL.text = @"套餐礼品选择";
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    //name
    UILabel *nameL = [UILabel new];
    nameL.textColor = [UIColor redColor];
    nameL.font = [UIFont systemFontOfSize:11];
    nameL.text = @"";
    [self addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).mas_offset(0);
        make.left.mas_equalTo(titleL.mas_right).mas_offset(0);
        make.right.mas_equalTo(self).mas_offset(10);
        make.height.mas_equalTo(20);
    }];
    self.nameL = nameL;
    
    //礼品
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(60, 60);
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-20, 60) collectionViewLayout:flowLayout];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionV];
    self.collectionV = collectionV;
    //注册
    [collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
}

#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _modelArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    UIImageView *img = [UIImageView new];
    GiftModel *model = _modelArr[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@%@",imgHost,model.img];
    [img sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"moren"]];
    [cell.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(cell);
        make.centerY.mas_equalTo(cell);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    if (indexPath.item == 0) {
        
        _selectV = [[UIView alloc] initWithFrame:CGRectMake(70*indexPath.item, 0, 60, 60)];
        _selectV.backgroundColor = [UIColor clearColor];
        _selectV.layer.borderWidth = 1;
        _selectV.layer.borderColor = [UIColor redColor].CGColor;
        [self.collectionV addSubview:_selectV];
        self.nameL.text = model.name;
        self.block(model.gift_id);

    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectV.frame = CGRectMake(70*indexPath.item, 0, 60, 60);
    GiftModel *model = _modelArr[indexPath.item];
    self.nameL.text = model.name;
    self.block(model.gift_id);
}

@end
