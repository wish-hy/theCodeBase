//
//  Withdrawals.h
//  huabi
//
//  Created by TeamMac2 on 17/4/6.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recordModel.h"
@interface Withdrawals : UIViewController

@property(nonatomic,assign)NSInteger userID;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *goldNumber;//!<余额

@property(nonatomic,strong)NSMutableArray<recordModel *> *mutArr;


@end
