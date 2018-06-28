//
//  GoodsListDetailViewCell.m
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "GoodsListDetailViewCell.h"

#import "FlashBuyModel.h"

@interface GoodsListDetailViewCell ()
/* 图片 */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* 价格 */
@property (strong , nonatomic)UILabel *priceLabel;
/* 商品名 */
@property (strong , nonatomic)UILabel *stockLabel;
/* 原价 */
@property (strong , nonatomic)UILabel *natureLabel;
@end

@implementation GoodsListDetailViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_goodsImageView];
    
    _stockLabel = [[UILabel alloc] init];
    _stockLabel.textColor = [UIColor darkGrayColor];
    _stockLabel.font = [UIFont systemFontOfSize:10];
    _stockLabel.numberOfLines = 2;
    _stockLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_stockLabel];
    
    _natureLabel = [[UILabel alloc] init];
    _natureLabel.textAlignment = NSTextAlignmentCenter;
    _natureLabel.font = [UIFont systemFontOfSize:8];
    _natureLabel.textColor = [UIColor grayColor];
    [_goodsImageView addSubview:_natureLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont systemFontOfSize:11];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLabel];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(10);
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.height.mas_equalTo(self.frame.size.width * 0.6);
    }];
    
    [_stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(_goodsImageView.mas_bottom)setOffset:2];
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self);
    
    }];
    
    [_natureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(_stockLabel.mas_bottom)setOffset:2];
        make.centerX.mas_equalTo(self);
        
//        make.bottom.mas_equalTo(_goodsImageView.mas_bottom);
//        make.left.mas_equalTo(_goodsImageView);
//        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(_natureLabel.mas_bottom)setOffset:2];
        make.centerX.mas_equalTo(self);
//                [make.top.mas_equalTo(_priceLabel.mas_bottom)setOffset:2];
//                make.centerX.mas_equalTo(self);
    }];
    
}

#pragma mark - Setter Getter Methods
- (void)setRecommendItem:(FlashBuyModel *)recommendItem
{
    _recommendItem = recommendItem;
    
    if ([[recommendItem.img substringToIndex:4] isEqualToString:@"http"]) {
        
        [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:recommendItem.img]placeholderImage:[UIImage imageNamed:@"default_49_11"]];
    }else{
        NSURL *urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,recommendItem.img]];
        [_goodsImageView sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"default_49_11"]];
    }
    
    _stockLabel.text = recommendItem.name;
    
    _natureLabel.text = recommendItem.sell_price;
    
    NSString *oldPrice = recommendItem.sell_price;
    NSUInteger length = [oldPrice length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
    [_natureLabel setAttributedText:attri];
    
    if ([recommendItem.cost_point intValue] > 0) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%@+%@积分",recommendItem.price,recommendItem.cost_point];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",recommendItem.price];
    }
    
}

@end
