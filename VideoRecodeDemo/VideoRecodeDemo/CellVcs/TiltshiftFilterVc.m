//
//  TiltshiftFilterVc.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "TiltshiftFilterVc.h"
#import "GPUImage.h"
#import "GPUImagePicture.h"
#import "GPUImageTiltShiftFilter.h"

@interface TiltshiftFilterVc ()
@property (nonatomic , strong) GPUImagePicture * sourcePicture;
@property (nonatomic , strong) GPUImageTiltShiftFilter * sepiaFilter;
@end

@implementation TiltshiftFilterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GPUImageView * primaryView = [[GPUImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:primaryView];
    UIImage *inputImage = [UIImage imageNamed:@"face.png"];
    _sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage];
    _sepiaFilter = [[GPUImageTiltShiftFilter alloc] init];
    //模糊度 默认为7
    _sepiaFilter.blurRadiusInPixels = 30.0;
    [_sepiaFilter forceProcessingAtSize:primaryView.sizeInPixels];
    [_sourcePicture addTarget:_sepiaFilter];
    [_sepiaFilter addTarget:primaryView];
    [_sourcePicture processImage];
    
    
    // GPUImageContext相关的数据显示
    GLint size = [GPUImageContext maximumTextureSizeForThisDevice];
    GLint unit = [GPUImageContext maximumTextureUnitsForThisDevice];
    GLint vector = [GPUImageContext maximumVaryingVectorsForThisDevice];
    NSLog(@"%d %d %d", size, unit, vector);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.contentView addGestureRecognizer:tap];
}
- (void)tapGestureAction:(UITapGestureRecognizer *) sender {
    CGPoint point = [sender locationInView:self.view];
    float rate = point.y / self.contentView.bounds.size.height;
    NSLog(@"Processing");
    [_sepiaFilter setTopFocusLevel:rate - 0.1];
    [_sepiaFilter setBottomFocusLevel:rate + 0.1];
    [_sourcePicture processImage];
}



@end
