//
//  UIBarButtonItem(JD).h
//  MJWeiBo
//
//  Created by qianfeng on 15-4-11.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JD)
/**
 *  快速创建一个用来显示图片的 UIBaritem
 *  @param action   监听方法
 */
+(UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

@end
