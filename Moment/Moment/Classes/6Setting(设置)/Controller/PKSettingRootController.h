//
//  PKSettingRootController.h
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PKSettingGroup;

@interface PKSettingRootController : UITableViewController

@property (nonatomic, strong)NSMutableArray * groups;

-(PKSettingGroup *)addGroup;


@end
