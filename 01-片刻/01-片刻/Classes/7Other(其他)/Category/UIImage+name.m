//
//  UIImage+name.m
//  MJWeiBo
//
//  Created by qianfeng on 15-4-8.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "UIImage+name.h"

@implementation UIImage(name)

+(UIImage *)imageWithName:(NSString *)name
{
    if (iOS7) {
        NSString * newName = [name stringByAppendingString:@"_os7"];
        UIImage * image = [UIImage imageNamed:newName];
        if (image == nil) {//没有对应的图片
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    
    //非 ios7以上
    return [UIImage imageNamed:name];
}

+(UIImage *)resizedImageWithName:(NSString *)name
{
    UIImage * image = [self imageWithName:name];

    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5] ;
}
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

@end
