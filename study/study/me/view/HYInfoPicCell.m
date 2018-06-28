//
//  HYInfoPicCell.m
//  study
//
//  Created by hy on 2018/5/23.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYInfoPicCell.h"

@interface HYInfoPicCell ()
@property (nonatomic ,strong) UIImageView *img;
@end

@implementation HYInfoPicCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatSubView];
        
    }
    return self;
}

-(void)creatSubView
{
    _img = [[UIImageView alloc] init];
    [self addSubview:_img];
}

-(void)layoutSubviews
{
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}

-(void)setUrlStr:(NSString *)urlStr
{
    [_img sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}

@end
