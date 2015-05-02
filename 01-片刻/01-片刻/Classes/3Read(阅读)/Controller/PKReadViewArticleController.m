//
//  PKReadViewArticleController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKReadViewArticleController.h"
#import "PKReadModelDetialHot.h"

@interface PKReadViewArticleController ()<UIWebViewDelegate>

@end

@implementation PKReadViewArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setModel:(PKReadModelDetialHot *)model
{
    _model = model;
    
    [self setupWebView];
    
}
/**
 *
 */
-(void)setupWebView
{
    CGFloat webViewX = 0;
    CGFloat webViewY = 0;
    CGFloat webViewW = PKOnePageWidth;
    CGFloat webViewH = self.view.frame.size.height;
    
    CGRect frame = CGRectMake(webViewX, webViewY, webViewW, webViewH);
    
    UIWebView * webView= [[ UIWebView alloc]initWithFrame:frame];
    webView.delegate =self;
    
    //2,加载页面
    
    NSString * urlStr = [NSString stringWithFormat:@"http://pianke.me/webview/%@",self.model.id];
    PKLog(@"%@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}


@end
