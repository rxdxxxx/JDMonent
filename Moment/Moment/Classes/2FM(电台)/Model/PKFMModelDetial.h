//
//  PKFMModelDetial.h
//  01-片刻
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKMainModelUserInfo;

@interface PKFMModelDetial : NSObject

@property (nonatomic, copy)NSString * radioid;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * coverimg;
@property (nonatomic, strong)PKMainModelUserInfo * userinfo;
@property (nonatomic, assign)BOOL  isnew;

@end
