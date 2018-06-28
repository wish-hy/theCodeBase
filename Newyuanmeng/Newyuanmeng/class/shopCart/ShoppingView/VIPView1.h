//
//  VIPView1.h
//  huabi
//
//  Created by teammac3 on 2017/6/5.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>

//返回商品ID
typedef void (^BackBlock)(NSString *goodsID);
@interface VIPView1 : UIView

//cell数据
@property(nonatomic,assign)NSInteger cols;
@property(nonatomic,strong)NSArray *dataArr;

@property(nonatomic,strong)BackBlock block;

@end
