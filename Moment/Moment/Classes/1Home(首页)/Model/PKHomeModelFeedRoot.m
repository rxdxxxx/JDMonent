//
//  PKHomeModelFeedRoot.m
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeModelFeedRoot.h"
#import "MJExtension.h"
#import "PKMainModelUserInfo.h"

@implementation PKHomeModelFeedRoot

-(NSDictionary *)objectClassInArray
{
    return @{@"userinfos":[PKMainModelUserInfo class]};
}


@end
