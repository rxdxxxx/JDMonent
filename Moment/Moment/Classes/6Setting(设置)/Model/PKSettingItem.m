//
//  PKSettingItem.m
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKSettingItem.h"

@implementation PKSettingItem

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    PKSettingItem * item = [self item];
    item.icon = icon;
    item.title = title;
    return item;
}

+(instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title];
}

+(instancetype)item
{
    return [[self alloc]init];
}

@end
