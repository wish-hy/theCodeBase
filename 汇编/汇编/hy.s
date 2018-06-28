//
//  hy.s
//  汇编
//
//  Created by hy on 2018/6/24.
//  Copyright © 2018年 hy. All rights reserved.
//
.text
.global _sum
_sum:
    movq %rdi,%rax
    addq %rsi,%rax
    retq
