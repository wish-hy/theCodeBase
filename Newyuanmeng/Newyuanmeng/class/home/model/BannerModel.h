//
//  BannerModel.h
//  huabi
//
//  Created by hy on 2018/3/9.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bannerInfoModel.h"

@interface BannerModel : NSObject

@property (nonatomic, copy) NSString *path;

@property (nonatomic, strong) bannerInfoModel *url;

@property (nonatomic, copy) NSString *title;

@end
