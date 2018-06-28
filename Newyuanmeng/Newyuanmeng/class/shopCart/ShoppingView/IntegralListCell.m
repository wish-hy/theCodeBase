//
//  IntegralListCell.m
//  huabi
//
//  Created by teammac3 on 2017/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import "IntegralListCell.h"
#import "VillageIcon.h"
#import "UIImageView+WebCache.h"
#import "IntegralPriceSetModel.h"

@interface IntegralListCell()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *integralL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *goodsCarImg;


@end

@implementation IntegralListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _goodsCarImg.image = [UIImage iconWithInfo:TBCityIconInfoMake(icon_integralCar, 30, [UIColor redColor])];
}

- (void)setModel:(IntegralListModel *)model{
    _model = model;
    
    //拼接
    NSString *urlS = [NSString stringWithFormat:@"https://ymlypt.b0.upaiyun.com%@",model.img];
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:urlS] placeholderImage:nil];
    _nameL.text = model.name;
    _priceL.text = model.sell_price;
    
    //拼接
    IntegralPriceSetModel *m = model.price_set[0];
    NSString *integralS = [NSString stringWithFormat:@"¥%@+%@积分",m.cash,m.point];
    _integralL.text = integralS;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
