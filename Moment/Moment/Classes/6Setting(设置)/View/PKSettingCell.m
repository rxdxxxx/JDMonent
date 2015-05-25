//
//  PKSettingCell.m
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKSettingCell.h"
#import "PKSettingItem.h"
#import "PKSettingArrowItem.h"
#import "PKSettingSwitchItem.h"
#import "PKSettingLabelItem.h"

@interface PKSettingCell ()
/**
 *  箭头
 */
@property (nonatomic, strong)UIImageView * arrowView;
/**
 *  开关
 */
@property (nonatomic, strong)UISwitch * switchView;
//@property (nonatomic, strong)PKBadgeButton * badgeButton;
@property (nonatomic, weak)UITableView * tableView;
@property (nonatomic, weak)UIImageView * bgView;
@property (nonatomic, weak)UIImageView * selectedBgView;
@end

@implementation PKSettingCell

-(UISwitch *)switchView{
    if (_switchView  == nil) {
        _switchView = [[UISwitch alloc]init];
    }
    return _switchView;
}

-(UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
    }
    return _arrowView;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"setting";
    PKSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PKSettingCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.tableView = tableView;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 标题
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        // 创建背景
        UIImageView * bgView = [[UIImageView alloc]init];
        self.backgroundView = bgView;
        self.bgView = bgView;
        
        UIImageView * selectedBgView = [[UIImageView alloc]init];
        self.selectedBackgroundView = selectedBgView;
        self.selectedBgView = selectedBgView;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
//    if (iOS7) {
//        frame.origin.x = 5;
//        frame.size.width -= 10;
//    }
    [super setFrame:frame];
}

-(void)setItem:(PKSettingItem *)item
{
    _item = item;
    
    // 1,设置数据
    [self setupData];
    
    // 2,设置右边的控件
    [self setupRightView];
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    int totalRows = [self.tableView numberOfRowsInSection:indexPath.section];
    
    NSString * bgName = nil;
    NSString * selectedBgName = nil;
    if (totalRows == 1) { // 这组就1行
        bgName = @"common_card_background";
        selectedBgName = @"common_card_background_highlighted";
    } else if (indexPath.row == 0) { // 首行
        bgName = @"common_card_top_background";
        selectedBgName = @"common_card_top_background_highlighted";
    } else if (indexPath.row == totalRows - 1) { // 尾行
        bgName = @"common_card_bottom_background";
        selectedBgName = @"common_card_bottom_background_highlighted";
    } else { // 中行
        bgName = @"common_card_middle_background";
        selectedBgName = @"common_card_middle_background_highlighted";
    }
    self.bgView.image = [UIImage resizedImageWithName:bgName];
    self.selectedBgView.image = [UIImage resizedImageWithName:selectedBgName];
}

/**
 // 1,设置数据
 */
-(void)setupData
{
    // 1.图标
    if (self.item.icon) {
        self.imageView.image = [UIImage imageWithName:self.item.icon];
    }
    
    // 2.标题
    self.textLabel.text = self.item.title;
}
/**
 // 2,设置右边的控件
 */
-(void)setupRightView
{
//    if (self.item.badgeValue) {
//        self.badgeButton.badgeValue = self.item.badgeValue;
//        self.accessoryView = self.badgeButton;
//    } else
    
    if ([self.item isKindOfClass:[PKSettingSwitchItem class]])
    { // 右边是开关
        self.accessoryView = self.switchView;
    }
    else if ([self.item isKindOfClass:[PKSettingArrowItem class]])
    { // 右边是箭头
        self.accessoryView = self.arrowView;
    }
    else { // 右边没有东西
        self.accessoryView = nil;
    }

}


















@end
