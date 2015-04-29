//
//  PKReadViewController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKReadViewController.h"
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "SlideNavigationController.h"

#import "UIButton+WebCache.h"
#import "PKReadModelRoot.h"
#import "PKReadViewDetialController.h"



@interface PKReadViewController ()

@property (nonatomic, weak)UIView * optionView;

@property (nonatomic, strong)NSMutableArray * readItemArray;


@end

@implementation PKReadViewController

static PKReadViewController *ReadsingletonInstance = nil;

#pragma mark - Initialization -

+ (PKReadViewController *)sharedInstance
{
    if (!ReadsingletonInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ReadsingletonInstance = [[self alloc]init];
        });
    }
    
    return ReadsingletonInstance;
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.56f green:0.88f blue:0.63f alpha:1.00f];
    // 1,发起网络请求
    [self setupRequest];
    
    // 2,创建九宫格
    [self setupNineBlock];
    
    
}

/**
 *  发起网络请求
 */
-(void)setupRequest
{
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"client"] = @"2";
    
    NSString * url = @"http://api2.pianke.me/read/columns";
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.readItemArray = (NSMutableArray *)[PKReadModelRoot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        [self addOptionBtn:self.readItemArray];
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    
    
}



/**
 *  1,创建九宫格
 */
-(void)setupNineBlock
{
    [self addOptionBtn:self.readItemArray];
}

-(UIView *)optionView
{
    if (_optionView == nil) {
        UIView * optionView= [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:optionView];
        _optionView = optionView;
    }
    return _optionView;
}
/**
 *  添加待选项
 */
- (void)addOptionBtn:(NSMutableArray *)readArray
{
    // 6.1.删掉之前的所有按钮
    for (UIView *subview in self.optionView.subviews) {
        [subview removeFromSuperview];
    }
    
    // 6.2.添加新的待选按钮
    int count = (int)readArray.count;
    for (int i = 0; i<count; i++) {
        // 6.2.1.创建按钮
        UIButton *optionBtn = [[UIButton alloc] init];
        optionBtn.tag = i;
        
        // 6.2.2.设置背景
        PKReadModelRoot * model = readArray[i];
        
        [optionBtn sd_setImageWithURL:[NSURL URLWithString:model.coverimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
        
        // 6.2.3.设置frame
        // 按钮尺寸
        CGFloat optionW = 90;
        CGFloat optionH = 90;
        // 按钮之间的间距
        CGFloat margin = 10;
        // 控制器view的宽度
        CGFloat viewW = self.view.frame.size.width;
        // 总列数
        int totalColumns = 3;
        // 最左边的间距 = 0.5 * (控制器view的宽度 - 总列数 * 按钮宽度 - (总列数 - 1) * 按钮之间的间距)
        CGFloat leftMargin = (viewW - totalColumns * optionW - margin * (totalColumns - 1)) * 0.5;
        int col = i % totalColumns;
        // 按钮的x = 最左边的间距 + 列号 * (按钮宽度 + 按钮之间的间距)
        CGFloat optionX = leftMargin + col * (optionW + margin);
        int row = i / totalColumns;
        // 按钮的y = 行号 * (按钮高度 + 按钮之间的间距)
        CGFloat optionY = row * (optionH + margin)+100;
        optionBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        
//        // 6.2.4.设置文字
//        [optionBtn setTitle:model.name forState:UIControlStateNormal];
//        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        optionBtn.imageView.clipsToBounds = YES;
        
        // 6.2.5.添加
        [self.optionView addSubview:optionBtn];
        
        // 6.2.6.监听点击
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 6.2.7给每个按钮,添加一个文字Label
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, optionH - 10, optionW, 10)];
        label.text = [NSString stringWithFormat:@"%@.%@",model.name,model.enname];
        label.backgroundColor = [UIColor colorWithRed:0.03f green:0.22f blue:0.38f alpha:0.50f];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:8];
        [optionBtn addSubview:label];
        
    }
}
/**
 *
 */
-(void)optionClick:(UIButton *)btn
{
    PKReadViewDetialController * detialController = [[PKReadViewDetialController alloc]init];
    detialController.model = self.readItemArray[btn.tag];
    [[SlideNavigationController sharedInstance]pushViewController:detialController animated:YES];
}

@end
