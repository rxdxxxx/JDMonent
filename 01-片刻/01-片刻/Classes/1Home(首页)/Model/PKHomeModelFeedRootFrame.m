//
//  PKHomeModelFeedRootFrame.m
//  01-片刻
//
//  Created by qianfeng on 15-5-1.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeModelFeedRootFrame.h"
#import "PKHomeModelFeedRoot.h"
#import "PKHomeModelPlayInfo.h"
#import "PKMainModelUserInfo.h"

@implementation PKHomeModelFeedRootFrame

-(void)setStatus:(PKHomeModelFeedRoot *)status
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
    
    // 4,根据用户信息,判断不同的头像名称
    NSString * unameStr = nil;
    if (status.userinfos.count>0) {
        PKMainModelUserInfo * ui = status.userinfos[0];
        unameStr = ui.uname;
    }else{
        unameStr = status.userinfo.uname;
    }
    
    CGSize nameLabelSize = [unameStr sizeWithAttributes:@{NSFontAttributeName:PKStatusNameFont}];
    _nameLabelF = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    // 4.时间
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelF) + PKStatusTableBorder * 0.5;
    CGSize timeLabelSize = [status.addtime_f sizeWithAttributes:@{NSFontAttributeName:PKStatusTimeFont}];
    _timeLabelF = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};

    
    
    self.cellHeight = CGRectGetMaxY(_timeLabelF);
    
    if ([status.title isEqualToString:@"无题"]) {
        self.cellType = PKFeedCellTypeTimeLine; // 碎片
        [self setupTimeLine];
    }else{
        if (status.playInfo.title == nil) {
            self.cellType = PKFeedCellTypeArticle; // 文章
        }else{
            self.cellType = PKFeedCellTypeTing;  // 音频
        }
    }
    
}
/**
 *  碎片的布局
 */
-(void)setupTimeLine
{
    
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
