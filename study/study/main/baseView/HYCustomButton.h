//
//  HYCustomButton.h
//  study
//
//  Created by hy on 2018/5/6.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Click)(void);

@interface HYCustomButton : UIView

@property (nonatomic,copy)Click click;

-(instancetype)initWithFrame:(CGRect)frame;

- (void)setTitle1: (NSString *)title1 Title2:(NSString *)title2;

@end
