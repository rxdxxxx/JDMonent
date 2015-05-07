//
//  PKHomeCellRoot.m
//  01-片刻
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellRoot.h"

@implementation PKHomeCellRoot


#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKHomeCellRoot";
    PKHomeCellRoot *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PKHomeCellRoot alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

//
//        // 2.添加微博的工具条
//        [self setupStatusToolbar];
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
}

-(void)setModel:(PKHomeModelRoot *)model
{
    _model = model;
    
    // 1.设置选中时的颜色.
    [self setupView];
}

/**
 *
 */
-(void)setupView
{
    // 0.设置cell选中时的背景
    self.selectedBackgroundView = [[UIView alloc]init];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

@end
