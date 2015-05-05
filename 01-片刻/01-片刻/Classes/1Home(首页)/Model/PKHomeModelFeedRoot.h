//
//  PKHomeModelFeedRoot.h
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKMainModelRoot.h"
@class PKMainModelUserInfo;
@class PKMainModelCounter;
@class PKHomeModelPlayInfo;

typedef NS_ENUM(NSInteger, PKCellFeedType) {
    PKCellFeedTypeTing = 1,
    
    PKCellFeedTypeTimelineNone,
    PKCellFeedTypeTimelinePhoto,
    
    PKCellFeedTypeArticleWithPhoto,
    PKCellFeedTypeArticleWithoutPhoto,
    
    PKCellFeedTypeOther
};


@interface PKHomeModelFeedRoot : PKMainModelRoot

@property (nonatomic, strong)NSNumber * type;
@property (nonatomic, strong)PKMainModelUserInfo * userinfo;
@property (nonatomic, strong)PKMainModelUserInfo * reuseinfo;
@property (nonatomic, copy)NSString * addtime_f;
@property (nonatomic, copy)NSString * songid;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * content;
@property (nonatomic, strong)PKMainModelCounter * counterList;
@property (nonatomic, strong)NSNumber * ctype;
@property (nonatomic, strong)NSArray * userinfos;
@property (nonatomic, assign)BOOL islike;
@property (nonatomic, copy)NSString * coverimg;
@property (nonatomic, copy)NSString * coverimg_wh;
@property (nonatomic, copy)NSString * ting_contentid;
@property (nonatomic, strong)PKHomeModelPlayInfo * playInfo;
@property (nonatomic, strong)NSNumber * imgtotal;
@property (nonatomic, assign)PKCellFeedType  feedType;


@end
