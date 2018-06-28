//
//  NewPayCell.h
//  huabi
//
//  Created by 刘桐林 on 2017/1/11.
//  Copyright © 2017年 ltl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PayClickBlock)(NSInteger tag);
@interface NewPayCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *cellcontent;
@property (nonatomic, strong) UILabel *cellInvoice;
@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UITextField *celltext;

@property (nonatomic, copy) PayClickBlock singleClick;
-(void)reset:(NSString *)text;

@end
