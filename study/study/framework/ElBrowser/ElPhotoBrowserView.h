//
//  ElPhotoBrowserView.h
//  RACMVVMDemo
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElPhotoBrowserView : UIView

@property (nonatomic, strong) UICollectionView *listCollectionView;

@property (nonatomic, strong) NSArray *originalUrls;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSArray *smallUrls;

- (void)show;

@end
