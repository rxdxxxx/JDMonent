//
//  PKHomeCellMor.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellMor.h"
#import "PKHomeModelRoot.h"


@interface PKHomeCellMor()
@property (weak, nonatomic) IBOutlet UILabel *LabelTopType;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewCoverImage;

@property (weak, nonatomic) IBOutlet UILabel *LabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *LabelContent;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;


@end

@implementation PKHomeCellMor
#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKHomeCellMor";
    PKHomeCellMor *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PKHomeCellMor" owner:nil options:nil] lastObject];
        
        /**  nib注册方式写法.
        UINib * nib = [UINib nibWithNibName:@"PKHomeCellMor" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:ID];
        NSArray * objs = [nib instantiateWithOwner:self options:nil];
        cell = [objs lastObject];
        */
        
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
    [self.ImageViewCoverImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    
    // 3,设置内容标题
    self.LabelTitle.text = model.title;
    
    // 4,设置内容
    self.LabelContent.text = model.content;
//    self.LabelTitle.numberOfLines = 0;

    // 5,设置按钮
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d",model.like.intValue] forState:UIControlStateNormal];
    self.likeBtn.hidden = YES;

}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
