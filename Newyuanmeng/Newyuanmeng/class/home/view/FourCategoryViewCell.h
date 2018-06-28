//
//  FourCategoryViewCell.h
//  huabi
//
//  Created by hy on 2018/3/10.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickImage)(NSInteger index);

@interface FourCategoryViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *ads1;

@property (nonatomic, strong) UIImageView *ads2;

@property (nonatomic, strong) UIImageView *image1;

@property (nonatomic, strong) UIImageView *image2;

@property (nonatomic, strong) UIImageView *image3;

@property (nonatomic, strong) UIImageView *image4;

@property (nonatomic, copy) ClickImage index;

@property (nonatomic, assign) NSInteger status;



@end
