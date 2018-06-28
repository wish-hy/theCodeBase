//
//  PayTypeCell.h
//  huabi
//
//  Created by TeamMac2 on 16/12/10.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeCell : UITableViewCell

@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *cellTitle2;
@property (nonatomic, strong) UILabel *cellContent;
@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UIImageView *cellIcon2;
@property (nonatomic, strong) UIImageView *cellIcon3;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
-(void)setCellTitleWithNumb:(NSString *)title content:(NSString *)content icon:(NSString *)icon isUpay:(BOOL)isUpay;
@end
