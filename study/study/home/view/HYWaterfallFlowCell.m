//
//  HYWaterfallFlowCell.m
//  study
//
//  Created by hy on 2018/4/21.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYWaterfallFlowCell.h"

@interface HYWaterfallFlowCell ()

@property (nonatomic ,strong)UIImageView *imgV;
@property (nonatomic ,strong)UIImageView *headerImage;

@property (nonatomic ,strong)UILabel *userName;
@property (nonatomic ,strong)UILabel *destript;

@end

@implementation HYWaterfallFlowCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatSubView];
        
    }
    return self;
}

- (void)creatSubView {
    
    _imgV = [[UIImageView alloc]init];
    _imgV.contentMode = UIViewContentModeScaleAspectFill;
    _imgV.clipsToBounds = YES;
    [self addSubview:_imgV];
   
    _headerImage = [[UIImageView alloc] init];
    _headerImage.contentMode = UIViewContentModeScaleToFill;
//    _headerImage.backgroundColor = [UIColor redColor];
    _headerImage.image = [UIImage imageNamed:@"activity_selected"];
    _headerImage.clipsToBounds = YES;
    _headerImage.layer.cornerRadius = 14;
    [self addSubview:_headerImage];
    
    
    _userName = [[UILabel alloc]init];
    _userName.font = [UIFont systemFontOfSize:15];
//    _userName.backgroundColor = [UIColor blueColor];
    _userName.text = @"wish";
    _userName.textColor = [UIColor blackColor];
    _userName.textAlignment = NSTextAlignmentLeft;
    [self addSubview: _userName];
    
    _destript = [[UILabel alloc] init];
    _destript.font = [UIFont systemFontOfSize:14];
//    _destript.backgroundColor = [UIColor blueColor];
//    _destript.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    _destript.numberOfLines = 2;
    _destript.textColor = [UIColor colorWithHexString:@"888888"];
    _destript.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_destript];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-80);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    [_destript mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imgV.mas_bottom).offset(8);
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(40);
    }];
    [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.destript.mas_bottom).offset(3);
        make.left.mas_equalTo(_destript.mas_left);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.destript.mas_bottom).offset(3);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(30);
        
    }];
}

-(void)setModel:(HYHomeMoel *)model {
    _model = model;

    [_imgV sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[HYToolsKit createImageWithColor:RandomColor]];
    _destript.text = model.pictureName;
    _userName.text = model.userName;
//    NSLog(@"userName = %@",model.users.userName);
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.userHeadimg] placeholderImage:[HYToolsKit createImageWithColor:RandomColor]];
    
}


@end
