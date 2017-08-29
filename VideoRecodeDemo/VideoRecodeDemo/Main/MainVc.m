//
//  VideoRecodeMainVc.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/22.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "MainVc.h"
#import "BQKit.h"
#import "VideoRecodeVc.h"
#import "PushRtmpVc.h"

static NSString * const identif = @"UITableViewCell";

@interface MainVc () <
UITableViewDataSource,
UITableViewDelegate >
@property (nonatomic, strong) NSArray * cellInfos;
@end

@implementation MainVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellInfos = @[@{@"title":@"图片滤镜",
                         @"class":@"FilterImageVc"},
                       @{@"title":@"开启摄像头",
                         @"class":@"VideoCameraVc"},
                       @{@"title":@"模糊图片",
                         @"class":@"TiltshiftFilterVc"},
                       @{@"title":@"视频水印",
                         @"class":@"WatermarkVideoVc"},
                       @{@"title":@"图像生成",
                         @"class":@"RawDataImageVc"}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"GPUImage Demo";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"录像" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"推流" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemAction:)];
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identif];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
}
- (void)leftBarItemAction:(UIBarButtonItem *) sender
{
    [self.navigationController presentViewController:[[PushRtmpVc alloc] init] animated:YES completion:nil];
}
- (void)rightBarItemAction:(UIBarButtonItem *) sender
{
    [self.navigationController presentViewController:[[VideoRecodeVc alloc] init] animated:YES completion:nil];
}

#pragma mark - tableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellInfos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identif forIndexPath:indexPath];
    NSDictionary * cellInfo = self.cellInfos[indexPath.row];
    NSString * content = [NSString stringWithFormat:@"%@-%@",cellInfo[@"title"],cellInfo[@"class"]];
    cell.textLabel.text = content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * cellInfo = self.cellInfos[indexPath.row];
    Class class = NSClassFromString(cellInfo[@"class"]);
    UIViewController * vc = [[class alloc] init];
    vc.title = cellInfo[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)checkIsSimublator {
    return TARGET_OS_SIMULATOR;
}
@end
