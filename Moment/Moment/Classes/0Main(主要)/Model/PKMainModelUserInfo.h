//
//  PKMainModelUserInfo.h
//  01-片刻
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKMainModelUserInfo : NSObject

@property (nonatomic, strong)NSNumber * uid;
/**
 *  用户名,昵称
 */
@property (nonatomic, copy)NSString * uname;
/**
 *  头像地址
 */
@property (nonatomic, copy)NSString * icon;




@end
