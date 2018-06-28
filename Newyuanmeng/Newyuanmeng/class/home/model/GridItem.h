//
//  GridItem.h
//  huabi
//
//  Created by hy on 2018/3/8.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridItem : NSObject

@property (nonatomic, copy) NSString *id;

/** 图片  */
@property (nonatomic, copy ,readonly) NSString *adimg;
/** 文字  */
@property (nonatomic, copy ,readonly) NSString *name;
/** type  */
@property (nonatomic, copy ,readonly) NSString *type;
///** tag颜色  */
//@property (nonatomic, copy ,readonly) NSString *gridColor;

@end
