//
//  GoodsYouLikeCell.m
//  huabi
//
//  Created by hy on 2018/3/9.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "GoodsYouLikeCell.h"
#import "FlashBuyModel.h"
#import "Newyuanmeng-Swift.h"
#define cellWH ScreenWidth/3 - 30
@interface GoodsYouLikeCell ()

/* 图片 */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* 标题 */
@property (strong , nonatomic)UILabel *goodsLabel;

/** 原价 */
@property (nonatomic, strong) UILabel *oldPrice;

/* 价格 */
@property (strong , nonatomic)UILabel *priceLabel;
@end

@implementation GoodsYouLikeCell

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
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_goodsImageView];
    
    _goodsLabel = [[UILabel alloc] init];
    _goodsLabel.font = [UIFont systemFontOfSize:12];
    _goodsLabel.textColor = [UIColor blackColor];
    _goodsLabel.numberOfLines = 2;
    _goodsLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_goodsLabel];
    
    _oldPrice = [[UILabel alloc] init];
    _oldPrice.font = [UIFont systemFontOfSize:10];
    _oldPrice.textColor = [UIColor colorWithHexString:@"#eaeaea"];
    _oldPrice.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_oldPrice];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.font = [UIFont systemFontOfSize:12];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLabel];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self) setOffset:10];
        make.size.mas_equalTo(CGSizeMake(cellWH, cellWH));
    }];
    
    [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_goodsImageView).offset(10);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.8);
    }];
    
    [_oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_goodsLabel).offset(10);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.5);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLabel).offset(10);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.5);
    }];
    
}

-(void)setYouLikeItem:(FlashBuyModel *)youLikeItem
{
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:youLikeItem.img]];
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[youLikeItem.price floatValue]];
    _goodsLabel.text = youLikeItem.name;
    _oldPrice.text = youLikeItem.sell_price;
}

@end
