//
//  PKFMModelList.h
//  01-片刻
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKHomeModelPlayInfo;

@interface PKFMModelList : NSObject
/**
 *  图片
 */
@property (nonatomic, copy)NSString * coverimg;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * tingid;
@property (nonatomic, copy)NSString * musicVisit;
/**
 *  音频的地址
 */
@property (nonatomic, copy)NSString * musicUrl;
/**
 *  音频信息
 */
@property (nonatomic, strong)PKHomeModelPlayInfo * playInfo;
@property (nonatomic, assign)BOOL isnew;


@end
