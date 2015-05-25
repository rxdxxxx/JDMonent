//
//  PKSettingArrowItem.h
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKSettingItem.h"

@interface PKSettingArrowItem : PKSettingItem

/**  跳转的目标控制器*/
@property (nonatomic, assign)Class destVcClass;

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+(instancetype)itemwithTitle:(NSString *)title destVcClass:(Class)destVcClass;



@end
