//
//  RechargeCell.m
//  huabi
//
//  Created by huangyang on 2017/11/13.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "RechargeCell.h"


@implementation RechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [_money addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingDidEnd];
}

+(RechargeCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"RechargeCell";
    RechargeCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RechargeCell" owner:self options:nil][0];
    }
    return cell;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_money becomeFirstResponder];
}

#pragma mark - private method
//- (void)textfieldTextDidChange:(UITextField *)textField
//{
//    self.block(self.money.text);
//}

@end
