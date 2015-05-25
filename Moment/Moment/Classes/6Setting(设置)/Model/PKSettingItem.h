//
//  PKSettingItem.h
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PKSettingItemOperation)();

@interface PKSettingItem : NSObject

@property (nonatomic, copy)NSString * icon;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * subtitle;
@property (nonatomic, copy)NSString * badgeValue;

/** 需要执行的任务*/
@property (nonatomic, copy)PKSettingItemOperation operation;

+(instancetype)itemWithIcon :(NSString *)icon title:(NSString *)title;
+(instancetype)itemWithTitle:(NSString *)title;
+(instancetype)item;


@end
