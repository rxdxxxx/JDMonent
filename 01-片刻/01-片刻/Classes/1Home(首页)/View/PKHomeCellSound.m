//
//  PKHomeCellSound.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellSound.h"
#import "PKHomeModelRoot.h"
#import "PKMainModelUserInfo.h"

@interface PKHomeCellSound ()

@property (weak, nonatomic) IBOutlet UILabel *LabelTopType;
@property (weak, nonatomic) IBOutlet UIImageView *ThemeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UILabel *LabelTitle;

@property (weak, nonatomic) IBOutlet UILabel *Labeluname;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation PKHomeCellSound

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKHomeCellSound";
    PKHomeCellSound *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PKHomeCellSound" owner:nil options:nil] lastObject];
        
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
    
    // 1,设置cell的标题
    self.LabelTopType.text = [NSString stringWithFormat:@"%@ · %@",model.name,model.enname];

    
    // 2,设置主题图片
    [self.ThemeImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"pig_3"]];
    
    // 3,设置内容标题
    self.LabelTitle.text = model.title;
    
    // 4,设置作者
    PKMainModelUserInfo * userInfo = model.userinfo;
    self.Labeluname.text = [NSString stringWithFormat:@"by : %@",userInfo.uname];
    
    // 5,设置按钮
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",model.like.intValue] forState:UIControlStateNormal];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
