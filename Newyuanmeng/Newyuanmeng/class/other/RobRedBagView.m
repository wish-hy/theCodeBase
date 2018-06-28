//
//  RobRedBagView.m
//  huabi
//
//  Created by hy on 2018/1/17.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "RobRedBagView.h"

@implementation RobRedBagView


+ (instancetype)creatRobRedBagView{
    {
        return [[[NSBundle mainBundle] loadNibNamed:@"RobRedBagView" owner:self options:nil] firstObject];
    }
}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//
//    if (self) {
//        [[[NSBundle mainBundle] loadNibNamed:@"RobRedBagView" owner:self options:nil] firstObject];
//        self.frame = self.bounds;
//    }
//
//    return self;
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.frame = CGRectMake(0, 0, ScreenWidth *0.6, ScreenHeight *0.6);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.height = ScreenHeight*0.6;
//    self.width = ScreenWidth*0.6;
}

- (IBAction)openRedBag:(id)sender {
    self.open();
}
- (IBAction)seeInfo:(id)sender {
    self.see();
}
- (IBAction)close:(id)sender {
    self.close();
}

@end
