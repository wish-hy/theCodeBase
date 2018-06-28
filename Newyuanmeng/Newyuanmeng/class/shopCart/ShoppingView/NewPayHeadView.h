//
//  NewPayHeadView.h
//  huabi
//
//  Created by 刘桐林 on 2017/1/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSwitch.h"
typedef void(^PayHeadClickBlock)(BOOL isOn);
@interface NewPayHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *headTitle;
@property (nonatomic, strong) UILabel *headcontent;
@property (nonatomic, strong) ZJSwitch *switchs;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) PayHeadClickBlock singleClick;
+(instancetype)HeaderViewWithTableView:(UITableView *)tableView withIdentifier:(NSString *)ID;

@end
