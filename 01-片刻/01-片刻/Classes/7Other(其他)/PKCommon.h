//
//  PKCommon.h
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#ifndef _1____PKCommon_h
#define _1____PKCommon_h


//1,判断是否为 iOS7 iOS8
#define iOS7     ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8     ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
// 2.获得RGB颜色
#define PKColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//3,自定义 Log
#ifdef DEBUG
#define PKLog(...) NSLog(__VA_ARGS__)
#else
#define PKLog(...)
#endif

// 4,是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)


// 5,常用的对象
#define PKNotificationCenter [NSNotificationCenter defaultCenter]

#endif
