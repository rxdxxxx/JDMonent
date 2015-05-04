//
//  PKMainModelCommentGet.h
//  01-片刻
//
//  Created by qianfeng on 15-5-3.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PKMainModelUserInfo;

@interface PKMainModelCommentGet : NSObject

@property (nonatomic, copy)NSString * contentid;
@property (nonatomic, strong)PKMainModelUserInfo * userinfo;
@property (nonatomic, strong)PKMainModelUserInfo * reuserinfo;
@property (nonatomic, copy)NSString * addtime_f;
@property (nonatomic, copy)NSString * content;
@property (nonatomic, assign)BOOL isdel;


@end
