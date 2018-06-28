//
//  HYEditPhotoViewController.h
//  study
//
//  Created by hy on 2018/5/7.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "UIView+Layout.h"

#import "UITextView+BKTextView.h"

@interface HYEditPhotoViewController : UIViewController{
    BOOL _isSelectOriginalPhoto;
    
    NSMutableArray *weatUpdateArr;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic ,strong) NSMutableArray *selectedPhotos;
@property (nonatomic ,strong) NSMutableArray *selectedAssets;

@property (nonatomic ,strong) UIView *edits;
@property (nonatomic ,strong) UITextView *editsText;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;

@property (strong, nonatomic) CLLocation *location;

@property (nonatomic ,strong)NSMutableArray *imageArr;

@property (nonatomic,strong)TZAssetModel *assetModel;
@property (nonatomic,strong)UIImage *image;

@end
