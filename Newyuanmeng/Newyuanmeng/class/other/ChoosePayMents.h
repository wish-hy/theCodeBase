//
//  ChoosePayMents.h
//  huabi
//
//  Created by hy on 2018/1/16.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePayMentCell.h"

@interface ChoosePayMents : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSInteger pay_password_open;
    UIView *passView;
    UITextField *passText;
}
@property (weak, nonatomic) IBOutlet UITableView *choosePayMentTableVIew;
@property (nonatomic,strong)NSString *money;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic,strong)NSMutableArray *info;

@property (nonatomic,strong)NSString *payment_id;
@property (nonatomic,strong)NSString *sell_id;

@property (nonatomic,strong)ChoosePayMentCell *currentCell;

@property (nonatomic,strong)NSDictionary *Payinfo;

@property (nonatomic,assign)BOOL isRedBag;
@property (nonatomic,strong)NSMutableArray *redBagKeys;
@property (nonatomic,strong)NSMutableArray *redBagValues;

+ (instancetype)creatChoosePayMentView;
@end
