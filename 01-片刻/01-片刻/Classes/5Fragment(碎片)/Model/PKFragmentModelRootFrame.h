//
//  PKFragmentModelRootFrame.h
//  01-片刻
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PKFragmentModelRoot;

@interface PKFragmentModelRootFrame : NSObject

@property (nonatomic, strong) PKFragmentModelRoot *status;

/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;

/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;

/** 发布时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;

/** 配图 */
@property (nonatomic, assign, readonly) CGRect photoViewF;

/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
