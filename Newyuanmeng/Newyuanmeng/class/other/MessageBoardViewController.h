//
//  MessageBoardViewController.h
//  ZhongShengHealth
//
//  Created by teammac3 on 2017/12/27.
//  Copyright © 2017年 Mr.Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfoModel.h"

@interface MessageBoardViewController : UIViewController
/*!
 目标会话ID
 */
@property(nonatomic, strong) NSString *targetId;
@property (nonatomic, strong)SellerInfoModel *model;
@end
