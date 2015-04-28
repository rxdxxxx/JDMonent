//
//  PKFMCellDetial.h
//  01-片刻
//
//  Created by qianfeng on 15-4-28.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKFMModelList;

@interface PKFMCellDetial : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)PKFMModelList * model;

@end
