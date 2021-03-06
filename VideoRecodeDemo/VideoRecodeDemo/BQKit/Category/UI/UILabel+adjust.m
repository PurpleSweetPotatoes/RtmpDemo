//
//  UILabel+adjust.m
//  Test
//
//  Created by MrBai on 2017/6/28.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UILabel+adjust.h"
#import "UIView+Adjust.h"

@implementation UILabel (adjust)
- (CGFloat)adjustHeightForFont {
    if (self.text.length > 0) {
        CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
        self.height = rect.size.height;
    }
    return  self.height;
}
- (CGFloat)adjustWidthForFont {
    if (self.text.length > 0) {
        CGRect rect = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
        self.width = rect.size.width;
    }
    return  self.width;
}
@end
