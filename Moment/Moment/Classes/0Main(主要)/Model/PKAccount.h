//
//  PKAccount.h
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKAccount : NSObject <NSCoding>

/**
 *  账号的制定标示符, 其他关于账号的请求均需要这个参数
 */
@property (nonatomic, copy)NSString * auth;
@property (nonatomic, copy)NSString * coverimg;
/**
 *  用户头像
 */
@property (nonatomic, copy)NSString * icon;

@property (nonatomic, assign)long long uid;

/**
 *  用户昵称
 */
@property (nonatomic, copy)NSString * uname;


@property (nonatomic, copy)NSString * msg;


//@property (nonatomic, strong)NSDate * expiresTime;//账号的过期时间



+(instancetype)accountWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;



@end
