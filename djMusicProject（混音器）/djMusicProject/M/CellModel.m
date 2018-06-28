//
//  CellModel.m
//  collectionView
//
//  Created by ios01 on 2017/7/12.
//  Copyright © 2017年 ios01. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

+(CellModel *)careatModel:(NSString *)buttonImage button:(NSString *)selectedUrl{
    CellModel *model = [[CellModel alloc] init];
    model.buttonImageUrl = buttonImage;
    model.selectedButtonUrl = selectedUrl;
    return model;
}

@end
