//
//  DetailsView.h
//  huabi
//
//  Created by teammac3 on 2017/3/29.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pend_districtModel.h"

typedef void(^viewBack)(NSInteger);
@interface DetailsView : UIView


@property(nonatomic,strong)pend_districtModel *model;
@property(nonatomic,assign)NSInteger btnTag;
@property(nonatomic,copy)viewBack block;

@end
