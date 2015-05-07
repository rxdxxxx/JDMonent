//
//  PKHomeCellRightTimelineText.m
//  01-片刻
//
//  Created by qianfeng on 15-5-5.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellRightTimelineText.h"

#import "PKHomeModelFeedRoot.h"
#import "PKMainModelUserInfo.h"
#import "PKMainModelCounter.h"


@interface PKHomeCellRightTimelineText()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *conntentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commintBtn;


@end


@implementation PKHomeCellRightTimelineText


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKHomeCellRightTimelineText";
    PKHomeCellRightTimelineText *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PKHomeCellRightTimelineText" owner:nil options:nil] lastObject];
        
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
- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}



-(void)setRightModel:(PKHomeModelFeedRoot *)rightModel
{
    [super setRightModel:rightModel];
    
    
    PKMainModelUserInfo * userinfo = nil;
    NSString * recStr = nil;
    if (rightModel.userinfos.count > 0) {
        userinfo = rightModel.userinfos[0];
        recStr = [NSString stringWithFormat:@"等%lu人推荐一个碎片",(unsigned long)rightModel.userinfos.count];
    }else{
        userinfo = rightModel.userinfo;
        recStr = @"发布了一个碎片";
        
    }
    
    
    
    // 1,icon
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:userinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    _iconImg.layer.cornerRadius = 20;
    _iconImg.clipsToBounds = YES;
    
    // 2,用户名
    _unameLabel.text = userinfo.uname;
    
    // 3,推荐
    _recommendLabel.text = recStr;
    
    // 4,时间
    _timeLabel.text = rightModel.addtime_f;
    
    // 5,内容
    _conntentLabel.text=rightModel.content;
    
    // 6,评论按钮
    NSString * stringCommint = [NSString stringWithFormat:@"已评论%@次",rightModel.counterList.comment];
    [_commintBtn setTitle:stringCommint forState:UIControlStateNormal];
    
    // 7,喜欢
    NSString * likeCommint = [NSString stringWithFormat:@"被推荐%@次",rightModel.counterList.like];
    [_likeBtn setTitle:likeCommint forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
