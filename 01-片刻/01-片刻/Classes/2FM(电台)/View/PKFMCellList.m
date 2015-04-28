//
//  PKFMCellList.m
//  01-片刻
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKFMCellList.h"
#import "PKFMModelDetial.h"
#import "UIImageView+WebCache.h"
#import "PKMainModelUserInfo.h"



@interface PKFMCellList ()
@property (weak, nonatomic) IBOutlet UIImageView *CellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;

@end

@implementation PKFMCellList

- (void)awakeFromNib {
    // Initialization code
    
    self.selectedBackgroundView = [[UIView alloc]init];
    self.backgroundColor = [UIColor clearColor];
    
}

-(void)layoutSubviews
{
    UIImageView * imV = [[UIImageView alloc]initWithFrame:self.bounds];
    [imV setImage:[UIImage resizedImageWithName:@"timeline_card_bottom_background"]];
    self.backgroundView = imV;
}

#pragma mark - 初始化

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKFMCellList";
    PKFMCellList *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PKFMCellList" owner:nil options:nil] lastObject];
        
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

-(void)setModel:(PKFMModelDetial *)model
{
    _model = model;
    
    // 1,设置cell的标题
    self.titleLabel.text = [NSString stringWithFormat:@" · %@",model.title];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.50f];
    
    // 2,设置主题图片
    [self.CellImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    self.CellImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.CellImageView.clipsToBounds = YES;

    // 3,设置作者名称
    PKMainModelUserInfo * userInfo = model.userinfo;
    self.unameLabel.text = [NSString stringWithFormat:@"by : %@",userInfo.uname];
    self.unameLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.50f];

    
    
}

/**
 *  拦截frame的设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += PKStatusTableBorder;
    frame.origin.x = PKStatusTableBorder;
    frame.size.width -= 2 * PKStatusTableBorder;
    frame.size.height -= PKStatusTableBorder;
    
    [super setFrame:frame];
    
//    self.CellImageView.frame = self.frame;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
