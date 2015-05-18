//
//  PKSettingArrowItem.m
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKSettingArrowItem.h"

@implementation PKSettingArrowItem

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    PKSettingArrowItem * item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}

+(instancetype)itemwithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemwithTitle:title destVcClass:destVcClass];
}

@end
