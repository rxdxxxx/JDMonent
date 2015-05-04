//
//  PKReadViewArticleController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKReadViewArticleController.h"
#import "PKReadModelDetialHot.h"
#import "MBProgressHUD+MJ.h"

#import "IWHttpTool.h"
#import "MJExtension.h"
#import "PKReadModelDetialWebview.h"
#import "PKAccountTool.h"
#import "PKAccount.h"

#import "SlideNavigationController.h"
#import "PKMainViewCommentController.h"

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ButtonTagCommint = 100,
    ButtonTagLike
};

@interface PKReadViewArticleController ()<UIWebViewDelegate>
@property (nonatomic, strong)PKReadModelDetialWebview * webViewModel;
@end

@implementation PKReadViewArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
   
}

-(void)setModel:(PKReadModelDetialHot *)model
{
    _model = model;
    

    // 添加titleView
    [self setupTitleView];
    
    //发起网络请求
    [self setupRequest];
    
}

/**
 *
 */
-(void)setupTitleView
{
    // 2.
    UIView * titiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150,30)];
    titiView.backgroundColor = [UIColor greenColor];
    self.navigationItem.titleView = titiView;
    
    
    UIButton * commintBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [commintBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commintBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commintBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    commintBtn.tag = ButtonTagCommint;
    [titiView addSubview:commintBtn];
    
    UIButton * likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 50, 30)];
    [likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.tag = ButtonTagLike;
    [titiView addSubview:likeBtn];
    
    
}

/**
 *  按钮点击
 */
-(void)buttonClick:(UIButton *)button
{
    if (ButtonTagCommint == button.tag) {
        // 推出下一个页面
        PKMainViewCommentController * cc = [[PKMainViewCommentController alloc]init];
        cc.model = self.webViewModel;
        [[SlideNavigationController sharedInstance]pushViewController:cc animated:YES];
        
    }else{
        // 直接点赞加1, 反之取消赞
        
    }
}

/**
 *
 */
-(void)setupRequest
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"version"] = @"3.0.1";
    params[@"deviceid"] = @"7E603523-75CB-4DC7-A16C-2C9B802D7C9C";
    params[@"client"] = @"1";
    params[@"contentid"] = self.model.id;
    
    if ([PKAccountTool account].auth) {
        params[@"auth"] =  [PKAccountTool account].auth ;
    }
    
    [IWHttpTool postWithURL:@"http://api2.pianke.me/article/info" params:params success:^(id json) {
        
        PKReadModelDetialWebview * webViewModel = [PKReadModelDetialWebview objectWithKeyValues:json[@"data"]];

        self.webViewModel = webViewModel;
        
        [self performSelectorOnMainThread:@selector(setupWebView) withObject:self waitUntilDone:YES];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - webView的代理方法 -
/**
 *  开始发送请求的时候调用
 *
 *  @param webView
 */
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示提醒框
    [MBProgressHUD showMessage:@"小丁哥正在帮你加载..."];
    
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
    
//    UIEdgeInsets inset = UIEdgeInsetsMake(30, 0, 0, 0);
//    [webView.scrollView setContentInset:inset];
//    [webView .scrollView setContentOffset:CGPointMake(0, -30)];
//    [webView.scrollView addSubview:titleLabel];
//    
    //2,加载页面
    
    NSString * urlStr = [NSString stringWithFormat:@"http://pianke.me/webview/%@",self.model.id];
//    PKLog(@"%@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    
    
    [self.view addSubview:webView];
}




@end
