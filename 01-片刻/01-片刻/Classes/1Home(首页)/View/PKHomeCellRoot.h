//
//  PKHomeCellRoot.h
//  01-片刻
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class PKHomeModelRoot;

@interface PKHomeCellRoot : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)PKHomeModelRoot * model;

@end
