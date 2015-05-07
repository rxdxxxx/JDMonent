//
//  PKRegController.h
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PKRegControllerDelegate <NSObject>

@optional
/**
 *  把成功注册的信息回传到登录页面.
 */
-(void)sendLoginEmail:(NSString *)emailStr passWord:(NSString*)passwordStr;

@end

@interface PKRegController : UIViewController<PKRegControllerDelegate>

@property (nonatomic, weak)id<PKRegControllerDelegate> delegate;

@end
