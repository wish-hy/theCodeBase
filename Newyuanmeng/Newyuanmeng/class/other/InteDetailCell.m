//
//  InteDetailCell.m
//  huabi
//
//  Created by teammac3 on 2017/6/6.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "InteDetailCell.h"

@interface InteDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *NoteL;
@property (weak, nonatomic) IBOutlet UILabel *DateL;

@end

@implementation InteDetailCell

- (void)setModel:(InteDetailModel *)model{
    _model = model;
    
    _orderNo.text = model.order_no;
    _amountL.text = model.amount;
    _NoteL.text = model.note;
    _DateL.text = model.log_date;
}

@end
