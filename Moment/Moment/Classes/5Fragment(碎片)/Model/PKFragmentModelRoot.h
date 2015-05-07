//
//  PKFragmentModelRoot.h
//  01-片刻
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKMainModelRoot.h"

@class PKMainModelUserInfo;
@class PKMainModelCounter;


@interface PKFragmentModelRoot : PKMainModelRoot

@property (nonatomic, strong)PKMainModelUserInfo * userinfo;
@property (nonatomic, strong)NSNumber * addtime;
@property (nonatomic, copy)NSString * addtime_f;
@property (nonatomic, copy)NSString * songid;
@property (nonatomic, copy)NSString * content;
@property (nonatomic, strong)PKMainModelCounter * counterList;
@property (nonatomic, copy)NSString * coverimg;
@property (nonatomic, copy)NSString * coverimg_wh;

@end
