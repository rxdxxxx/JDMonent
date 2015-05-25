//
//  PKReadCellDetial.h
//  01-片刻
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PKReadModelDetialHot;

@interface PKReadCellDetial : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)PKReadModelDetialHot * model;


@end
