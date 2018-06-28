//
//  GoldRecordCell.m
//  huabi
//
//  Created by TeamMac2 on 17/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "GoldRecordCell.h"

@interface GoldRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *order_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation GoldRecordCell

-(void)setCellModel:(SilverRecordModel *)cellModel
{
    _cellModel = cellModel;
    self.order_noLabel.text = [NSString stringWithFormat:@"订单编号：%@",cellModel.order_no];
    self.amountLabel.text = cellModel.amount;
    NSString *changeType = [NSString new];
    if ([cellModel.type isEqualToString:@"0"]) {
        changeType = @"购物下单";
    }else if ([cellModel.type isEqualToString:@"1"]){
        changeType = @"用户充值";
    }else if ([cellModel.type isEqualToString:@"2"]){
        changeType = @"管理员充值";
    }else if ([cellModel.type isEqualToString:@"3"]){
        changeType = @"余额提现";
    }else if ([cellModel.type isEqualToString:@"4"]){
        changeType = @"管理员退款";
    }else if ([cellModel.type isEqualToString:@"5"]){
        changeType = @"佣金获取";
    }else if ([cellModel.type isEqualToString:@"6"]){
        changeType = @"推广收益";
    }else if ([cellModel.type isEqualToString:@"7"]){
        changeType = @"转化成银点";
    }else if ([cellModel.type isEqualToString:@"8"]){
        changeType = @"外平台返回";
    }
    self.typeLabel.text = changeType;
    self.timeLabel.text = cellModel.time;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
