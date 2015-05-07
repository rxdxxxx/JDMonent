//
//  PKFMCellDetial.m
//  01-片刻
//
//  Created by qianfeng on 15-4-28.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKFMCellDetial.h"
#import "PKFMModelList.h"
#import "UIImageView+WebCache.h"
#import "PKHomeModelPlayInfo.h"



@interface PKFMCellDetial()
@property (weak, nonatomic) IBOutlet UIImageView *LeftImageView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;




@end

@implementation PKFMCellDetial

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
    static NSString *ID = @"PKFMCellDetial";
    PKFMCellDetial *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PKFMCellDetial" owner:nil options:nil] lastObject];
        
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

-(void)setModel:(PKFMModelList *)model
{
    _model = model;
    PKHomeModelPlayInfo * playInfo = model.playInfo;
    
    // 左侧图片
    [self.LeftImageView sd_setImageWithURL:[NSURL URLWithString:playInfo.imgUrl] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    
    // 中间的标题
    self.TitleLabel.text = playInfo.title;
    
    // 右侧图片
    [self.rightImageView setImage:[UIImage imageNamed:PKPlayMusicImage]];
    
    
    
    
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

@end
