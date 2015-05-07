//
//  PKAccountTool.h
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKAccountParam.h"
#import "PKAccountResult.h"

@class PKAccount;

@interface PKAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 需要存储的信息
 */
+(void)saveAccount:(PKAccount *)account;

+(PKAccount *)account;

/**
 *  发送认证请求
 */
/**
 *  注册
 */
+(void)postRegWithParam:(PKAccountParam *)param success:(void (^)(PKAccountResult *))success failure:(void (^)(NSError *))failure;

/**
 *  登录
 */
+(void)postLoginWithParam:(PKAccountParam *)param success:(void (^)(PKAccountResult *))success failure:(void (^)(NSError *))failure;


@end
