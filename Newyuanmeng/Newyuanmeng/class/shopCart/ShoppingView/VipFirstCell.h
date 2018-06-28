//
//  VipFirstCell.h
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^VipFirstCellBlock)(NSInteger);
@interface VipFirstCell : UICollectionViewCell

@property (nonatomic, strong)UIButton *icon;
@property (nonatomic, strong)UILabel *title;
@property (nonatomic, strong)UILabel *price;
@property (nonatomic, strong)UILabel *count;
@property (nonatomic, strong)UILabel *buy;
@property (nonatomic, strong)UIView *buyBack;
@property (nonatomic, assign)BOOL canBuy;
@property (nonatomic, copy) VipFirstCellBlock buyClick;
@property (nonatomic, copy) VipFirstCellBlock iconClick;

-(void)setImageWithTitle:(NSString *)title image:(NSString *)image price1:(NSString *)price1 price2:(NSString *)price2 count:(NSInteger)count;
@end
