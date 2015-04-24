//
//  PKHomeCellMusic.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellMusic.h"
@interface PKHomeCellMusic()
@property (weak, nonatomic) IBOutlet UILabel *LabelTopType;
@property (weak, nonatomic) IBOutlet UILabel *LabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *LabelSinger;
@property (weak, nonatomic) IBOutlet UILabel *LabelContent;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@end

@implementation PKHomeCellMusic

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
