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

@interface PKHomeModelFeedRootFrame ()
{
    CGFloat cellW;
}

@end

@implementation PKHomeModelFeedRootFrame

-(void)setStatus:(PKHomeModelFeedRoot *)status
{
    _status = status;
    
    
    // 0.cell的宽度
    cellW = [UIScreen mainScreen].bounds.size.width - 2 * PKStatusTableBorder;
    
    
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
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelF) + PKStatusTableBorder * 0.5;
    CGSize timeLabelSize = [status.addtime_f sizeWithAttributes:@{NSFontAttributeName:PKStatusTimeFont}];
    CGFloat timeLabelX = cellW - timeLabelSize.width;

    _timeLabelF = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    //
    NSString *recommandStr = nil;
    if ([status.title isEqualToString:@"无题"]) {
        
        self.cellType = PKFeedCellTypeTimeLine; // 碎片
        
        recommandStr = @"碎片";
        
    }else{
        
        if (status.playInfo.title == nil) {
            recommandStr = @"文章";
            
            self.cellType = PKFeedCellTypeArticle; // 文章
        }else{
            
            recommandStr = @"Ting";
            self.cellType = PKFeedCellTypeTing;  // 音频
           
        }
    }
    
    // 5,推荐类别
    CGFloat recommandLabelX = nameLabelX;
    CGFloat recommandLabelY = CGRectGetMaxY(_nameLabelF) + PKStatusTableBorder * 0.5;
    CGSize recommandLabelSize = [recommandStr sizeWithAttributes:@{NSFontAttributeName:PKStatusTimeFont}];
    self.removmandString = recommandStr;
    _recommandLabelF = (CGRect){{recommandLabelX,recommandLabelY},recommandLabelSize};
    
    
    CGFloat cellMaxHeight = CGRectGetMaxY(_recommandLabelF);
    
    if (PKFeedCellTypeTing == self.cellType) {
        
        cellMaxHeight = [self setupTingView:CGRectGetMaxY(_recommandLabelF)];
        
    }else if(PKFeedCellTypeArticle == self.cellType){
        
#warning 暂且放置,去开发,阅读模块.
        
    }else if(PKFeedCellTypeTimeLine == self.cellType){
        
    }
    
    
    
    
    
    
    
    self.cellHeight = cellMaxHeight;

    
}
/**
 *  碎片的布局
 */
-(void)setupTimeLine
{
    
}

/**
 *  Ting的布局
 */
-(CGFloat)setupTingView:(CGFloat)maxY
{
    if (self.status.coverimg.length > 1) {
        
        CGFloat photoX = _iconViewF.origin.x + 40;
        CGFloat photoY = maxY+20;
        CGFloat photoW = 50;
        CGFloat photoH = 50;
        
//        CGFloat photoW = cellW - 2*_iconViewF.origin.x;
//        NSArray * stringWH = [self.status.coverimg_wh componentsSeparatedByString:@"*"];
//        CGFloat photoWSac = ((NSString *)stringWH[0]).floatValue / photoW;
//        CGFloat photoH = ((NSString *)stringWH[1]).floatValue / photoWSac;
        
        _photoViewF = (CGRect){{photoX,photoY},{photoW,photoH}};
        
        return CGRectGetMaxY(_photoViewF);
    }
    
    return maxY;
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
