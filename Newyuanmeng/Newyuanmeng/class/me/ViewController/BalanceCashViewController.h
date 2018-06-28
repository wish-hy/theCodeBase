//
//  BalanceCashViewController.h
//  huabi
//
//  Created by huangyang on 2017/12/26.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceCashViewController : UIViewController

@property (nonatomic,strong)NSString *balanceMoney;

@property (nonatomic,assign)BOOL isBanlanceCard;    //  是否提现到银行卡


@property (nonatomic,assign)BOOL isBalanceCash;  // 是否余额提现
@end
