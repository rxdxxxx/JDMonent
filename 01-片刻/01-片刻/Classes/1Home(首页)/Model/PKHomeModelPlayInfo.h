//
//  PKHomeModelPlayInfo.h
//  01-片刻
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PKMainModelUserInfo;
@class PKMainModelShareInfo;

@interface PKHomeModelPlayInfo : NSObject

@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * imgUrl;
@property (nonatomic, copy)NSString * musicUrl;
@property (nonatomic, copy)NSString * tingid;
@property (nonatomic, strong)PKMainModelUserInfo * userinfo;
@property (nonatomic, strong)PKMainModelUserInfo * authorinfo;
@property (nonatomic, copy)NSString * webview_url;
@property (nonatomic, copy)NSString * ting_contentid;
@property (nonatomic, copy)NSString * sharepic;
@property (nonatomic, copy)NSString * sharetext;
@property (nonatomic, copy)NSString * shareurl;

@property (nonatomic, strong)PKMainModelShareInfo * shareinfo;
















@end
