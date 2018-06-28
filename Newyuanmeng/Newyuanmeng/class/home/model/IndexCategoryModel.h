//
//  IndexCategoryModel.h
//  huabi
//
//  Created by hy on 2018/3/10.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BannerModel.h"
@interface IndexCategoryModel : NSObject

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *title_img;

@property (nonatomic, strong) NSString *font_color;

@property (nonatomic, strong) NSString *ad_position;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, strong) NSString *img_num;

@property (nonatomic, strong) BannerModel *banner_img;

@end
