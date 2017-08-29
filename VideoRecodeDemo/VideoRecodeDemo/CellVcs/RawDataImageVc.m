//
//  RawDataImageVc.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "RawDataImageVc.h"
#import "GPUImage.h"

@interface RawDataImageVc ()
{
    GPUImageVideoCamera *videoCamera;
}
@property (nonatomic , strong) UIImageView * mImageView;
@property (nonatomic , strong) GPUImageRawDataOutput * mOutput;
@end

@implementation RawDataImageVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GPUImageView * filterView = [[GPUImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:filterView];
    
    self.mImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    self.mImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.mImageView];
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    self.mOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(640, 480) resultsInBGRAFormat:YES];
    
    [videoCamera addTarget:self.mOutput];
    
    
    __weak typeof(self) wself = self;
    __weak typeof(self.mOutput) weakOutput = self.mOutput;
    [self.mOutput setNewFrameAvailableBlock:^{
        
        __strong GPUImageRawDataOutput *strongOutput = weakOutput;
        __strong typeof(wself) strongSelf = wself;
        [strongOutput lockFramebufferForReading];
        GLubyte *outputBytes = [strongOutput rawBytesForImage];
        NSInteger bytesPerRow = [strongOutput bytesPerRowInOutput];
        CVPixelBufferRef pixelBuffer = NULL;
        CVReturn ret = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, 640, 480, kCVPixelFormatType_32BGRA, outputBytes, bytesPerRow, nil, nil, nil, &pixelBuffer);
        if (ret != kCVReturnSuccess) {
            NSLog(@"status %d", ret);
        }        
        [strongOutput unlockFramebufferAfterReading];
        if(pixelBuffer == NULL) {
            return ;
        }
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, strongOutput.rawBytesForImage, bytesPerRow * 480, NULL);
        
        CGImageRef cgImage = CGImageCreate(640, 480, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        [strongSelf updateWithImage:image];
        //        NSData *pngData = UIImagePNGRepresentation(image);
        
        CGImageRelease(cgImage);
        CFRelease(pixelBuffer);
        
    }];
    
    [videoCamera startCameraCapture];
}

- (void)updateWithImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mImageView.image = image;
    });
}

@end
