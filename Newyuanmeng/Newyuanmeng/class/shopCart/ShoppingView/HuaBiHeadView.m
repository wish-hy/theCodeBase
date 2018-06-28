//
//  HuaBiHeadView.m
//  huabi
//
//  Created by TeamMac2 on 16/12/14.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import "HuaBiHeadView.h"

@implementation HuaBiHeadView

+(instancetype)HeaderViewWithTableView:(UITableView *)tableView withIdentifier:(NSString *)ID
{
    HuaBiHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headView == nil) {
        headView = [[HuaBiHeadView alloc]initWithReuseIdentifier:ID];
        [headView setTitleWithImage];
        
    }
    headView.contentView.backgroundColor = HEXCOLOR(0xffffff);
    return headView;
}

-(void)setTitleWithImage{
 
    self.text1 = [UILabel new];
    self.text1.textColor = HEXCOLOR(0x8a8a8a);
    self.text1.font = [UIFont systemFontOfSize:30*ScaleWidth];
    self.text1.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.text1];
    [self.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).mas_offset(30*ScaleWidth);
        
    }];
    
    self.text2 = [UILabel new];
    self.text2.textColor = HEXCOLOR(0x8a8a8a);
    self.text2.font = [UIFont systemFontOfSize:30*ScaleWidth];
    self.text2.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.text2];
    [self.text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.text1.mas_right).mas_offset(30*ScaleWidth);
        
    }];
    
    self.text3 = [UILabel new];
    self.text3.textColor = HEXCOLOR(0x8a8a8a);
    self.text3.font = [UIFont systemFontOfSize:30*ScaleWidth];
    self.text3.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.text3];
    [self.text3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(-30*ScaleWidth);
        
    }];
    
    self.icon = [UIImageView new];
    [self.icon setImage:[UIImage imageNamed:@"c213"]];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(-22*ScaleWidth);
        make.width.height.mas_equalTo(16*ScaleWidth);
    }];
    
    self.topline = [UIView new];
    self.topline.backgroundColor = HEXCOLOR(0xdfdfdf);
    [self.contentView addSubview:self.topline];
    [self.topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(2*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    self.bottomline = [UIView new];
    self.bottomline.backgroundColor = HEXCOLOR(0xdfdfdf);
    [self.contentView addSubview:self.bottomline];
    [self.bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0*ScaleWidth);
        make.height.mas_equalTo(2*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    self.select = [UIButton new];
    self.select.backgroundColor  =[UIColor clearColor];
    self.select.tag = self.tag;
    [self.contentView addSubview:self.select];
    [self.select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.height.mas_equalTo(self);
    }];
}

-(void)setHeadInfo:(NSString *)title content:(NSString *)content text:(NSString *)text section:(NSInteger)section
{
    self.text1.text = title;
    self.text3.text = content;
    self.text2.text = text;
    if (section == 1) {
        self.icon.hidden = NO;
        [self.text3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-22*ScaleWidth-16*ScaleWidth);
            
        }];
    }else{
        self.icon.hidden = YES;
        [self.text3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-30*ScaleWidth);
            
        }];
    }

}
@end
