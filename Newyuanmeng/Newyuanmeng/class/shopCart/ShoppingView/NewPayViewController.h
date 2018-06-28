//
//  NewPayViewController.h
//  huabi
//
//  Created by 刘桐林 on 2017/1/10.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPayViewController : UIViewController

@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) BOOL isGoods;
@property (nonatomic, strong) NSMutableArray <NSString *>*orderids;
@property(nonatomic,copy)NSString *isIntegral;
@property(nonatomic,assign)float cash;
@property(nonatomic,assign)float point;


@property(nonatomic,strong)NSString *shoppingID;   //积分购商品id

@property (nonatomic,assign) BOOL isQiangGou;
@end
