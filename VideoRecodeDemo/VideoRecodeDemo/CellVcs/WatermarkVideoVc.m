//
//  MergeVideoVc.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "WatermarkVideoVc.h"
#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface WatermarkVideoVc ()
{
    GPUImageMovie *movieFile;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
}

@end

@implementation WatermarkVideoVc

- (void)dealloc {
    NSLog(@"水印vc释放");
    [filter removeTarget:movieWriter];
    [movieFile cancelProcessing];
    [movieWriter cancelRecording];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GPUImageView *filterView = [[GPUImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:filterView];
    
    filter = [[GPUImageDissolveBlendFilter alloc] init];
    [(GPUImageDissolveBlendFilter *)filter setMix:0.5];
    
    // 播放
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"m4v"];
    AVAsset *asset = [AVAsset assetWithURL:sampleURL];
    CGSize size = self.contentView.bounds.size;
    movieFile = [[GPUImageMovie alloc] initWithAsset:asset];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = YES;
    
    // 水印
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"我是水印";
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    UIImage *image = [UIImage imageNamed:@"watermark.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    subView.backgroundColor = [UIColor clearColor];
    imageView.center = CGPointMake(subView.bounds.size.width / 2, subView.bounds.size.height / 2);
    [subView addSubview:imageView];
    [subView addSubview:label];
    
    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
    [uielement addTarget:filter];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    [movieFile addTarget:progressFilter];
    [progressFilter addTarget:filter];
    [uielement addTarget:filter];
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    // 显示到界面
    [filter addTarget:filterView];
    [filter addTarget:movieWriter];
    
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    __weak typeof(self) weakSelf = self;
    
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        CGRect frame = imageView.frame;
        frame.origin.x += 1;
        frame.origin.y += 1;
        imageView.frame = frame;
        [uielement updateWithTimestamp:time];
    }];
    
    [movieWriter setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf handleCompletPathToMovie:pathToMovie];
    }];
}
- (void)handleCompletPathToMovie:(NSString *)pathToMovie {
    [filter removeTarget:movieWriter];
    [movieWriter finishRecording];
    UISaveVideoAtPathToSavedPhotosAlbum(pathToMovie, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        NSLog(@"保存成功");
    }else {
        NSLog(@"保存失败");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
