//
//  HYCustomButton.m
//  study
//
//  Created by hy on 2018/5/6.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYCustomButton.h"

@interface HYCustomButton ()

@property (nonatomic ,strong)UIButton *btn1;

@property (nonatomic ,strong)UIButton *btn2;

@end

@implementation HYCustomButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1 = btn1;
//        [btn1 setBackgroundImage:[UIImage imageNamed:@"publish_nomer"] forState:UIControlStateNormal];
//        [btn1 setBackgroundImage:[UIImage imageNamed:@"publish_selected"] forState:UIControlStateHighlighted];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateHighlighted];
        btn1.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn1 sizeToFit];
        // 监听按钮点击（发布按钮）
        [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
        //        publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        [self addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2 = btn2;
//        [btn2 setBackgroundImage:[UIImage imageNamed:@"publish_nomer"] forState:UIControlStateNormal];
//        [btn2 setBackgroundImage:[UIImage imageNamed:@"publish_selected"] forState:UIControlStateHighlighted];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateHighlighted];
        btn2.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn2 sizeToFit];
        // 监听按钮点击（发布按钮）
        [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
        //        publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        [self addSubview:btn2];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.frame.size.height / 2);
    }];
    
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.frame.size.height / 2);
    }];
    
}

-(void)btn1Click
{
//    self.click();
    HYLog(@"点点点点");
}

-(void)btn2Click
{
//    self.click();
    HYLog(@"点点点点1");
}

-(void)setTitle1:(NSString *)title1 Title2:(NSString *)title2
{
    [_btn1 setTitle:title1 forState:UIControlStateNormal];
    [_btn1 setTitle:title1 forState:UIControlStateHighlighted];
    
    [_btn2 setTitle:title2 forState:UIControlStateNormal];
    [_btn2 setTitle:title2 forState:UIControlStateHighlighted];
}

@end
