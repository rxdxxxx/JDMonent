//
//  PKAccountTool.m
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKAccountTool.h"
#import "PKAccount.h"
#import "IWHttpTool.h"
#import "MJExtension.h"


#define PKAccountFile   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation PKAccountTool
/**
 *  存储账号,现在只能存储一个账号,要想存储多个账号,就把多个账号用数组装好,在存起来.
 *
 *  @param account
 */
+(void)saveAccount:(PKAccount *)account
{
//    NSDate * now = [NSDate date];
    //计算账号的过期时间
//    account.expiresTime =[now dateByAddingTimeInterval:account.expires_in];
    
    [NSKeyedArchiver archiveRootObject:account toFile:PKAccountFile];
}

/**
 *  返回存储的账号信息
 *
 */
+(PKAccount *)account
{
    
    //取出账号
    PKAccount * account = [NSKeyedUnarchiver unarchiveObjectWithFile:PKAccountFile];
    
    return account;
    
//    // 判断账号是否过期.
//    NSDate * now = [NSDate date];
//    if ([now compare:account.expiresTime] == NSOrderedAscending  ) {// 还没有过期
//        return account;
//    }else{ // 已经过期
//        return nil;
//    }
}

/**
 *  注册
 */
+(void)postRegWithParam:(PKAccountParam *)param success:(void (^)(PKAccountResult *))success failure:(void (^)(NSError *))failure
{
    [IWHttpTool postWithURL:@"http://api2.pianke.me/user/reg" params:param.keyValues success:^(id json) {
        if (success) {
            //字典转模型
            PKAccountResult * result = [PKAccountResult objectWithKeyValues:json[@"data"]];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  登录
 */
+(void)postLoginWithParam:(PKAccountParam *)param success:(void (^)(PKAccountResult *))success failure:(void (^)(NSError *))failure
{
    NSDictionary * dict = @{@"client":param.client,@"email":param.email,@"passwd":param.passwd};
    
    [IWHttpTool postWithURL:@"http://api2.pianke.me/user/login" params:dict success:^(id json) {
        if (success) {
            
            
            //字典转模型
            PKAccountResult * result = [PKAccountResult objectWithKeyValues:json[@"data"]];
            
            PKLog(@"%@",result.auth);
            
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
