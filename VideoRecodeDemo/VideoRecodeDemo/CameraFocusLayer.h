//
//  CameraFocusLayer.h
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/28.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CameraFocusLayer : CAShapeLayer
+ (instancetype)layerWithPoint:(CGPoint)positon;
+ (instancetype)layerWithPoint:(CGPoint)positon
                         bounds:(CGRect)bounds;
- (void)startAnmation;
- (void)removeSelf;
@end
