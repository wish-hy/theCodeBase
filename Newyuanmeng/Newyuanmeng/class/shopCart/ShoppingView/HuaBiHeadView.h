//
//  HuaBiHeadView.h
//  huabi
//
//  Created by TeamMac2 on 16/12/14.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuaBiHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *text1;
@property (nonatomic, strong) UILabel *text2;
@property (nonatomic, strong) UILabel *text3;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *topline;
@property (nonatomic, strong) UIView *bottomline;
@property (nonatomic, strong) UIButton *select;

+(instancetype)HeaderViewWithTableView:(UITableView *)tableView withIdentifier:(NSString *)ID;
-(void)setHeadInfo:(NSString *)title content:(NSString *)content text:(NSString *)text section:(NSInteger)section;

@end
