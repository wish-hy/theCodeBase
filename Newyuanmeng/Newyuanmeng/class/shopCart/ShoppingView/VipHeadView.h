//
//  VipHeadView.h
//  huabi
//
//  Created by TeamMac2 on 16/12/28.
//  Copyright © 2016年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface VipHeadView : UICollectionReusableView

@property (nonatomic, strong)UILabel *name;
@property (nonatomic, strong) UIView *line;
-(void)setImagesWithTitle:(NSString *)title type:(NSInteger)type;
@end
