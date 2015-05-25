//
//  AppDelegate.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "PKLeftMenuController.h"
#import "PKHomeViewController.h"
#import "PKHomeDetialController.h"
#import "SDWebImageManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 设置SDImage缓存的最大值,10M
    [SDImageCache sharedImageCache].maxCacheSize = 1024 * 1024 * 10;
    
    
    PKHomeViewController * homeVC = [[PKHomeViewController alloc] init];
//    PKHomeDetialController * homeVC = [[PKHomeDetialController alloc] init];
    homeVC.title = @"首页";
    SlideNavigationController * slideNav = [[SlideNavigationController alloc]initWithRootViewController:homeVC];

    PKLeftMenuController * leftMC = [[PKLeftMenuController alloc]init];
    slideNav.leftMenu = leftMC;

    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Opened %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Revealed %@", menu);
    }];

    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen ]bounds]];
    self.window.rootViewController = slideNav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
    // 开启后台任务,让程序保持运行状态,在更改plist文件
    [application beginBackgroundTaskWithExpirationHandler:nil];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 停止下载所有图片
    [[SDWebImageManager sharedManager] cancelAll];
    
    // 清除内存中的图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}
@end
