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
        CGFloat photoWSac = ((NSString *)stringWH[0]).floatValue / 300.0f;
        CGFloat photoH = ((NSString *)stringWH[1]).floatValue / photoWSac;
        CGSize photosViewSize = CGSizeMake(300, photoH);
        CGFloat photoViewX = iconViewX;
        CGFloat photoViewY = CGRectGetMaxY(_iconViewF) + PKStatusTableBorder * 0.5;
        _photoViewF = CGRectMake(photoViewX, photoViewY, photosViewSize.width, photosViewSize.height);
    }
    
    // 6.正文内容
    CGFloat contentLabelX = iconViewX;
    CGFloat contentLabelY = 0;
    if (status.coverimg.length > 1) {
        contentLabelY = CGRectGetMaxY(_photoViewF) + PKStatusTableBorder * 0.5;
    }else{
        contentLabelY = CGRectGetMaxY(_timeLabelF) + PKStatusTableBorder * 0.5;
    }
    CGFloat contentLabelMaxW = topViewW - 4 * PKStatusTableBorder;
    CGSize contentLabelSize = [self sizeWithText:status.content font:PKStatusContentFont maxSize:CGSizeMake(contentLabelMaxW, MAXFLOAT)];
    _contentLabelF = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    
    
    // 7.cell的高度
    _cellHeight = CGRectGetMaxY(_contentLabelF) + 3 * PKStatusTableBorder;
    
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
