//
//  CellModel.h
//  collectionView
//
//  Created by ios01 on 2017/7/12.
//  Copyright © 2017年 ios01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property (nonatomic, copy) NSString *buttonImageUrl;

@property (nonatomic, copy) NSString *selectedButtonUrl;

+(CellModel *)careatModel:(NSString *)buttonImage button:(NSString *)selectedUrl;

@end
