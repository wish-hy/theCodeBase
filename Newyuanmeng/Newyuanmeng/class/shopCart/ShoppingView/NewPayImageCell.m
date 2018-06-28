//
//  NewPayImageCell.m
//  huabi
//
//  Created by 刘桐林 on 2017/1/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "NewPayImageCell.h"

@implementation NewPayImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleWithIcon];
        self.layer.borderColor = color_Border_Line.CGColor;
        self.layer.borderWidth = 1*ScaleWidth;
    }
    return self;
}

- (void)setTitleWithIcon {
    self.icon = [UIImageView new];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(self);
    }];
}
@end
