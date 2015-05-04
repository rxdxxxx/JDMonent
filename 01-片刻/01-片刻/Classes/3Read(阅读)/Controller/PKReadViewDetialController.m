//
//  PKReadViewDetialController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKReadViewDetialController.h"
#import "PKReadViewDetialLeftView.h"
#import "PKReadViewDetialRightView.h"



@interface PKReadViewDetialController ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView * scrollView;


@end

@implementation PKReadViewDetialController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1.00f green:0.85f blue:0.56f alpha:1.00f];;
    
    
    
    // 1,初始化 Home页面信息
    [self createHomeView];
    
    
}

/**
 *  初始化 Home页面信息
 */
-(void)createHomeView
{
    // 1,创建左侧的TableView视图
    PKReadViewDetialLeftView * leftView = [[PKReadViewDetialLeftView alloc]initWithFrame:self.view.bounds];
    leftView.model = self.model;
    [self.scrollView addSubview:leftView];
    
    
    // 2,创建右侧的视图.
    // 如果没有登录,显示一个View  登录了显示TableView
    
    CGFloat rightViewX = PKOnePageWidth;
    CGFloat rightViewY = 0;
    CGFloat rightViewW = PKOnePageWidth;
    CGFloat rightViewH = self.view.bounds.size.height;
    
    PKReadViewDetialRightView * rightView = [[PKReadViewDetialRightView alloc]initWithFrame:CGRectMake(rightViewX, rightViewY, rightViewW, rightViewH)];
    rightView.model = self.model;
    [self.scrollView addSubview:rightView];
    
    
}
-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        
        CGRect frame = self.view.bounds;
        //        frame.origin.y += 64;
        
        // 1,创建scrollView
        UIScrollView * scrollView = [[UIScrollView alloc]init];
        scrollView.frame = frame ;
        scrollView.contentSize = CGSizeMake(frame.size.width * 2, 0);
        scrollView.backgroundColor = [UIColor clearColor];
        
        // 2,隐藏水平的滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        //    self.scrollView.showsVerticalScrollIndicator = YES;
        
        // 3,分页
        scrollView.pagingEnabled = YES;
        
        // 4,代理
        scrollView.delegate = self;
        
        // 5设置不允许出界
        scrollView.bounces = NO;
        
        //        // 6,初始偏移值
        //        scrollView.contentOffset = CGPointMake(frame.size.width, 0);
        
        // 7,添加到view中.
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        
        
    }
    
    return _scrollView;
}

@end
