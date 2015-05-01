//
//  PKLoginReginController.h
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKLoginController;

@protocol PKLoginControllerDelegate <NSObject>

@optional
-(void)reloadViewAfterLogin:(PKLoginController *)loginController;

@end



@interface PKLoginController : UIViewController

@property (nonatomic, weak)id<PKLoginControllerDelegate> delegate;


@end
