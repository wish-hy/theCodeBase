//
//  UITextField+Custom.h
//  ATest
//
//  Created by han harvey on 16/4/12.
//  Copyright © 2016年 han harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    YGTextFieldLimitWordType1Nomarl  = 0,            //无限制模式
    YGTextFieldLimitWordType1Int  = 1,               //只能输入整数
    YGTextFieldLimitWordType1Float  = 2,             //只能输入小数
    YGTextFieldLimitWordType1IntAndFloat = 3,        //只能输入整数或小数
}YGTextFieldLimitWordType1;

@interface UITextField (Custom)

@property (nonatomic,strong)NSMutableArray *limitTextFieldArray;


//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string;

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string;


/**
 *  textField切换明文/密文显示
 */
- (void)changingTextDisplayModes;


/**
 *  只能输入数字
 */
- (BOOL)validateNumber:(NSString*)number;


/**
 *  判断小数，只能有一个小数点
 *  length 保留几位小数
 */
- (BOOL)validateDecimals:(NSRange)range andReplacementString:(NSString*)string andCalculateToLength:(int)length;

/**
 *  textfield限制字数和输入类型
 *
 *  textfield：要限制的textField
 *  limitNumber：要限制输入字符个数
 *  textFieldLimitWordType：要限制输入的模式
 */
-(BOOL)textFieldLimitWordNumber:(int)limitNumber limitType:(YGTextFieldLimitWordType1)textFieldLimitWordType andRange:(NSRange)range andReplacementString:(NSString*)string;

@end
