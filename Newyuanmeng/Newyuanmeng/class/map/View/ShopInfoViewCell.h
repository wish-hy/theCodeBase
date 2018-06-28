//
//  ShopInfoViewCell.h
//  huabi
//
//  Created by huangyang on 2017/12/12.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface ShopInfoViewCell : UITableViewCell
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UIImageView *shopimgImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *priceForEveryOne;
@property (weak, nonatomic) IBOutlet UILabel *catgary;
@property (weak, nonatomic) IBOutlet UILabel *distance;    // 距离
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UILabel *consume;   // 消费
@property (weak, nonatomic) IBOutlet UIView *goodReputation;  // 好评
@property (weak, nonatomic) IBOutlet UIView *activteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIImageView *jurisdiction;

@property (nonatomic , assign) NSInteger startNumber;

@end
