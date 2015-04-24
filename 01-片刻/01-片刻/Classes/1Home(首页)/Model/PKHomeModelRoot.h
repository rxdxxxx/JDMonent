//
//  PKHomeModelRoot.h
//  01-片刻
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKMainModelUserInfo;
@class PKHomeModelPlayInfo;



@interface PKHomeModelRoot : NSObject
/**
 *  图片路径
 */
@property (nonatomic, copy)NSString * coverimg;
/**
 *  热度
 */
@property (nonatomic, strong)NSNumber * hot;
/**
 *  消息id
 */
@property (nonatomic, copy)NSString * id;
/**
 *
 */
@property (nonatomic, strong)NSNumber * issend;
/**
 *  类型
 */
@property (nonatomic, strong)NSNumber * type;
/**
 *  日期
 */
@property (nonatomic, copy)NSString * date;
/**
 *  模块名称(中文)
 */
@property (nonatomic, copy)NSString * name;
/**
 *  模块名称(英文)
 */
@property (nonatomic, copy)NSString * enname;
/**
 *  标题
 */
@property (nonatomic, copy)NSString * title;
/**
 *  文字描述内容
 */
@property (nonatomic, copy)NSString * content;
/**
 *  查看数
 */
@property (nonatomic, strong)NSNumber * view;
/**
 *  点赞数
 */
@property (nonatomic, strong)NSNumber * like;
/**
 *  用户信息
 */
@property (nonatomic, strong)PKMainModelUserInfo * userinfo;
/**
 *  音频播放的具体信息
 */
@property (nonatomic, strong)PKHomeModelPlayInfo * playinfo;
/**
 *  音频的播放列表, 其中每一个模型是: PKHomeModelPlayInfo
 */
@property (nonatomic, strong)NSArray * playList;


/*_+*_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_*/

/**
 *  timeline和photo,aillustartion(插画)返回的宽高
 */
@property (nonatomic, copy)NSString * coverimg_wh;
/**
 *  photo,illustration的宽
 */
@property (nonatomic, strong)NSNumber * imgwidth;
/**
 *  photo,illustration的高
 */
@property (nonatomic, strong)NSNumber * imgheight;
/**
 *  储存图片链接的数组
 */
@property (nonatomic, strong)NSArray * imglist;
/**
 *  图片的数量
 */
@property (nonatomic, strong)NSNumber * imgtotal;








@end
