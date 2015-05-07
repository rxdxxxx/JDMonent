//
//  PKAccount.m
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKAccount.h"

@implementation PKAccount

+(instancetype)accountWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

/**
 *  从文件中解析对象的时候调用
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.auth = [coder decodeObjectForKey:@"auth"];
        self.uid = [coder decodeInt64ForKey:@"uid"];
        self.uname = [coder decodeObjectForKey:@"uname"];
        self.icon = [coder decodeObjectForKey:@"icon"];
        self.coverimg = [coder decodeObjectForKey:@"coverimg"];
        self.msg = [coder decodeObjectForKey:@"msg"];
    }
    return self;
}
/**
 *  将对象写入文件的时候调用
 */
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.auth forKey:@"auth"];
    [aCoder encodeInt64:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.uname forKey:@"uname"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.coverimg forKey:@"coverimg"];
    [aCoder encodeObject:self.msg forKey:@"msg"];
}


@end
