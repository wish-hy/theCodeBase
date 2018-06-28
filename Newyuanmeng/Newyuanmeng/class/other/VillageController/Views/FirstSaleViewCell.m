//
//  FirstSaleViewCell.m
//  huabi
//
//  Created by teammac3 on 2017/3/30.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "FirstSaleViewCell.h"
#import "UIImageView+WebCache.h"
#import "VillageIcon.h"

@interface FirstSaleViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallPrice;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigPrice;
@property (weak, nonatomic) IBOutlet UILabel *wallet;
@property (weak, nonatomic) IBOutlet UIImageView *priceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *carIcon;
@property (weak, nonatomic) IBOutlet UIImageView *walletIcon;
@property (weak, nonatomic) IBOutlet UIImageView *goodsIcon;

@end

@implementation FirstSaleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

//填充内容
- (void)setModel:(SaleRecordModel *)model{
    
    _model = model;
    
    //日期
    _dateLabel.text = model.weekday;
    _timeLabel.text = model.month;
    //图片
    [_goodsIcon sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
    //标题
    _titleLabel.text = model.name;
    //价格
    _smallPrice.text = model.unit_price;
    _bigPrice.text = model.amount;
    //购物车数量
    _numLabel.text = model.sell_num;
    //收益
    _wallet.text = model.income;
    
    //图标
    _priceIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_bargainPrice, 20, [UIColor lightGrayColor])];
    _carIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_goodsCar, 20, [UIColor lightGrayColor])];
    _walletIcon.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_village_wallet, 20, [UIColor lightGrayColor])];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
