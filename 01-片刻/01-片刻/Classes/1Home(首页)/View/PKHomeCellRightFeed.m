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
/** 时间 */
@property (nonatomic, weak) UILabel *recommandLabel;
/** 配图 */
@property (nonatomic, weak) UIImageView *photoView;

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
        
        
        /** 3.昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = PKStatusNameFont;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 4.时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = PKStatusTimeFont;
        timeLabel.textColor = PKColor(240, 140, 19);
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //  5,类型文字
        UILabel *recommandLabel = [[UILabel alloc]init];
        recommandLabel.font = PKStatusTimeFont;
        recommandLabel.textColor = PKColor(240, 140, 19);
        recommandLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:recommandLabel];
        self.recommandLabel = recommandLabel;
        
        // 6,配图
        UIImageView * photoView = [[UIImageView alloc]init];
        photoView.clipsToBounds = YES;
        [self addSubview:photoView];
        self.photoView = photoView;
        
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
    
    
    // 4.时间
    self.timeLabel.text = statues.addtime_f;
    self.timeLabel.frame = statuesFrame.timeLabelF;
    
    // 5.推荐的文字
    self.recommandLabel.text = statuesFrame.removmandString;
    self.recommandLabel.frame = statuesFrame.recommandLabelF;
    
    // 6,配图
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:statues.coverimg] placeholderImage:[UIImage imageWithName:PKPlaceholderImage]];
    self.photoView.frame = self.statuesFrame.photoViewF;
}

@end
