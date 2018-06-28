//
//  UITextField+Custom.m
//  ATest
//
//  Created by han harvey on 16/4/12.
//  Copyright © 2016年 han harvey. All rights reserved.
//

#import "UITextField+Custom.h"

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define NUMBERS @"0123456789n"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
#define NUMBERSPERIOD @"0123456789."
#define NMUBERS @"./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`"

@implementation UITextField (Custom)

@dynamic limitTextFieldArray;

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  textField切换明文/密文显示
 */
- (void)changingTextDisplayModes
{
    self.secureTextEntry = !self.secureTextEntry;
    NSString* text = self.text;
    self.text = @" ";
    self.text = text;
}


/**
 *  只能输入数字
 */
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


/**
 *  判断小数，只能有一个小数点;
 *  length 保留几位小数
 */
-(BOOL)validateDecimals:(NSRange)range andReplacementString:(NSString*)string andCalculateToLength:(int)length
{
    BOOL isHaveDian = YES;
    if ([self.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if ([self.text length] == 0){
                if (single == '.') {
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(isHaveDian == NO)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                } else {
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                if (isHaveDian == YES) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [self.text rangeOfString:@"."];
                    if (range.location - ran.location <= length) {
                        return YES;
                    }else{
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        } else {//输入的数据格式不正确
            [self.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
    
    return isHaveDian;
}

/**
 *  textfield限制字数和输入类型
 *
 *  textfield：要限制的textField
 *  limitNumber：要限制输入字符个数
 *  textFieldLimitWordType：要限制输入的模式
 */
-(BOOL)textFieldLimitWordNumber:(int)limitNumber limitType:(YGTextFieldLimitWordType1)textFieldLimitWordType andRange:(NSRange)range andReplacementString:(NSString*)string
{
    
    //删除文字操作，任何模式下可以删除
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        //如果限制类型是整数，输入不是整数，不让输
        if (textFieldLimitWordType == YGTextFieldLimitWordType1Int)
        {
            if (![self isPureInt:string])
            {
                return NO;
            }
        }
        
        //如果限制类型是浮点，输入不是浮点，不让输
        if (textFieldLimitWordType == YGTextFieldLimitWordType1Float)
        {
            if (![self isPureFloat:string])
            {
                return NO;
            }
        }
        
        //如果限制类型是浮点和整数，输入不是浮点且整数，不让输
        if (textFieldLimitWordType == YGTextFieldLimitWordType1IntAndFloat)
        {
            if (![self isPureFloat:string] && ![self isPureInt:string])
            {
                return NO;
            }
        }
        
        //如果本身textfield的长度加上将要输入的长度小于限制的长度，可以输入
        if (self.text.length+string.length <= limitNumber)
        {
            return YES;
        }
        
        //如果textfield的长度已经最大值了 直接不让编辑
        if(self.text.length == limitNumber)
        {
            return NO;
        }
        
        //如果加一起大于该长度texrfield还不是最大值，那就截了
        if(self.text.length+string.length >= limitNumber)
        {
            NSString *nowString = [NSString stringWithFormat:@"%@%@",self.text,string];
            self.text = [nowString substringToIndex:limitNumber];
            return NO;
        }
        
    }
    
    return YES;
}

@end
