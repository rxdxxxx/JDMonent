//
//  PKMorController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeMorController.h"
#import "PKHomeModelPlayInfo.h"
#import "PKHomeModelRoot.h"



@interface PKHomeMorController ()<UIWebViewDelegate>

@end

@implementation PKHomeMorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setModel:(PKHomeModelRoot *)model
{
    _model = model;
    
    [self setupWebView];
    
}
<<<<<<< HEAD:01-片刻/01-片刻/Classes/1Home(首页)/Controller/PKHomeMorController.m
=======


#pragma mark - webView的代理方法 -
/**
 *  开始发送请求的时候调用
 *
 *  @param webView
 */
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示提醒框
    [MBProgressHUD showMessage:@"正在努力加载..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}
/**
 *  请求完毕的时候调用
 *
 *  @param webView
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //隐藏提醒框
    [MBProgressHUD hideHUD];
}
/**
 *  webView 请求失败
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏提醒框
    [MBProgressHUD hideHUD];
}

>>>>>>> DeveloperBranch:Moment/Moment/Classes/1Home(首页)/Controller/PKHomeMorController.m
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

    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

@end
