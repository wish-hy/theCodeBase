//
//  CustomAnnotationView.m
//  ZhongShengHealth
//
//  Created by teammac3 on 2017/10/24.
//  Copyright © 2017年 Mr.Xiao. All rights reserved.
//

#import "CustomAnnotationView.h"



#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView ()

@end

@implementation CustomAnnotationView

@synthesize calloutView;

@synthesize portraitImageView   = _portraitImageView;
@synthesize avatorImageView   = _avatorImageView;
- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}


#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kPortraitWidth, kPortraitHeight);
        
        //self.backgroundColor = [UIColor grayColor];
        /* Create portrait image view and add to view hierarchy. */
        self.annotation = annotation;
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitWidth)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSomething:)];
        tap.numberOfTapsRequired = 1;
        [self.portraitImageView addGestureRecognizer:tap];
        self.portraitImageView.userInteractionEnabled = YES;
        [self addSubview:self.portraitImageView];
        
        self.avatorImageView = [[UIImageView alloc] init];
        self.avatorImageView.hidden = YES;
        [self.portraitImageView addSubview:self.avatorImageView];
        [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.portraitImageView.mas_centerX);
            make.centerY.mas_equalTo(self.portraitImageView.mas_centerY);
            make.width.height.mas_equalTo(kPortraitWidth- 10*ScaleWidth);
        }];
        
        
        self.nameLabel = [[UILabel alloc] init];
        [self addSubview:self.nameLabel];
        self.nameLabel.layer.cornerRadius = 10;
        self.nameLabel.layer.masksToBounds = YES;
        self.nameLabel.backgroundColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.layer.borderWidth = 1*ScaleWidth;
        self.nameLabel.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.portraitImageView.mas_bottom);
            make.centerX.mas_equalTo(self.portraitImageView.mas_centerX);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)showSomething:(UITapGestureRecognizer *)tap{
    self.showaction([self.annotation.title integerValue]);
//    NSLog(@"这个是title：%@",self.annotation.title);
}

//接受传递过来的数据
//- (void)sendDataArray:(NSMutableArray *)dataArr{
//    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
//    if (dataArr.count > 0) {
//        for (UIView *view in self.portraitImageView.subviews) {
//            [view removeFromSuperview];
//        }
//    }
//    for (int i = 0; i < dataArr.count; ++i)
//    {
//        LoacationModel *model = dataArr[i];
//        if ([model.latitude doubleValue] == coorinate.latitude && [model.longitude doubleValue] == coorinate.longitude){
//            UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationheadbg"]];
//            UIImageView *headView = [MySDKHelper imageFromURLString:model.head_pic];//[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"刷新"]];
//            headView.layer.cornerRadius = (50-20*ScaleWidth)/2;
//            headView.layer.masksToBounds = YES;
//            [bgView addSubview:headView];
//            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.mas_equalTo(10*ScaleWidth);
//                make.bottom.mas_equalTo(-15*ScaleWidth);
//                make.right.mas_equalTo(-10*ScaleWidth);
//            }];
//            [_portraitImageView addSubview:bgView];
//            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(_portraitImageView.mas_top);
//                make.left.mas_equalTo(_portraitImageView.mas_left);
//                make.width.height.mas_equalTo(kPortraitWidth);
//            }];
//        }
//   }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
