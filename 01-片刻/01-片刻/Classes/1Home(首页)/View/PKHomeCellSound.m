//
//  PKHomeCellSound.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellSound.h"

@interface PKHomeCellSound ()

@property (weak, nonatomic) IBOutlet UILabel *LabelTopType;
@property (weak, nonatomic) IBOutlet UIImageView *ThemeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UILabel *LabelTitle;

@property (weak, nonatomic) IBOutlet UILabel *Labeluname;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation PKHomeCellSound

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
