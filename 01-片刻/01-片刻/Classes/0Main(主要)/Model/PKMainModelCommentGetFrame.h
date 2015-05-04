//
//  PKMainModelCommentGetFrame.h
//  01-片刻
//
//  Created by qianfeng on 15-5-3.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PKMainModelCommentGet;

@interface PKMainModelCommentGetFrame : NSObject

@property (nonatomic, strong) PKMainModelCommentGet *status;

/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;

/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;

/** 发布时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;

/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@end
