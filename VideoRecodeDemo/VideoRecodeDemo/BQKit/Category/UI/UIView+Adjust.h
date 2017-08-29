//
//  UIView+Adjust.h
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/22.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Adjust)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGPoint thisCenter;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
- (void)customRadius:(CGFloat)radius;
@end
