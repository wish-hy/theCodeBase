//
//  CollectionTitleView.h
//  huabi
//
//  Created by hy on 2018/3/10.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeeMore)();

@interface CollectionTitleView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *seeMore;

@property (nonatomic, copy) SeeMore see;
@end

