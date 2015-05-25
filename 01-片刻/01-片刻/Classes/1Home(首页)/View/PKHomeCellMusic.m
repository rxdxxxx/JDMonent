//
//  PKHomeCellMusic.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellMusic.h"
#import "PKHomeModelRoot.h"


@interface PKHomeCellMusic()


@end

@implementation PKHomeCellMusic
#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKHomeCellMusic";
    PKHomeCellMusic *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PKHomeCellMusic" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        // 1.添加顶部的view
        //        [self setupTopView];
        //
        //        // 2.添加微博的工具条
        //        [self setupStatusToolbar];
    }
    return self;
}

-(void)setModel:(PKHomeModelRoot *)model
{
    [super setModel:model];
      
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
