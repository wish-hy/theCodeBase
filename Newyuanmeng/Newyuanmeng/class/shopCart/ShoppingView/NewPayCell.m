//
//  NewPayCell.m
//  huabi
//
//  Created by 刘桐林 on 2017/1/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "NewPayCell.h"

@implementation NewPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setTitleWithLevel];
    }
    return self;
}

-(void)setTitleWithLevel{
    self.cellTitle = [UILabel new];
    self.cellTitle.textColor = HEXCOLOR(0x303030);
    self.cellTitle.font = [UIFont systemFontOfSize:28*ScaleWidth];
    self.cellTitle.textAlignment = NSTextAlignmentLeft;
    self.cellTitle.text = @"";
    [self.contentView addSubview:self.cellTitle];
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).mas_offset(32*ScaleWidth);
    }];
    
    self.cellcontent = [UILabel new];
    self.cellcontent.textColor = HEXCOLOR(0x303030);
    self.cellcontent.font = [UIFont systemFontOfSize:28*ScaleWidth];
    self.cellcontent.textAlignment = NSTextAlignmentRight;
    self.cellcontent.text = @"";
    [self.contentView addSubview:self.cellcontent];
    [self.cellcontent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(-36*ScaleWidth);
    }];
    
    self.cellIcon = [UIImageView new];
    [self.cellIcon setImage:[UIImage imageNamed:@"jiangxu"]];
    [self.contentView addSubview:self.cellIcon];
    [self.cellIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(-36*ScaleWidth);
    }];
    
    self.cellInvoice = [UILabel new];
    self.cellInvoice.textColor = HEXCOLOR(0x303030);
    self.cellInvoice.font = [UIFont systemFontOfSize:28*ScaleWidth];
    self.cellInvoice.textAlignment = NSTextAlignmentRight;
    self.cellInvoice.text = @"";
    [self.contentView addSubview:self.cellInvoice];
    [self.cellInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.cellIcon.mas_left).mas_offset(-16*ScaleWidth);
    }];
    
    UIButton *select = [UIButton new];
    [select addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:select];
    [select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(0*ScaleWidth);
        make.left.mas_equalTo(self.cellInvoice.mas_left).mas_offset(-20*ScaleWidth);
        make.height.mas_equalTo(self);
    }];
    
    self.celltext = [UITextField new];
    self.celltext.textColor = HEXCOLOR(0x303030);
    self.celltext.font = [UIFont systemFontOfSize:28*ScaleWidth];
    self.celltext.textAlignment = NSTextAlignmentLeft;
    self.celltext.borderStyle = UITextBorderStyleNone;
    self.celltext.delegate = self;
    self.celltext.placeholder = @"请输入抬头";
    [self.celltext setValue:HEXCOLOR(0x8a8a8a) forKeyPath:@"_placeholderLabel.textColor"];
    [self.celltext setValue:[UIFont systemFontOfSize:30*ScaleWidth] forKeyPath:@"_placeholderLabel.font"];
    [self.contentView addSubview:self.celltext];
    [self.celltext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(0*ScaleWidth);
        make.left.mas_equalTo(self.cellTitle.mas_right).mas_offset(20*ScaleWidth);
        make.height.mas_equalTo(self);
    }];

    UIView *line = [UIView new];
    line.backgroundColor = HEXCOLOR(0xdfdfdf);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(2*ScaleWidth);
        make.width.mas_equalTo(ScreenWidth);
    }];
}

-(void)reset:(NSString *)text {
    self.cellInvoice.text = text;
    [self.cellIcon setImage:[UIImage imageNamed:@"jiangxu"]];
}

-(void)showList:(UIButton *)sender
{
    [self.cellIcon setImage:[UIImage imageNamed:@"shengxu"]];
    if (_singleClick) {
        _singleClick(self.tag);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
