//
//  NewPayHeadView.m
//  huabi
//
//  Created by 刘桐林 on 2017/1/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "NewPayHeadView.h"

@implementation NewPayHeadView

+(instancetype)HeaderViewWithTableView:(UITableView *)tableView withIdentifier:(NSString *)ID
{
    NewPayHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headView == nil) {
        headView = [[NewPayHeadView alloc]initWithReuseIdentifier:ID];
        [headView initSetting];
    }
    return headView;
}

- (void)initSetting{
    self.headTitle = [UILabel new];
    self.headTitle.textColor = HEXCOLOR(0x303030);
    self.headTitle.font = [UIFont systemFontOfSize:28*ScaleWidth];
    self.headTitle.textAlignment = NSTextAlignmentLeft;
    self.headTitle.text = @"";
    [self.contentView addSubview:self.headTitle];
    [self.headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).mas_offset(32*ScaleWidth);
    }];
    
    self.headcontent = [UILabel new];
    self.headcontent.textColor = HEXCOLOR(0x303030);
    self.headcontent.font = [UIFont systemFontOfSize:28*ScaleWidth];
    self.headcontent.textAlignment = NSTextAlignmentRight;
    self.headcontent.text = @"";
    [self.contentView addSubview:self.headcontent];
    [self.headcontent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(-36*ScaleWidth);
    }];
    
    self.switchs = [ZJSwitch new];
    [self.contentView addSubview:self.switchs];
    self.switchs.onTintColor = HEXCOLOR(0xffa200);
    self.switchs.tintColor = HEXCOLOR(0x8a8a8a);
    self.switchs.onText = @"需要";
    self.switchs.offText = @"不需要";
    [self.switchs setOn:NO];
    [self.switchs addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    [self.switchs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(-36*ScaleWidth);
        make.height.mas_equalTo(60*ScaleWidth);
        make.width.mas_equalTo(140*ScaleWidth);
    }];
    
    self.line = [UIView new];
    self.line.backgroundColor = HEXCOLOR(0xdfdfdf);
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(2*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
}

-(void)handleSwitchEvent:(ZJSwitch *)sender
{
    if (_singleClick) {
        _singleClick(sender.isOn);
    }
}

@end
