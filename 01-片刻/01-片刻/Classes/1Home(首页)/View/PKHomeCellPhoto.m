//
//  PKHomeCellPhoto.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeCellPhoto.h"
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
