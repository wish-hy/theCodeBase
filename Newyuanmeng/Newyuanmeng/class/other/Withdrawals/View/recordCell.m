//
//  recordCell.m
//  huabi
//
//  Created by TeamMac2 on 17/4/7.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "recordCell.h"

@interface recordCell ()

@property (weak, nonatomic) IBOutlet UIView *bkView;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *card_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *apply_dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation recordCell

-(void)setCellModel:(recordModel *)cellModel
{
    _cellModel = cellModel;
    
    self.bkView.layer.borderWidth = 1;
    self.bkView.layer.borderColor = [[UIColor orangeColor] CGColor];
    self.bkView.layer.cornerRadius = 5;
    self.bkView.layer.masksToBounds = YES;
    
    self.amountLabel.text = cellModel.amount;
    self.withdraw_noLabel.text = cellModel.withdraw_no;
    self.card_noLabel.text = cellModel.card_no;
    
    if ([cellModel.status isEqualToString:@"-1"]) {
        self.statusLabel.text = @"申请被拒";
        self.statusLabel.textColor = [UIColor redColor];
        self.noteLabel.text = cellModel.note;
    }else if ([cellModel.status isEqualToString:@"0"]){
        self.statusLabel.text = @"待处理";
        self.statusLabel.textColor = [UIColor blackColor];
        self.noteLabel.text = @"无";
    }else if ([cellModel.status isEqualToString:@"1"]){
        self.statusLabel.text = @"已转账";
        self.statusLabel.textColor = [UIColor grayColor];
        self.noteLabel.text = @"无";
    }
    
       self.apply_dateLabel.text = cellModel.apply_date;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
