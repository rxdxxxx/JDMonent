//
//  PKSettingGroup.h
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKSettingGroup : NSObject
@property (nonatomic, copy)NSString * header;
@property (nonatomic, copy)NSString * footer;
@property (nonatomic, strong)NSArray * items;

+(instancetype)group;
@end
