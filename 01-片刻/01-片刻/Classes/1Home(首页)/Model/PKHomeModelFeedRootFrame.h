//
//  PKHomeModelFeedRootFrame.h
//  01-片刻
//
//  Created by qianfeng on 15-5-1.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PKHomeModelFeedRoot;


typedef NS_ENUM(NSInteger, PKFeedCellType) {
    PKFeedCellTypeTimeLine,// 碎片
    PKFeedCellTypeArticle, // 文章
    PKFeedCellTypeGroup,   // 小组/话题
    PKFeedCellTypeTing     // 音频
};

@interface PKHomeModelFeedRootFrame : NSObject


#warning 这里是feed动态页面,还未完成: 规律发现:
/**
 *  1,如果,标题是 "无题"  ->>>  碎片  ->在判断userinfos, 有值,array.count推荐了碎片,无则是userinfo发布了一个碎片.碎片分为有无图片的两种布局 coverimg来判断.
    
 
    2,如果标题不是 "无题"  分两种 1,文章 2,ting, 用playinfo有值就是ting. 里面的音频列表可能需要在次请求
    
    2.1 文章分为有无图片的两种布局 coverimg来判断.
 
    2.2 ting只有一种布局.
 
    3,还有话题.
 
 */
@property (nonatomic, strong) PKHomeModelFeedRoot *status;

@property (nonatomic, assign)PKFeedCellType  cellType;


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
@property (nonatomic, assign) CGFloat cellHeight;

@end
