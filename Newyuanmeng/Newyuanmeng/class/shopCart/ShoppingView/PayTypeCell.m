//
//  PayTypeCell.m
//  huabi
//
//  Created by TeamMac2 on 16/12/10.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "PayTypeCell.h"

@implementation PayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setTitleWithTitle];
    }
    return self;
}

-(void)setTitleWithTitle{
    self.cellIcon = [UIImageView new];
    [self.contentView addSubview:self.cellIcon];
    self.cellIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.cellIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(20*ScaleWidth);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(70*ScaleWidth);
        make.height.mas_equalTo(70*ScaleWidth);
    }];
    
    self.icon = [UIImageView new];
    [self.icon setImage:[UIImage imageNamed:@"c213"]];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-20*ScaleWidth);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(16*ScaleWidth);
        make.height.mas_equalTo(16*ScaleWidth);
    }];
    // 255 48 138
    self.cellTitle = [UILabel new];
    self.cellTitle.textColor = [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    self.cellTitle.font = [UIFont systemFontOfSize:28*ScaleWidth];
    self.cellTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.cellTitle];
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cellIcon.mas_right).mas_offset(23*ScaleWidth);
        make.top.mas_equalTo(self.cellIcon.mas_top).mas_offset(0*ScaleWidth);
        
    }];
    
    self.cellTitle2 = [UILabel new];
    self.cellTitle2.textColor = [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    self.cellTitle2.font = [UIFont systemFontOfSize:32*ScaleWidth];
    self.cellTitle2.textAlignment = NSTextAlignmentLeft;
    self.cellTitle2.text = @"Apple Pay";
    [self.contentView addSubview:self.cellTitle2];
    [self.cellTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cellIcon.mas_right).mas_offset(23*ScaleWidth);
        make.centerY.mas_equalTo(self);
        
    }];
    
    self.cellIcon2 = [UIImageView new];
    [self.cellIcon2 setImage:[UIImage imageNamed:@"yinlian"]];
    self.cellIcon2.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.cellIcon2];
    [self.cellIcon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cellTitle2.mas_right).mas_offset(60*ScaleWidth);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo((146.0*60.0/90.0)*ScaleWidth);
        make.height.mas_equalTo(60*ScaleWidth);
    }];
    
    self.cellIcon3 = [UIImageView new];
    [self.cellIcon3 setImage:[UIImage imageNamed:@"sf"]];
    self.cellIcon3.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.cellIcon3];
    [self.cellIcon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cellIcon2.mas_right).mas_offset(20*ScaleWidth);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo((102.0*60.0/55.0)*ScaleWidth);
        make.height.mas_equalTo(60*ScaleWidth);
    }];
    
    self.cellContent = [UILabel new];
    self.cellContent.textColor = [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1];
    self.cellContent.font = [UIFont systemFontOfSize:22*ScaleWidth];
    self.cellContent.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.cellContent];
    [self.cellContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cellTitle.mas_left).mas_offset(0*ScaleWidth);
        make.bottom.mas_equalTo(self.cellIcon.mas_bottom).mas_offset(0*ScaleWidth);
        make.right.mas_equalTo(self.mas_right).mas_equalTo(-10);
        
    }];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [self.contentView addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    self.line2 = [UIView new];
    self.line2.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [self.contentView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self.mas_left).mas_offset(20*ScaleWidth);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
    }];
}

-(void)setCellTitleWithNumb:(NSString *)title content:(NSString *)content icon:(NSString *)icon isUpay:(BOOL)isUpay{
    self.cellTitle.text = title;
    self.cellContent.text = content;
    [self.cellIcon setImage:[UIImage imageNamed:icon]];
    self.cellTitle2.hidden = !isUpay;
    self.cellIcon2.hidden = !isUpay;
    self.cellIcon3.hidden = !isUpay;
    if (isUpay) {
        [self.cellIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((146.0*60.0/90.0)*ScaleWidth);
            make.height.mas_equalTo(60*ScaleWidth);
        }];
    }else{
        [self.cellIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70*ScaleWidth);
            make.height.mas_equalTo(70*ScaleWidth);
        }];
        

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
