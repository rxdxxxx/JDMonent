//
//  UIImage+name.h
//  MJWeiBo
//
//  Created by qianfeng on 15-4-8.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UIImage (name)
/**
 *  加载图片
 *
 *  @param name 图片名
 */
+(UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 */
+(UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
