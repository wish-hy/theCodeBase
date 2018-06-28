//
//  ShopDetailView.m
//  huabi
//
//  Created by teammac3 on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "ShopDetailView.h"

@implementation ShopDetailView
+ (instancetype)creatShopDetailView{
    {
        return [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailView" owner:self options:nil] firstObject];
    }
}
- (void)layoutSubviews{
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor =[UIColor clearColor];
    [self.bgvImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    self.whiteBgvView.layer.cornerRadius = 20*ScaleWidth;
    self.whiteBgvView.layer.masksToBounds = YES;
    [self.whiteBgvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(125*ScaleHeight);
        make.left.mas_equalTo(self.mas_left).mas_offset(19*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-12);
        make.height.mas_equalTo(140*ScaleHeight);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteBgvView.mas_top).mas_offset(7*ScaleHeight);
        make.left.mas_equalTo(self.whiteBgvView.mas_left).mas_offset(12*ScaleWidth);
        make.bottom.mas_equalTo(self.whiteBgvView.mas_bottom).mas_offset(-7*ScaleHeight);
        make.width.mas_equalTo(119*ScaleWidth);
    }];
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteBgvView.mas_top).mas_offset(15*ScaleHeight);
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(16*ScaleWidth);
        make.right.mas_equalTo(self.distanceIconImageView.mas_left).mas_offset(-10*ScaleWidth);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.whiteBgvView.mas_bottom).mas_offset(-15*ScaleHeight);
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(16*ScaleWidth);
        make.right.mas_equalTo(self.distanceIconImageView.mas_left).mas_offset(-10*ScaleWidth);
    }];
    self.distanceIconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6b3", 40*ScaleWidth,[UIColor colorWithRed:234/255.0 green:76/255.0 blue:30/255.0 alpha:1])];
    [self.distanceIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.whiteBgvView.mas_centerY);
        make.right.mas_equalTo(self.whiteBgvView.mas_right).mas_offset(-10*ScaleWidth);
        make.width.mas_equalTo(48*ScaleWidth);
        make.height.mas_equalTo(48*ScaleHeight);
    }];
    
    self.descLabel.numberOfLines = 3;
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteBgvView.mas_bottom).mas_offset(61*ScaleHeight);
        make.left.mas_equalTo(self.mas_left).mas_offset(33*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_offset(-33*ScaleWidth);
    }];
    self.stayButton.layer.masksToBounds = YES;
    self.stayButton.layer.cornerRadius = 20*ScaleWidth;
    [self.stayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left).mas_offset(20*ScaleWidth);
        make.right.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(45);
    }];
    self.enterShopButton.layer.masksToBounds = YES;
    self.enterShopButton.layer.cornerRadius = 20*ScaleWidth;
    [self.enterShopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right).mas_offset(-20*ScaleWidth);
        make.left.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(45);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.stayButton.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.stayButton.mas_right);
        make.width.mas_equalTo(1);
        make.top.bottom.mas_equalTo(self.stayButton);
    }];
    
    self.distanceIconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *map = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoShop)];
    [self.distanceIconImageView addGestureRecognizer:map];
}

-(void)gotoShop
{
    self.navgation();
}


- (IBAction)stayAction:(id)sender {
    self.buttonaction(0);
}
- (IBAction)enterAction:(id)sender {
    self.buttonaction(1);
}

@end
