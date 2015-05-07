//
//  UIBarButtonItem(JD).m
//  MJWeiBo
//
//  Created by qianfeng on 15-4-11.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "UIBarButtonItem+JD.h"

@implementation UIBarButtonItem(JD)
+(UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithName:highIcon]  forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero,button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button]; 
}
@end
