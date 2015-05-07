//
//  PKReadModelDetialWebview.m
//  01-片刻
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKReadModelDetialWebview.h"
#import "MJExtension.h"
#import "PKMainModelCommentGet.h"

@implementation PKReadModelDetialWebview
-(NSDictionary *)objectClassInArray
{
    return @{@"commentlist":[PKMainModelCommentGet class]};
}
@end
