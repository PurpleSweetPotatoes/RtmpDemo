//
//  PushRtmpVc.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/25.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "PushRtmpVc.h"
#import "LFRtmpService.h"
#import "VideoEnum.h"
#import "UIView+Adjust.h"
#import "CameraFocusLayer.h"

static NSString * const pushRtmpUrl = @"rtmp://139.199.159.141/hls/MrBai";

@interface PushRtmpVc ()<LFRtmpServiceDelegate>
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UIButton * lightBtn;
@property (nonatomic, weak) CameraFocusLayer * focusLayer;
@end

@implementation PushRtmpVc
{
    LFRtmpService * rtmpService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configRtmpService];
    [self addCustomView];
    
    [self addTapGesture];
}

- (void)configRtmpService {
    rtmpService = [LFRtmpService sharedInstance];
    [rtmpService setFocusMode:AVCaptureFocusModeAutoFocus];
    //配置视频信息
    LFVideoConfig * videoConfig = [[LFVideoConfig alloc] init:LFVideoConfigQuality_Hight3 isLandscape:NO];
    //配置音频信息
    LFAudioConfig * audioConfig = [LFAudioConfig defaultConfig];
    //配置rtmp信息
    [rtmpService setupWithVideoConfig:videoConfig audioConfig:audioConfig preview:self.view];
    //配置滤镜
    [rtmpService setFilterType:LFCameraDeviceFilter_Original];
    
    //配置推流地址
    rtmpService.urlParser=[[LFRtmpUrlParser alloc] initWithUrl:pushRtmpUrl port:1935];
    
    rtmpService.delegate = self;
}
- (void)addCustomView {
    CGFloat btnW = 45;
    CGFloat spacing = 20;
    CGFloat left = self.view.width - btnW - spacing;
    
    [self addBtnWithFrame:CGRectMake(spacing, spacing, btnW, btnW) imageName:@"clear" tag:VideoBtnTypeBack];
    [self addBtnWithFrame:CGRectMake(left, spacing, btnW, btnW) imageName:@"camera" tag:VideoBtnTypeCamera];
    [self addBtnWithFrame:CGRectMake(left, spacing * 2 + btnW, btnW, btnW) imageName:@"open_light" tag:VideoBtnTypeLight];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.width * 0.5 - 45, self.view.height - 80, 90, 30);
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [btn customRadius:btn.height * 0.5];
    [btn addTarget:self action:@selector(pushRtmpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:@"推流" forState:UIControlStateNormal];
    [btn setTitle:@"停止" forState:UIControlStateSelected];
    [self.view addSubview:btn];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.top - 30, self.view.width, 30)];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:15];
    self.statusLabel.textColor = [UIColor redColor];
    self.statusLabel.text = @"未连接";
    [self.view addSubview:self.statusLabel];
}
- (void)addTapGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoCameratapGestureAction:)];
    [self.view addGestureRecognizer:tap];
}
- (void)addBtnWithFrame:(CGRect)frame imageName:(NSString *)imageName tag:(VideoBtnType)tag
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag;
    [btn addTarget:self action:@selector(rtmpVideoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if ([imageName isEqualToString:@"open_light"]) {
        [btn setImage:[UIImage imageNamed:@"close_light"] forState:UIControlStateSelected];
        btn.hidden = YES;
        self.lightBtn = btn;
    }
    [self.view addSubview:btn];
}

#pragma mark - rtmp Btn Action 
- (void)pushRtmpBtnAction:(UIButton *) sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [rtmpService start];
    }else {
        self.statusLabel.text = @"未连接";
        [rtmpService stop];
    }
}
- (void)rtmpVideoBtnAction:(UIButton *) sender {
    switch (sender.tag) {
        case VideoBtnTypeLight:
            NSLog(@"闪光灯点击");
            sender.selected = !sender.isSelected;
            rtmpService.isOpenFlash = sender.isSelected;
            break;
        case VideoBtnTypeCamera:
            NSLog(@"摄像头转换点击");
            [self turnRoundCamera];
            break;
        case VideoBtnTypeBack:
            NSLog(@"返回按钮点击");
            [rtmpService quit];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            NSLog(@"其他按钮点击");
            break;
    }
}
- (void)turnRoundCamera {
    
    [rtmpService rotateCamera];
    
    self.lightBtn.hidden = rtmpService.devicePosition == AVCaptureDevicePositionFront;
    if (self.lightBtn.isHidden) {
        self.lightBtn.selected = NO;
    }
}
#pragma mark - Gesture Action 
- (void)videoCameratapGestureAction:(UITapGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:self.view];
    if (self.focusLayer) {
        [self.focusLayer removeSelf];
    }
    [rtmpService setFocusMode:AVCaptureFocusModeLocked];
    self.focusLayer = [CameraFocusLayer layerWithPoint:point];
    [self.view.layer addSublayer:self.focusLayer];
    [rtmpService setFocusPoint:point];
    [self.focusLayer startAnmation];
}

#pragma mark LFRtmpServiceDelegate
/**
 *  当rtmp状态发生改变时的回调
 *
 *  @param status 状态描述符
 */
-(void)onRtmpStatusChange:(LFRTMPStatus)status message:(id)message{
    switch (status) {
        case LFRTMPStatusConnectionFail:
        {
            self.statusLabel.text = @"连接失败!重连中...";
        }
            break;
        case LFRTMPStatusPublishSending:
        {
            self.statusLabel.text = @"流发布中";
        }
            break;
        case LFRTMPStatusPublishReady:
        {
            self.statusLabel.text = [NSString stringWithFormat:@"推流:%@",pushRtmpUrl];
        }
            break;
        case LFRTMPStatusPublishFail:
        {
            self.statusLabel.text = @"流发布失败，restart";
            [rtmpService reStart];
        }
            break;
        case LFRTMPStatusPublishFailBadName:
        {
            self.statusLabel.text = @"错误的流地址";
            //这种情况可能是推流地址过期造成的，可获取新的推流地址，重新开始连接
            //rtmpService.urlParser=[[LFRtmpUrlParser alloc] initWithUrl:@"新推流地址" port:1935];
            [rtmpService reStart];
        }
            break;
        default:
            break;
    }
}




- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
