//
//  SaleRecordCell.m
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "SaleRecordCell.h"
#import "VillageIcon.h"

@interface SaleRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallIcon;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation SaleRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

+(SaleRecordCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"RecodCell";
    SaleRecordCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SaleRecordCell" owner:self options:nil][0];
    }
    return cell;
}

-(void)setTime:(NSString *)time AvailableIncome:(NSString *)availableIncome UnlockedIncome:(NSString *)unlockedIncome ExtractedIncome:(NSString *)extractedIncome Describe:(NSString *)describe Status:(NSString *)status
{
    _timeLabel.text = time;
    
    if ([status isEqualToString:@"0"]) {
        
        _smallIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_time, 30, [UIColor colorWithHexString:@"#3399cc"])];
    }else if ([status isEqualToString:@"1"]){
        // 提现
        _smallIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6a5", 30, [UIColor colorWithHexString:@"#74c717"])];
    }
    else if ([status isEqualToString:@"1"]){
        // 撤销
        _smallIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e6a6", 30, [UIColor colorWithHexString:@"#74c717"])];
    }
    
    
    
    if ([availableIncome doubleValue] > 0) {
        _moneyLabel.text = [NSString stringWithFormat:@"↑%@",availableIncome];
        _moneyLabel.textColor = [UIColor redColor];
    }
    else if ([availableIncome doubleValue] < 0)
    {
        _moneyLabel.text = [NSString stringWithFormat:@"↓%@",availableIncome];
        _moneyLabel.textColor = [UIColor greenColor];
    }
    else if ([availableIncome doubleValue] == 0.00)
    {
        _moneyLabel.text = availableIncome;
        _moneyLabel.textColor = [UIColor grayColor];
    }
    
    
    
    if ([unlockedIncome doubleValue] > 0) {
        _dateLabel.text = [NSString stringWithFormat:@"↑%@",unlockedIncome];
        _dateLabel.textColor = [UIColor redColor];
    }
    else if ([unlockedIncome doubleValue] < 0)
    {
        _dateLabel.text = [NSString stringWithFormat:@"↓%@",unlockedIncome];
        _dateLabel.textColor = [UIColor greenColor];
    }
    else if ([unlockedIncome doubleValue] == 0.00)
    {
        _dateLabel.text = unlockedIncome;
        _dateLabel.textColor = [UIColor grayColor];
    }
    
    if ([extractedIncome doubleValue] > 0) {
        _remarkLabel.text = [NSString stringWithFormat:@"↑%@",extractedIncome];
        _remarkLabel.textColor = [UIColor redColor];
    }
    else if ([extractedIncome doubleValue] < 0)
    {
        _remarkLabel.text = [NSString stringWithFormat:@"↓%@",extractedIncome];
        _remarkLabel.textColor = [UIColor greenColor];
    }
    else if ([extractedIncome isEqualToString:@"0.00"])
    {
        _remarkLabel.text = extractedIncome;
        _remarkLabel.textColor = [UIColor grayColor];
    }
    
    _contentLabel.text = describe;
}



////提现
//- (void)setWithDrawModel:(WithDrawRecordModel *)withDrawModel{
//
//    _withDrawModel = withDrawModel;
//    [self addWithDrawRecordCellContent];
//}
//#pragma mark  - 提现记录cell
//- (void)addWithDrawRecordCellContent{
//
//    //日期
//    _dateLabel.text = _withDrawModel.weekday;
//    _timeLabel.text = _withDrawModel.month;
//
//    //钱
//    _moneyLabel.text = _withDrawModel.amount;
//    //内容
//    _contentLabel.text = _withDrawModel.settle_type;
//
//    if ([_withDrawModel.status isEqualToString:@"0"]) {
//
//        _smallIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_time, 30, [UIColor colorWithHexString:@"#3399cc"])];
//        _remarkLabel.textColor = [UIColor greenColor];
//        _remarkLabel.text = @"待处理";
//    }else if ([_withDrawModel.status isEqualToString:@"1"]){
//
//        _smallIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_tick2, 30, [UIColor colorWithHexString:@"#74c717"])];
//        _remarkLabel.textColor = [UIColor lightGrayColor];
//        _remarkLabel.text = @"已转账";
//    }else{
//
//        _smallIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_aboutUs, 30, [UIColor colorWithHexString:@"#5ca608"])];
//        _remarkLabel.textColor = [UIColor redColor];
//        _remarkLabel.text = @"未通过";
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
