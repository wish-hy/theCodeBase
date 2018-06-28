//
//  YZPPickView.h
//  PickView
//
//  Created by m on 16/6/23.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provice.h"


@protocol YZPPickViewDelegate <NSObject>

- (void)didSelectPickView:(Provice*)provice city:(City *)city;

@end


@interface YZPPickView : UIView


@property(nonatomic,assign)id<YZPPickViewDelegate> delegate;

@property(nonatomic,assign)BOOL hasDefaul;

@end
