//
//  PKHomeCellRightFeed.h
//  01-片刻
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PKHomeModelFeedRootFrame;

@interface PKHomeCellRightFeed : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)PKHomeModelFeedRootFrame * statuesFrame;


@end
