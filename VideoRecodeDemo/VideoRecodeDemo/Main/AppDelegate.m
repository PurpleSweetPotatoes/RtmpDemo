//
//  AppDelegate.m
//  VideoRecodeDemo
//
//  Created by MrBai on 2017/8/22.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVc.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController * rootVc = [[UINavigationController alloc] initWithRootViewController:[[MainVc alloc] init]];
    self.window.rootViewController = rootVc;
    [self.window makeKeyAndVisible];
    return YES;
}
@end
