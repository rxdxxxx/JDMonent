//
//  PKFMModelRadioInfo.h
//  01-片刻
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKMainModelUserInfo;

@interface PKFMModelRadioInfo : NSObject

@property (nonatomic, copy)NSString * radioid;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * coverimg;
@property (nonatomic, copy)NSString * desc;
@property (nonatomic, strong)PKMainModelUserInfo * userinfo;
@property (nonatomic, strong)NSNumber * musicvisitnum;


@end
