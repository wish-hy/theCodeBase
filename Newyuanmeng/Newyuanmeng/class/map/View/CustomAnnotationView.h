//
//  CustomAnnotationView.h
//  ZhongShengHealth
//
//  Created by teammac3 on 2017/10/24.
//  Copyright © 2017年 Mr.Xiao. All rights reserved.
//

typedef void (^ShowAction)(NSInteger index);

#import <MAMapKit/MAMapKit.h>

@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImage *portrait;
@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, copy) ShowAction showaction;
//- (void)sendDataArray:(NSMutableArray *)dataArr;
@end
