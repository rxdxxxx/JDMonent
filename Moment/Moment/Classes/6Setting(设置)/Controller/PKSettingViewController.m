//
//  PKSettingViewController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKSettingViewController.h"
#import "PKSettingArrowItem.h"
#import "PKSettingGroup.h"
#import "PKSettingSwitchItem.h"
#import "MBProgressHUD+MJ.h"
#import "SDWebImageManager.h"
#import "PKAccount.h"
#import "PKAccountTool.h"
#import "PKHomeViewController.h"
#import "PKHomeRightView.h"

@interface PKSettingViewController ()

@end

@implementation PKSettingViewController

static PKSettingViewController *SettingSingletonInstance = nil;

#pragma mark - Initialization -

+ (PKSettingViewController *)sharedInstance
{
    if (!SettingSingletonInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            SettingSingletonInstance  = [[self alloc]init];
        });
    }
    return SettingSingletonInstance;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];;
    
    [self setupGroup0];

    [self setupFooter];

}


- (void)setupGroup0
{
    PKSettingGroup *group = [self addGroup];
    
    PKSettingArrowItem *clearCache = [PKSettingArrowItem itemWithTitle:@"清除图片缓存"];
    clearCache.operation = ^{
        // 弹框
        [MBProgressHUD showMessage:@"正在帮你拼命清理中..."];
        
        // 执行清除缓存 , 图片和SQLite
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        [mgr removeItemAtPath:cachePath error:nil];
        
        
        // 调用框架的清除缓存方法.
        //        [[SDWebImageManager sharedManager].imageCache clearDisk];
        
        // 关闭弹框
        [MBProgressHUD hideHUD];
        
        // 计算缓存文件夹的大小
        //        NSArray *subpaths = [mgr subpathsAtPath:cachePath];
        //        long long totalSize = 0;
        //        for (NSString *subpath in subpaths) {
        //            NSString *fullpath = [cachePath stringByAppendingPathComponent:subpath];
        //            BOOL dir = NO;
        //            [mgr fileExistsAtPath:fullpath isDirectory:&dir];
        //            if (dir == NO) {// 文件
        //                totalSize += [[mgr attributesOfItemAtPath:fullpath error:nil][NSFileSize] longLongValue];
        //            }
        //        }
    };
    
    group.items = @[clearCache];
}

- (void)setupFooter
{
    // 按钮
    UIButton *logoutButton = [[UIButton alloc] init];
    CGFloat logoutX = PKStatusTableBorder + 2;
    CGFloat logoutY = 10;
    CGFloat logoutW = self.tableView.frame.size.width - 2 * logoutX;
    CGFloat logoutH = 44;
    logoutButton.frame = CGRectMake(logoutX, logoutY, logoutW, logoutH);
    
    // 背景和文字
    [logoutButton setBackgroundImage:[UIImage resizedImageWithName:@"common_button_red"] forState:UIControlStateNormal];
    [logoutButton setBackgroundImage:[UIImage resizedImageWithName:@"common_button_red_highlighted"] forState:UIControlStateHighlighted];
    [logoutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = logoutH + 20;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:logoutButton];
}
/**
 *
 */
-(void)logoutClick
{
    // 弹框
    // 执行清除缓存 , 图片和SQLite
    
    PKAccount * account = [PKAccountTool account];
    if (account == nil) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr removeItemAtPath:PKAccountFile error:nil];
    PKHomeRightView * rightView  = [PKHomeViewController sharedInstance].rightView;
    [rightView reshowRightView];

    
    
    // 关闭弹框
    [MBProgressHUD showSuccess:@"已经成功退出"];
}

@end
