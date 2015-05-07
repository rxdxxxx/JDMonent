//
//  PKMainCellComment.h
//  01-片刻
//
//  Created by qianfeng on 15-5-3.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKMainModelCommentGetFrame;

@interface PKMainCellComment : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)PKMainModelCommentGetFrame * statuesFrame;

@end
