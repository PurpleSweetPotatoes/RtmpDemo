//
//  ViewController.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/22.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "VideoRecodeVc.h"
#import "VideoEnum.h"
#import "GPUImage.h"
#import "BQKit.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "CameraFocusLayer.h"


@interface VideoRecodeVc ()

@property (nonatomic, strong) GPUImageVideoCamera * videoCamera;
@property (nonatomic, strong) GPUImageOutput <GPUImageInput> * customFilter;
@property (nonatomic, strong) GPUImageView * filteredVideoView;
@property (nonatomic, strong) GPUImageMovieWriter * movieWriter;
@property (nonatomic, weak) CameraFocusLayer * focusLayer;
@end

@implementation VideoRecodeVc
- (void)dealloc {
    [self.videoCamera stopCameraCapture];
    NSLog(@"%@释放",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //视频流使用GPUImageVideoCamera
    self.videoCamera =[[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation =
    UIInterfaceOrientationPortrait;
    [self.videoCamera addAudioInputsAndOutputs];
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.customFilter = [[GPUImageFilter alloc] init];
    GPUImageView * filteredVideoView = [[GPUImageView alloc] initWithFrame:self.view.bounds];

    self.filteredVideoView = filteredVideoView;
    // Add the view somewhere so it's visible
    
    [self.videoCamera addTarget:self.customFilter];
    [self.customFilter addTarget:self.filteredVideoView];
    
    [self.videoCamera startCameraCapture];
    [self.view addSubview:filteredVideoView];

    [self addButtonViews];
    [self addTapGesture];
}
- (void)addTapGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.view addGestureRecognizer:tap];
}
- (void)addButtonViews {
    CGFloat btnW = 36;
    CGFloat spacing = 20;
    CGFloat left = self.view.width - btnW - spacing;
    
    [self addBtnWithFrame:CGRectMake(spacing, spacing, btnW, btnW) imageName:@"clear" tag:VideoBtnTypeBack];
    [self addBtnWithFrame:CGRectMake(left, spacing, btnW, btnW) imageName:@"camera" tag:VideoBtnTypeCamera];
    [self addBtnWithFrame:CGRectMake(left, spacing * 2 + btnW, btnW, btnW) imageName:@"magic" tag:VideoBtnTypeMagic];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.width * 0.5 - 45, self.view.height - 80, 90, 40);
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [btn customRadius:btn.height * 0.5];
    [btn addTarget:self action:@selector(recodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:@"录制" forState:UIControlStateNormal];
    [btn setTitle:@"结束" forState:UIControlStateSelected];
    [self.view addSubview:btn];
}
- (void)addBtnWithFrame:(CGRect)frame imageName:(NSString *)imageName tag:(VideoBtnType)tag{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag;
    [btn addTarget:self action:@selector(videoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}
#pragma mark - recode Method
- (void)startRecodeVideo {
    NSURL * movieURL = [self videoPathUrl];
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
    self.movieWriter.encodingLiveVideo = YES;
    self.movieWriter.shouldPassthroughAudio = YES;
    [self.customFilter addTarget:self.movieWriter];
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    [self.movieWriter startRecording];
}
- (void)endRecodeVideo {
    [self.customFilter removeTarget:self.movieWriter];
    self.videoCamera.audioEncodingTarget = nil;
    [self.movieWriter finishRecording];
    NSLog(@"Movie completed");
    [self saveVideo];
}
- (NSURL *)videoPathUrl {
    NSString * pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.m4v"];
    unlink([pathToMovie UTF8String]);
    return [NSURL fileURLWithPath:pathToMovie];
}
- (void)saveVideo {
    UISaveVideoAtPathToSavedPhotosAlbum([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.m4v"], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}
//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString * msg = nil;
    if (error) {
        msg = [NSString stringWithFormat:@"保存视频失败%@", error.localizedDescription];
    }
    else {
        msg = @"保存视频成功";
    }
    [BQMsgView showTitle:@"温馨提示" info:msg];
}

#pragma mark - event action Method
- (void)videoBtnAction:(UIButton *) sender {
    switch (sender.tag) {
        case VideoBtnTypeMagic:
            NSLog(@"魔法棒点击");
            
            break;
        case VideoBtnTypeCamera:
            NSLog(@"摄像头转换点击");
            [self.videoCamera rotateCamera];
            break;
        case VideoBtnTypeBack:
            NSLog(@"返回按钮点击");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            NSLog(@"其他按钮点击");
            break;
    }
}
- (void)tapGestureAction:(UITapGestureRecognizer *) sender {
    CGPoint point = [sender locationInView:self.filteredVideoView];
    if (self.focusLayer) {
        [self.focusLayer removeSelf];
    }
    self.focusLayer = [CameraFocusLayer layerWithPoint:point];
    [self.view.layer addSublayer:self.focusLayer];
    [self.focusLayer startAnmation];
    [self setFocusPoint:point];
}

//对焦
- (void)setFocusPoint:(CGPoint)point {
    if (self.videoCamera.inputCamera.isFocusPointOfInterestSupported) {
        NSError *error = nil;
        [self.videoCamera.inputCamera lockForConfiguration:&error];
        //设置焦点的位置
        if ([self.videoCamera.inputCamera isFocusPointOfInterestSupported]) {
            [self.videoCamera.inputCamera setFocusPointOfInterest:point];
        }
        [self.videoCamera.inputCamera unlockForConfiguration];
    }
}
- (void)recodeBtnAction:(UIButton *) sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self startRecodeVideo];
    }else {
        [self endRecodeVideo];
    }
}
- (BOOL)prefersStatusBarHidden {
    return  YES;
}

@end
