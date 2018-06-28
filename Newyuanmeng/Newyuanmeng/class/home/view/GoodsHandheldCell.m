//
//  GoodsHandheldCell.m
//  huabi
//
//  Created by hy on 2018/3/9.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "GoodsHandheldCell.h"

@interface GoodsHandheldCell ()

@property (nonatomic, strong) UIImageView *handheldImageView;

@end

@implementation GoodsHandheldCell

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
    _handheldImageView = [[UIImageView alloc] init];
    _handheldImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_handheldImageView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_handheldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

-(void)setHandheldImage:(NSString *)handheldImage
{
    _handheldImage = handheldImage;
    [_handheldImageView sd_setImageWithURL:[NSURL URLWithString:handheldImage]];
}


@end
