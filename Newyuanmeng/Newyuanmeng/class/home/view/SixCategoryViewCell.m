//
//  SixCategoryViewCell.m
//  huabi
//
//  Created by hy on 2018/3/10.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "SixCategoryViewCell.h"

@implementation SixCategoryViewCell

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
    self.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    _ads1 = [[UIImageView alloc] init];
    _ads1.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_ads1];
    
    _image1 = [[UIImageView alloc] init];
    _image1.contentMode = UIViewContentModeScaleAspectFit;
    _image1.backgroundColor = [UIColor whiteColor];
    [self addSubview:_image1];
    
    _image2 = [[UIImageView alloc] init];
    _image2.contentMode = UIViewContentModeScaleAspectFit;
    _image2.backgroundColor = [UIColor whiteColor];
    [self addSubview:_image2];
    
    _image3 = [[UIImageView alloc] init];
    _image3.contentMode = UIViewContentModeScaleAspectFit;
    _image3.backgroundColor = [UIColor whiteColor];
    [self addSubview:_image3];
    
    _image4 = [[UIImageView alloc] init];
    _image4.contentMode = UIViewContentModeScaleAspectFit;
    _image4.backgroundColor = [UIColor whiteColor];
    [self addSubview:_image4];
    
    _image5 = [[UIImageView alloc] init];
    _image5.contentMode = UIViewContentModeScaleAspectFit;
    _image5.backgroundColor = [UIColor whiteColor];
    [self addSubview:_image5];
    
    _image6 = [[UIImageView alloc] init];
    _image6.contentMode = UIViewContentModeScaleAspectFit;
    _image6.backgroundColor = [UIColor whiteColor];
    [self addSubview:_image6];
    
    _ads2 = [[UIImageView alloc] init];
    _ads2.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_ads2];
    
    _ads1.clipsToBounds = YES;
    _ads2.clipsToBounds = YES;
    
    _ads1.tag = 0;
    _ads1.userInteractionEnabled = YES;
    UITapGestureRecognizer *ads1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_ads1 addGestureRecognizer:ads1];
    
    _ads2.tag = 1;
    _ads2.userInteractionEnabled = YES;
    UITapGestureRecognizer *ads7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_ads2 addGestureRecognizer:ads7];
    
    _image1.tag = 2;
    _image1.userInteractionEnabled = YES;
    UITapGestureRecognizer *ads2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image1 addGestureRecognizer:ads2];
    
    _image2.tag = 3;
    _image2.userInteractionEnabled = YES;
    UITapGestureRecognizer *ads3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image2 addGestureRecognizer:ads3];
    
    _image3.tag = 4;
    _image3.userInteractionEnabled = YES;
    UITapGestureRecognizer *ads4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image3 addGestureRecognizer:ads4];
    
    _image4.tag = 5;
    _image4.userInteractionEnabled = YES;
    UITapGestureRecognizer *ads5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image4 addGestureRecognizer:ads5];
    
    _image5.tag = 6;
    _image5.userInteractionEnabled = YES;
    UITapGestureRecognizer *ads6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image5 addGestureRecognizer:ads6];
    
    _image6.tag = 7;
    _image6.userInteractionEnabled = YES;
    UITapGestureRecognizer *ads8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_image6 addGestureRecognizer:ads8];
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
        case 5:
            self.index(5);
            break;
        case 6:
            self.index(6);
            break;
        case 7:
            self.index(7);
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
        _image1.frame = CGRectMake(0, banner_Height, ScreenWidth/3 - 1, (self.height - banner_Height)/2 - 1);
        _ads2.frame = CGRectMake(0, self.height - banner_Height, ScreenWidth, 0);
    }else{
        _ads1.frame = CGRectMake(0, 0, ScreenWidth, 0);
        _image1.frame = CGRectMake(0, 0, ScreenWidth/3 - 1, (self.height - banner_Height)/2 - 1);
        _ads2.frame = CGRectMake(0,self.height - banner_Height, ScreenWidth, banner_Height);
    }
    _image2.frame = CGRectMake(_image1.width + 1, _image1.y,ScreenWidth/3 - 1, (self.height - banner_Height)/2 - 1);
    _image3.frame = CGRectMake(_image1.width * 2 + 2, _image1.y,ScreenWidth/3 - 1, (self.height - banner_Height)/2 - 1);
    _image4.frame = CGRectMake(0, _image1.y + _image1.height + 1,ScreenWidth/3 - 1, (self.height - banner_Height)/2 - 1);
    _image5.frame = CGRectMake(_image1.width + 1,_image1.y + _image1.height + 1,ScreenWidth/3 - 1, (self.height - banner_Height)/2 - 1);
    _image6.frame = CGRectMake(_image1.width * 2 + 2,_image1.y + _image1.height + 1,ScreenWidth/3 - 1, (self.height - banner_Height)/2 - 1);
}

@end
