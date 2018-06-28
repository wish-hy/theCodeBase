//
//  HYHomeMoel.h
//  study
//
//  Created by hy on 2018/5/16.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYUserModel.h"

@interface HYHomeMoel : NSObject

@property (nonatomic ,strong)NSString *userName;
@property (nonatomic ,strong)NSString *userHeadimg;
@property(nonatomic,strong) NSArray *picturePhoto;       // 图片数组
@property(nonatomic,strong) NSString *pictureName;       // 图片名
@property(nonatomic,strong) NSString *pictureId;         // 图片id
@property(nonatomic,strong) NSString *userId;

@property(nonatomic,strong)NSString *imgURL;
@property(nonatomic,assign)CGFloat imgWidth;
@property(nonatomic,assign)CGFloat imgHeight;

@end
