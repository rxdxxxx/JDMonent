//
//  PKSettingCell.h
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKSettingItem;

@interface PKSettingCell : UITableViewCell

@property (nonatomic, strong)PKSettingItem * item;
@property (nonatomic, strong)NSIndexPath * indexPath;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
