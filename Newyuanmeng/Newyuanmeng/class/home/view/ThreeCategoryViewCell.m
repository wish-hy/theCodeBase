//
//  ThreeCategoryViewCell.m
//  huabi
//
//  Created by hy on 2018/3/10.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "ThreeCategoryViewCell.h"


@implementation ThreeCategoryViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    _ads1 = [[UIImageView alloc] init];
    _ads1.tag = 0;
    _ads1.userInteractionEnabled = YES;
    _ads1.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *ads1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_ads1 addGestureRecognizer:ads1];
    [self addSubview:_ads1];
    
    _image1 = [[UIImageView alloc] init];
    _image1.tag = 2;
    _image1.userInteractionEnabled = YES;
    _image1.contentMode = UIViewContentModeScaleAspectFit;
    _image1.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *ads2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image1 addGestureRecognizer:ads2];
    [self addSubview:_image1];
    
    _image2 = [[UIImageView alloc] init];
    _image2.tag = 3;
    _image2.userInteractionEnabled = YES;
    _image2.contentMode = UIViewContentModeScaleAspectFit;
    _image2.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *ads3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image2 addGestureRecognizer:ads3];
    [self addSubview:_image2];
    
    _image3 = [[UIImageView alloc] init];
    _image3.tag = 4;
    _image3.userInteractionEnabled = YES;
    _image3.contentMode = UIViewContentModeScaleAspectFit;
    _image3.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *ads4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image3 addGestureRecognizer:ads4];
    [self addSubview:_image3];
    
    _ads2 = [[UIImageView alloc] init];
    _ads2.tag = 1;
    _ads2.userInteractionEnabled = YES;
    _ads2.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *ads5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_ads2 addGestureRecognizer:ads5];
    [self addSubview:_ads2];
    
    _ads1.clipsToBounds = YES;
    _ads2.clipsToBounds = YES;
}

-(void)click:(UITapGestureRecognizer *)sender
{

    NSLog(@"%d",(int)sender.view.tag);
    switch (sender.view.tag) {
        case 0:
            self.index(0);
            break;
        case 1:
            self.index(1);
            break;
        case 2:
            self.index(2);
            break;
        case 3:
            self.index(3);
            break;
        case 4:
            self.index(4);
            break;
        default:
            break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_status == 0) {
        _ads1.frame = CGRectMake(0, 0,ScreenWidth,banner_Height);
        _image1.frame = CGRectMake(0, banner_Height, self.height - banner_Height - 1, self.height - banner_Height - 1);
         _ads2.frame = CGRectMake(0, _image1.y + _image1.height, ScreenWidth,0);
    }else{
        _ads1.frame = CGRectMake(0, 0, ScreenWidth, 0);
        _image1.frame = CGRectMake(0, 0, self.height - banner_Height - 1, self.height - banner_Height - 1);
        _ads2.frame = CGRectMake(0, _image1.y + _image1.height, ScreenWidth,banner_Height);
    }
    
    _image2.frame = CGRectMake(_image1.width + 1, _image1.y, ScreenWidth - _image1.width - 1, (self.height - banner_Height)/2 - 1);
    _image3.frame = CGRectMake(_image1.width + 1, _image2.y + _image2.height + 1, ScreenWidth - _image1.width - 1, (self.height - banner_Height)/2 - 1);
   
}

@end
