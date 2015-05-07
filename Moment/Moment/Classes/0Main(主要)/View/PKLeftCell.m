//
//  PKLeftCell.m
//  01-片刻
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKLeftCell.h"


@implementation PKLeftCell
#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //1,创建 cell
    static NSString * ID = @"cell";
    PKLeftCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PKLeftCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}
/**
 *  拦截frame的设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 2*PKStatusTableBorder;
    
    frame.size.height -= 2*PKStatusTableBorder;
    
    [super setFrame:frame];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
