//
//  main.m
//  汇编
//
//  Created by hy on 2018/6/24.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>

int sum(int a,int b);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int a = sum(10, 20);
        NSLog(@"%d",a);
    }
    return 0;
}
