//
//  PKMainCellComment.m
//  01-片刻
//
//  Created by qianfeng on 15-5-3.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKMainCellComment.h"
#import "PKMainModelCommentGetFrame.h"
#import "PKMainModelCommentGet.h"

#import "PKMainModelUserInfo.h"
#import "UIImageView+WebCache.h"

@interface PKMainCellComment ()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 正文\内容 */
@property (nonatomic, weak) UILabel *contentLabel;
@end

@implementation PKMainCellComment

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKMainCellComment";
    PKMainCellComment *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PKMainCellComment alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 1,设置背景图片
        self.userInteractionEnabled = YES;
        
        self.selectedBackgroundView = [[UIView alloc]init];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        
        
        /** 2.头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.layer.cornerRadius = 35;
        iconView.clipsToBounds = YES;
        [self addSubview:iconView];
        self.iconView = iconView;
        
        
        
        /** 5.昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = PKStatusNameFont;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 6.时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = PKStatusTimeFont;
        timeLabel.textColor = PKColor(240, 140, 19);
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        
        /** 8.正文\内容 */
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = PKColor(39, 39, 39);
        contentLabel.font = PKStatusContentFont;
        contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
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

-(void)layoutSubviews
{
    UIImageView * imV = [[UIImageView alloc]initWithFrame:self.bounds];
    [imV setImage:[UIImage resizedImageWithName:@"timeline_card_bottom_background"]];
    self.backgroundView = imV;
    
    
}

-(void)setStatuesFrame:(PKMainModelCommentGetFrame *)statuesFrame
{
    _statuesFrame = statuesFrame;
    
    PKMainModelCommentGet * statues = statuesFrame.status;
    PKMainModelUserInfo * user= statues.userinfo;
    
    // 2.头像
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.icon] placeholderImage:[UIImage imageWithName:PKPlaceholderImage]];
    self.iconView.frame = self.statuesFrame.iconViewF;
    
    // 3.昵称
    self.nameLabel.text = user.uname;
    self.nameLabel.frame = self.statuesFrame.nameLabelF;
    
    
    // 5.时间
    self.timeLabel.text = statues.addtime_f;
    CGFloat timeLabelX = self.statuesFrame.nameLabelF.origin.x;
    CGFloat timeLabelY = CGRectGetMaxY(self.statuesFrame.nameLabelF) + PKStatusTableBorder * 0.5;
    CGSize timeLabelSize = [statues.addtime_f sizeWithAttributes:@{NSFontAttributeName:PKStatusTimeFont}];
    self.timeLabel.frame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    //    IWLog(@"text:%@  frame: %@",status.created_at,NSStringFromCGRect(self.timeLabel.frame));
    
    
    
    
    // 7.正文
    self.contentLabel.text = statues.content;
    self.contentLabel.frame = self.statuesFrame.contentLabelF;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
