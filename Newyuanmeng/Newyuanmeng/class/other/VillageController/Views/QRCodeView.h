//
//  QRCodeView.h
//  huabi
//
//  Created by teammac3 on 2017/4/10.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeView : UIView
@property (nonatomic,strong)NSDictionary *userInfo;


- (instancetype)initWithFrame:(CGRect)frame withLinkStr:(NSString *)str;

@end
