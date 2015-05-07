//
//  PKReadModelDetialWebview.h
//  01-片刻
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKMainModelRoot.h"
@class PKMainModelUserInfo;
@class PKMainModelCounter;

@interface PKReadModelDetialWebview : PKMainModelRoot

@property (nonatomic, strong)PKMainModelUserInfo * userinfo;
@property (nonatomic, copy)NSString * songid;
@property (nonatomic, strong)PKMainModelCounter * counterList;
@property (nonatomic, copy)NSString * addtime_f;
@property (nonatomic, assign)BOOL islike;
@property (nonatomic, assign)BOOL isfav;
@property (nonatomic, copy)NSString * html;
@property (nonatomic, strong)NSMutableArray * commentlist;


@end
