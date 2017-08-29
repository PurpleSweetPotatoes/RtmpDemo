//
//  CameraFocusLayer.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/28.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "CameraFocusLayer.h"
#import <UIKit/UIKit.h>

@interface CameraFocusLayer () <CAAnimationDelegate>

@end

@implementation CameraFocusLayer

+ (instancetype)layerWithPoint:(CGPoint)positon bounds:(CGRect)bounds
{
    CameraFocusLayer * layer = [CameraFocusLayer layer];
    layer.bounds = bounds;
    layer.position = positon;
    [layer customLayerPath];
    return layer;
}
+ (instancetype)layerWithPoint:(CGPoint)positon
{
    return [CameraFocusLayer layerWithPoint:positon bounds:CGRectMake(0, 0, 80, 80)];
}
- (void)customLayerPath {
    CGFloat line = 8;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(width - line, 0)];
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width, line)];
    
    [path moveToPoint:CGPointMake(width, height - line)];
    [path addLineToPoint:CGPointMake(width, height)];
    [path addLineToPoint:CGPointMake(width - line, height)];
    
    [path moveToPoint:CGPointMake(line, height)];
    [path addLineToPoint:CGPointMake(0, height)];
    [path addLineToPoint:CGPointMake(0, height - line)];
    
    
    [path moveToPoint:CGPointMake(0, line)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(line, 0)];
    
    
    [path moveToPoint:CGPointMake(width * 0.5 - 6, height * 0.5)];
    [path addArcWithCenter:CGPointMake(width * 0.5, height * 0.5) radius:6 startAngle:-M_PI endAngle:M_PI clockwise:YES];
    
    self.path = path.CGPath;
    self.fillColor = [UIColor clearColor].CGColor;
    self.strokeColor = [UIColor greenColor].CGColor;
    self.lineWidth = 1.0f;
}
- (void)startAnmation {
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = @0.6;
    scaleAnimation.duration = 0.5;
    scaleAnimation.delegate = self;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self addAnimation:scaleAnimation forKey:nil];

}

- (void)removeSelf {
    [self removeAllAnimations];
    [self removeFromSuperlayer];
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        CAKeyframeAnimation * flickerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
        flickerAnimation.values = @[@0,@1,@0,@1,@0];
        flickerAnimation.keyTimes = @[@0.2,@0.4,@0.6,@0.8,@1];
        flickerAnimation.duration = 1.5;
        flickerAnimation.delegate = self;
        [self addAnimation:flickerAnimation forKey:@"flicker"];
    }else {
        [self removeFromSuperlayer];
    }
}
@end
