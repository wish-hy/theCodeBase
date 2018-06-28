//
//  HYRecommendViewCell.m
//  study
//
//  Created by hy on 2018/4/24.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYRecommendViewCell.h"

@implementation HYRecommendViewCell

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
    _image = [[UIImageView alloc] init];
    _image.image = [UIImage imageNamed:_urlStr];
    [self addSubview:_image];
}

-(void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    [_image sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[HYToolsKit createImageWithColor:RandomColor]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _image.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}
@end
