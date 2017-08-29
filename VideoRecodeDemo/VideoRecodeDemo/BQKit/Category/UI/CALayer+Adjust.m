//
//  CALayer+Adjust.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/22.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "CALayer+Adjust.h"

@implementation CALayer (Adjust)
- (void)setOrigin:(CGPoint)origin{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}
- (void)setThisCenter:(CGPoint)thisCenter {
    
}
- (CGPoint)thisCenter {
    return CGPointMake(self.width * 0.5,self.height * 0.5);
}
- (CGPoint)origin{
    return self.frame.origin;
}
- (void)setLeft:(CGFloat)left{
    CGRect rect = self.frame;
    rect.origin.x  = left;
    self.frame = rect;
}
- (CGFloat)left{
    return self.origin.x;
}
- (void)setTop:(CGFloat)top{
    CGRect rect = self.frame;
    rect.origin.y  = top;
    self.frame = rect;
}
- (CGFloat)top{
    return self.origin.y;
}
- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}
- (CGSize)size{
    return self.frame.size;
}
- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width  = width;
    self.frame = rect;
}
- (CGFloat)width {
    return self.size.width;
}
- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (CGFloat)height {
    return self.size.height;
}
- (void)setBottom:(CGFloat)bottom{
    self.top = bottom - self.height;
}
- (void)setRight:(CGFloat)right{
    self.left = right - self.width;
}
- (CGFloat)right {
    return self.left + self.width;
}
- (CGFloat)bottom {
    return self.top + self.height;
}
@end
