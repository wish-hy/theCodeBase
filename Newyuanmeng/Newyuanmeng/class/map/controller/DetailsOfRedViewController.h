//
//  DetailsOfRedViewController.h
//  huabi
//
//  Created by hy on 2018/1/17.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Close)(void);

@interface DetailsOfRedViewController : UIViewController

@property (nonatomic,strong)NSString *id;
@property (nonatomic,copy)Close close;
@end
