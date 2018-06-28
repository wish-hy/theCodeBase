//
//  YSCRippleView.m
//  AnimationLearn
//
//  Created by yushichao on 16/2/17.
//  Copyright © 2016年 yushichao. All rights reserved.
//

#import "YSCRippleView.h"

@interface YSCRippleView ()

@property (nonatomic, strong) UIButton *rippleButton;
@property (nonatomic, strong) NSTimer *rippleTimer;
@property (nonatomic, strong) NSTimer *rippleTimer2;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) YSCRippleType type;

@end

@implementation YSCRippleView

- (void)removeFromParentView
{
    if (self.superview) {
        [_rippleButton removeFromSuperview];
        [self closeRippleTimer];
        [self removeAllSubLayers];
        [self removeFromSuperview];
        [self.layer removeAllAnimations];
    }
}

- (void)removeAllSubLayers
{
    for (NSInteger i = 0; [self.layer sublayers].count > 0; i++) {
        [[[self.layer sublayers] firstObject] removeFromSuperlayer];
    }
}

- (void)showWithRippleType:(YSCRippleType)type
{
    _type = type;
    [self setUpRippleButton];
    
    self.rippleTimer = [NSTimer timerWithTimeInterval:0.7 target:self selector:@selector(addRippleLayer) userInfo:nil repeats:YES];
    
    
    self.rippleTimer2 = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(closeRippleTimer) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_rippleTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] addTimer:_rippleTimer2 forMode:NSRunLoopCommonModes];
    
}

- (void)setUpRippleButton
{
    _rippleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-15, self.height/2-15, 30, 30)];
    _rippleButton.layer.backgroundColor = [UIColor blueColor].CGColor;
    _rippleButton.layer.cornerRadius = 15;
    _rippleButton.layer.masksToBounds = YES;
    _rippleButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _rippleButton.layer.borderWidth = 4;
    [_rippleButton addTarget:self action:@selector(rippleButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_rippleButton];
}

-(void)beganAnimal
{
    [self closeRippleTimer];
    [self addRippleLayer];
}

- (void)rippleButtonTouched:(id)sender
{
    [self closeRippleTimer];
    [self addRippleLayer];
}

- (CGRect)makeEndRect
{
    CGRect endRect = CGRectMake(self.width/2-15, self.height/2-15, 30, 30);
    endRect = CGRectInset(endRect, -100, -100);
    return endRect;
}

- (void)addRippleLayer
{
    CAShapeLayer *rippleLayer = [[CAShapeLayer alloc] init];
    rippleLayer.position = CGPointMake(50, 50);
    rippleLayer.bounds = CGRectMake(0, 0, 100, 100);
    rippleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 50, 50)];
    rippleLayer.path = path.CGPath;
    
    rippleLayer.strokeColor = [UIColor colorWithHexString:@"#59ccf5"].CGColor;
    
    rippleLayer.lineWidth = 1.5;
    

    rippleLayer.fillColor = [UIColor colorWithHexString:@"#59ccf5"].CGColor;

    
    [self.layer insertSublayer:rippleLayer below:_rippleButton.layer];
    
    //addRippleAnimation
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 30, 30)];
    CGRect endRect = CGRectInset([self makeEndRect], -30, -30);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];

    rippleLayer.path = endPath.CGPath;
    rippleLayer.opacity = 0.0;

    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 2.0;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.5];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 1.0;

    [rippleLayer addAnimation:opacityAnimation forKey:@""];
    [rippleLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:rippleLayer afterDelay:1.5];
}

- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer
{
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

- (void)closeRippleTimer
{
    if (_rippleTimer) {
        if ([_rippleTimer isValid]) {
            [_rippleTimer invalidate];
        }
        _rippleTimer = nil;
    }
}

@end
