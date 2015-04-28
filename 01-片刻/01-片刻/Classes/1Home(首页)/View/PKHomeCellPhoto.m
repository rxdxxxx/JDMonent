//
//  PKHomeCellPhoto.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellPhoto.h"
#import "PKHomeModelRoot.h"
#import "PKHomeModelImgUrl.h"


@interface PKHomeCellPhoto()
@property (weak, nonatomic) IBOutlet UILabel *LabelTopType;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeft;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewRight;
@property (weak, nonatomic) IBOutlet UILabel *LabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;


@end

@implementation PKHomeCellPhoto
#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PKHomeCellPhoto";
    PKHomeCellPhoto *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PKHomeCellPhoto" owner:nil options:nil] lastObject];
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
    
    // 2,设置图片
    NSArray * imageArray = model.imglist;
    PKHomeModelImgUrl * imageModel = nil;
    NSArray * tempArr = @[self.imageViewTop,self.imageViewLeft,self.imageViewRight];
    // 2.1 上
    
    for (int i = 0; i<3; i++) {
        
        imageModel = imageArray[i];
        if (imageModel==nil) {
            break;
        }
        [tempArr[i] sd_setImageWithURL:[NSURL URLWithString:imageModel.imgurl] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
        ((UIImageView *)tempArr[i]).contentMode = UIViewContentModeScaleAspectFill;
        ((UIImageView *)tempArr[i]).layer.masksToBounds = YES;
    }
    
    // 3,设置内容标题
    self.LabelTitle.text = model.title;
    
    
    // 4,设置内容
    self.labelContent.text = model.content;

    // 5,设置按钮
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d",model.like.intValue] forState:UIControlStateNormal];
    self.likeBtn.hidden = YES;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
