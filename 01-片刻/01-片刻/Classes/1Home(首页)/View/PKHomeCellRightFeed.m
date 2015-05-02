//
//  PKHomeCellRightFeed.m
//  01-片刻
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellRightFeed.h"
#import "PKHomeModelFeedRoot.h"
#import "PKHomeModelFeedRootFrame.h"
#import "PKMainModelUserInfo.h"
#import "UIImageView+WebCache.h"

@interface PKHomeCellRightFeed()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
@end

@implementation PKHomeCellRightFeed

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKHomeCellRightFeed";
    PKHomeCellRightFeed *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PKHomeCellRightFeed alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        
    }
    return self;
}

-(void)setStatuesFrame:(PKHomeModelFeedRootFrame *)statuesFrame
{
    _statuesFrame = statuesFrame;
    
    PKHomeModelFeedRoot * statues = statuesFrame.status;
    PKMainModelUserInfo * user= nil;
    
    // 4,根据用户信息,判断不同的头像名称
    NSString * unameStr = nil;
    if (statues.userinfos.count>0) {
        user = statues.userinfos[0];
        unameStr = user.uname;
    }else{
        user = statues.userinfo;
        unameStr = user.uname;
    }
    
    
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
}

@end
