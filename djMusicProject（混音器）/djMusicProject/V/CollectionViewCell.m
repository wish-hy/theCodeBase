//
//  CollectionViewCell.m
//  collectionView
//
//  Created by ios01 on 2017/7/10.
//  Copyright © 2017年 ios01. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell()
//{
//    AVAudioPlayer *player;
//}

@end

@implementation CollectionViewCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)setCellModel:(CellModel *)cellModel{
    _cellModel = cellModel;
//    [_firstButton setImage:[UIImage imageNamed:cellModel.buttonImageUrl] forState:UIControlStateNormal];
    _firstButton.adjustsImageWhenHighlighted = NO;
//    [_firstButton setBackgroundImage:[UIImage imageNamed:cellModel.buttonImageUrl] forState:UIControlStateNormal];
    
    [_firstButton setImage:[UIImage imageNamed:cellModel.buttonImageUrl] forState:UIControlStateNormal];
    _firstButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_second setImage:[UIImage imageNamed:cellModel.buttonImageUrl] forState:UIControlStateNormal];
    _second.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_thirdButton setImage:[UIImage imageNamed:cellModel.buttonImageUrl] forState:UIControlStateNormal];
    _thirdButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_fourthButton setImage:[UIImage imageNamed:cellModel.buttonImageUrl] forState:UIControlStateNormal];
    _fourthButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_fifthButton setImage:[UIImage imageNamed:cellModel.buttonImageUrl] forState:UIControlStateNormal];
    _fifthButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_sixthButton setImage:[UIImage imageNamed:cellModel.buttonImageUrl] forState:UIControlStateNormal];
    _sixthButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_firstButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateHighlighted];
    
    [_second setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateHighlighted];
    
    [_thirdButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateHighlighted];
    
    [_fourthButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateHighlighted];
    
    [_fifthButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateHighlighted];
    
    [_sixthButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateHighlighted];
    
    //点击后的图片
    
    [_firstButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateSelected];
    
    [_second setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateSelected];
    
    [_thirdButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateSelected];
    
    [_fourthButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateSelected];
    
    [_fifthButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateSelected];
    
    [_sixthButton setImage:[UIImage imageNamed:cellModel.selectedButtonUrl] forState:UIControlStateSelected];

    
}



@end
