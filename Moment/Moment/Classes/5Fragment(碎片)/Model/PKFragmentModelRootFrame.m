//
//  PKFragmentModelRootFrame.m
//  01-片刻
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKFragmentModelRootFrame.h"
#import "PKFragmentModelRoot.h"
#import "PKMainModelUserInfo.h"

@implementation PKFragmentModelRootFrame


-(void)setStatus:(PKFragmentModelRoot *)status
{
    _status = status;
    
    // 0.cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - 2 * PKStatusTableBorder;
    
    
    // 1.topView
    CGFloat topViewW = cellW;
    CGFloat topViewH = 0;
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    
    // 2.头像
    CGFloat iconViewWH = 35;
    CGFloat iconViewX = PKStatusTableBorder;
    CGFloat iconViewY = PKStatusTableBorder;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    
    // 3.昵称
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + PKStatusTableBorder;
    CGFloat nameLabelY = iconViewY;
    CGSize nameLabelSize = [status.userinfo.uname sizeWithAttributes:@{NSFontAttributeName:PKStatusNameFont}];
    _nameLabelF = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    // 4.时间
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelF) + PKStatusTableBorder * 0.5;
    CGSize timeLabelSize = [status.addtime_f sizeWithAttributes:@{NSFontAttributeName:PKStatusTimeFont}];
    _timeLabelF = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    // 5.配图
    if (status.coverimg.length > 1) {
        NSArray * stringWH = [status.coverimg_wh componentsSeparatedByString:@"*"];
        CGFloat photoWSac = ((NSString *)stringWH[0]).floatValue / 280.f;
        CGFloat photoH = ((NSString *)stringWH[1]).floatValue / photoWSac;
        CGSize photosViewSize = CGSizeMake(280, photoH);
        CGFloat photoViewX = iconViewX+10;
        CGFloat photoViewY = CGRectGetMaxY(_iconViewF) + PKStatusTableBorder * 0.5;
        _photoViewF = CGRectMake(photoViewX, photoViewY, photosViewSize.width, photosViewSize.height);
    }
    
    // 6.正文内容
    CGFloat contentLabelX = iconViewX + 4 * PKStatusTableBorder ;
    CGFloat contentLabelY = 0;
    if (status.coverimg.length > 1) {
        contentLabelY = CGRectGetMaxY(_photoViewF) + PKStatusTableBorder ;
    }else{
        contentLabelY = CGRectGetMaxY(_timeLabelF) + PKStatusTableBorder ;
    }
    CGFloat contentLabelMaxW = topViewW - 8 * PKStatusTableBorder;
    CGSize contentLabelSize = [self sizeWithText:status.content font:PKStatusContentFont maxSize:CGSizeMake(contentLabelMaxW, MAXFLOAT)];
    _contentLabelF = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    
    
    // 7 commintBtn
    CGFloat commintBtnW = 80;
    CGFloat commintBtnH = 30;
    CGFloat commintBtnX = CGRectGetMinX(_contentLabelF);
    CGFloat commintBtnY = CGRectGetMaxY(_contentLabelF) + 3 * PKStatusTableBorder;
    _commintBtnF = (CGRect){{commintBtnX,commintBtnY},{commintBtnW,commintBtnH}};

    // 8 likeBtn
    CGFloat likeBtnW = 80;
    CGFloat likeBtnH = 30;
    CGFloat likeBtnX = CGRectGetMaxX(_commintBtnF) + 3*PKStatusTableBorder;
    CGFloat likeBtnY = commintBtnY;
    _likeBtnF = (CGRect){{likeBtnX,likeBtnY},{likeBtnW,likeBtnH}};
    
    // 9.cell的高度
    _cellHeight = CGRectGetMaxY(_likeBtnF) + 3 * PKStatusTableBorder;
    
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
