//
//  ShopDetailView.h
//  huabi
//
//  Created by teammac3 on 2017/12/21.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonAction)(NSInteger index);
typedef void (^Navgation)(void);

@interface ShopDetailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgvImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceIconImageView;
@property (weak, nonatomic) IBOutlet UIView *whiteBgvView;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *stayButton;
@property (weak, nonatomic) IBOutlet UIButton *enterShopButton;
@property (nonatomic , copy) ButtonAction buttonaction;
@property (nonatomic,copy)Navgation navgation;
+ (instancetype)creatShopDetailView;
@end
