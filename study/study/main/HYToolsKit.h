//
//  HYToolsKit.h
//  fileManager
//
//  Created by hy on 2018/3/6.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import <CoreImage/CIFilter.h>
#import <CommonCrypto/CommonCrypto.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@interface HYToolsKit : NSObject

// 根据颜色生成图片
+ (UIImage*)createImageWithColor:(UIColor*)color;

// 获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;


/**************************************判断手机号码是否正确******************************************/
+ (BOOL) isMobileTwo:(NSString *)mobileNumbel;

@end
