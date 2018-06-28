//
//  VIPView1.m
//  huabi
//
//  Created by teammac3 on 2017/6/5.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "VIPView1.h"
#import "VIPCell.h"
#import "VIPModel.h"
#import "VillageIcon.h"
#import "UIImageView+WebCache.h"

@interface VIPView1() <UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation VIPView1

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame: frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark - 数据
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self createCollectionView];
}

#pragma mark - 创建集合视图
- (void)createCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((ScreenWidth-2*8)/3, 200);
    flowLayout.minimumLineSpacing = 10*ScaleWidth;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) collectionViewLayout:flowLayout];
    collectionV.userInteractionEnabled = YES;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor clearColor];
    collectionV.delegate = self;
    collectionV.dataSource = self;

    //注册Item
    [collectionV registerClass:[VIPCell class] forCellWithReuseIdentifier:@"CellID"];
    [self addSubview:collectionV];
}

#pragma mark - 集合视图的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cols;
}
- (VIPCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VIPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor yellowColor];
//    NSLog(@"下标————%ld",indexPath.item);
////        NSLog(@"_cols个数  %ld————————————_arr2.count___%ld",_cols,_arr1.count);
    VIPModel *model = _dataArr[indexPath.item];
    NSString *str = [NSString stringWithFormat:@"%@%@",imgHost,model.img];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"moren"]];
    cell.title.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    VIPModel *model = _dataArr[indexPath.item];
    self.block(model.vip_id);
//    NSLog(@"测试1");
}

@end
