//
//  GoodsGridCell.m
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//  功能网格

#import "GoodsGridCell.h"

#import "GridItem.h"

@interface GoodsGridCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *gridImageView;
/* gridLabel */
@property (strong , nonatomic)UILabel *gridLabel;
/* tagLabel */
@property (strong , nonatomic)UILabel *tagLabel;

@end

@implementation GoodsGridCell
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    _gridImageView = [[UIImageView alloc] init];
    _gridImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_gridImageView];
    
    _gridLabel = [[UILabel alloc] init];
    _gridLabel.font = [UIFont systemFontOfSize:10];
    _gridLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_gridLabel];
    
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.font = [UIFont systemFontOfSize:8];
    _tagLabel.backgroundColor = [UIColor whiteColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tagLabel];
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self)setOffset:10];
        if (ScreenHeight == 568) {
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }else{
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }
        make.centerX.mas_equalTo(self);
    }];
    
    [_gridLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_gridImageView.mas_bottom)setOffset:5];
    }];
    
    
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_gridImageView.mas_centerX);
        make.top.mas_equalTo(_gridImageView);
        make.size.mas_equalTo(CGSizeMake(35, 15));
    }];
    
}

#pragma mark - Setter Getter Methods
- (void)setGridItem:(GridItem *)gridItem
{
    _gridItem = gridItem;
    
    
    _gridLabel.text = gridItem.name;
//    _tagLabel.text = gridItem.gridTag;
    
//    _tagLabel.hidden = (gridItem.gridTag.length == 0) ? YES : NO;
    _tagLabel.hidden = YES;
//    _tagLabel.textColor = [UIColor colorWithHexString:gridItem.gridColor];
//    [DCSpeedy dc_chageControlCircularWith:_tagLabel AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:_tagLabel.textColor canMasksToBounds:YES];
    
    if (_gridItem.adimg.length == 0) return;
    if ([[_gridItem.adimg substringToIndex:4] isEqualToString:@"http"]) {
        
        [_gridImageView sd_setImageWithURL:[NSURL URLWithString:gridItem.adimg]placeholderImage:[UIImage imageNamed:@"default_49_11"]];
    }else{
        NSURL *urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgHost,gridItem.adimg]];
        [_gridImageView sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"default_49_11"]];
    }
}

@end
