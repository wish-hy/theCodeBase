//
//  CollectionViewCell.h
//  collectionView
//
//  Created by ios01 on 2017/7/10.
//  Copyright © 2017年 ios01. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVAudioPlayer.h>
#import "CellModel.h"

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *second;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthButton;
@property (weak, nonatomic) IBOutlet UIButton *sixthButton;
@property (copy, nonatomic) CellModel *cellModel;
@property (copy, nonatomic) NSString  *oneSelected;
@property (copy, nonatomic) NSString  *twoSelected;
@property (copy, nonatomic) NSString  *threeSelected;
@property (copy, nonatomic) NSString  *fourSelected;
@property (copy, nonatomic) NSString  *fiveSelected;
@property (copy, nonatomic) NSString  *sixSelected;

@end
