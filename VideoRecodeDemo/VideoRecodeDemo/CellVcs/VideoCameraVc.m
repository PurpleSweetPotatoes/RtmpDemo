//
//  VideoCameraVc.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "VideoCameraVc.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"

@interface VideoCameraVc ()
@property (nonatomic, strong) GPUImageView * gpuImageView;
@property (nonatomic, strong) GPUImageVideoCamera *gpuVideoCamera;
@end

@implementation VideoCameraVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.gpuVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.gpuVideoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.gpuImageView = [[GPUImageView alloc] initWithFrame:self.contentView.bounds];
    self.gpuImageView.fillMode = kGPUImageFillModeStretch;
    //美颜滤镜
    GPUImageBeautifyFilter * filter = [[GPUImageBeautifyFilter alloc] init];
    [self.gpuVideoCamera addTarget:filter];
    [filter addTarget:self.gpuImageView];
    
    //[self.mGPUVideoCamera addTarget:self.mGPUImageView];
    
    [self.gpuVideoCamera startCameraCapture];
    
    [self.contentView addSubview:self.gpuImageView];
    
    
    //设备转向时调整
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    self.gpuVideoCamera.outputImageOrientation = orientation;
}

@end
