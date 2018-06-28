//
//  GoldAllViewController.h
//  huabi
//
//  Created by TeamMac2 on 17/4/17.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SilverRecordModel.h"

@interface GoldAllViewController : UIViewController

@property(nonatomic,assign)NSInteger userID;
@property(nonatomic,copy)NSString *token;

@property(nonatomic,strong)NSMutableArray<SilverRecordModel *> *mutArr;


@end
