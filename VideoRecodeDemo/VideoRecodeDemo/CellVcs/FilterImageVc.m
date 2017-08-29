//
//  BaseImageVc.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "FilterImageVc.h"
#import "GPUImage.h"

@interface FilterImageVc ()
@property (nonatomic , strong) UIImageView * imageView;
@end

@implementation FilterImageVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [self filterImage];
}
- (void)filterImage {
    GPUImageFilter *filter = [[GPUImageSepiaFilter alloc] init];
    UIImage *image = [UIImage imageNamed:@"face"];
    if (image) {
        self.imageView.image = [filter imageByFilteringImage:image];
    }
}


@end
