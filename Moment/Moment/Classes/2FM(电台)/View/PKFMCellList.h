//
//  PKFMCellList.h
//  01-片刻
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PKFMModelDetial;

@interface PKFMCellList : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)PKFMModelDetial * model;

@end
