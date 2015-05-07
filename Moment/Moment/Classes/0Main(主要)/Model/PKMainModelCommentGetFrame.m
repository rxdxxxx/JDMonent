//
//  PKMainModelCommentGetFrame.m
//  01-片刻
//
//  Created by qianfeng on 15-5-3.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKMainModelCommentGetFrame.h"
#import "PKMainModelCommentGet.h"
#import "PKMainModelUserInfo.h"

@implementation PKMainModelCommentGetFrame
-(void)setStatus:(PKMainModelCommentGet *)status
{
    _status = status;
    
    // 0.cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - 2 * PKStatusTableBorder;
    
    
    // 1.topView
    CGFloat topViewW = cellW;
    
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
    

    
    // 6.正文内容
    CGFloat contentLabelX = iconViewX + 4 * PKStatusTableBorder ;
    CGFloat contentLabelY = 0;
    contentLabelY = CGRectGetMaxY(_timeLabelF) + PKStatusTableBorder ;
    CGFloat contentLabelMaxW = topViewW - 8 * PKStatusTableBorder;

    if (status.reuserinfo.uname != nil) {
        NSMutableString * addString = [NSMutableString stringWithFormat:@"回复 %@ : %@ ",status.reuserinfo.uname,status.content];
        status.content = addString;
    }
    
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
