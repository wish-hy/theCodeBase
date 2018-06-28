//
//  VipSecondCell.h
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^VipSecondCellBlock)(NSInteger);
@interface VipSecondCell : UICollectionViewCell

@property (nonatomic, strong)UIButton *icon;
@property (nonatomic, strong)UILabel *title;
@property (nonatomic, strong)UILabel *price;
@property (nonatomic, strong)UILabel *costPrice;

@property (nonatomic, copy) VipSecondCellBlock iconClick;
-(void)setImageWithTitle:(NSString *)title image:(NSString *)image price:(NSString *)price price1:(NSString *)price1 price2:(NSString *)price2;

@end
