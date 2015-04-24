//
//  PKHomeModelRoot.m
//  01-片刻
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeModelRoot.h"
#import "MJExtension.h"
#import "PKHomeModelPlayInfo.h"
#import "PKHomeModelImgUrl.h"

@implementation PKHomeModelRoot

-(NSDictionary *)objectClassInArray
{
    return @{@"playList":[PKHomeModelPlayInfo class],@"imglist":[PKHomeModelImgUrl class]};
}


@end
