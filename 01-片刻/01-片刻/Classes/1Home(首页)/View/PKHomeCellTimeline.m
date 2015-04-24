//
//  PKHomeCellTimeline.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellTimeline.h"
#import "PKHomeModelRoot.h"


@interface PKHomeCellTimeline()
@property (weak, nonatomic) IBOutlet UILabel *LabelTopType;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewCoverImage;
@property (weak, nonatomic) IBOutlet UILabel *LabelContent;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;



@end

@implementation PKHomeCellTimeline
#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKHomeCellTimeline";
    PKHomeCellTimeline *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PKHomeCellTimeline" owner:nil options:nil] lastObject];
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
    [self.ImageViewCoverImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"pig_3"]];
    
    // 3,设置内容
    self.LabelContent.text = model.content;

    // 4,设置按钮
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d",model.like.intValue] forState:UIControlStateNormal];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
