//
//  PKAccountParam.h
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKAccountParam : NSObject

@property (nonatomic, copy)NSString * uname;
@property (nonatomic, strong)NSNumber * gender;
@property (nonatomic, strong)NSNumber * client;
@property (nonatomic, copy)NSString * email;
@property (nonatomic, copy)NSString * passwd;

@end
