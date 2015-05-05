//
//  PKFragmentDetialController.m
//  01-片刻
//
//  Created by qianfeng on 15-5-4.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKFragmentDetialController.h"


/*工具类*/
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "PKAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "PKLoginController.h"
#import "PKFragmentModelRoot.h"
#import "PKReadModelDetialWebview.h"
#import "PKMainModelCommentGet.h"
#import "PKMainModelUserInfo.h"
#import "UIImageView+WebCache.h"

#import "SlideNavigationController.h"
#import "PKMainViewCommentController.h"
#import "PKMainModelCounter.h"

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ButtonTagCommint = 100,
    ButtonTagLike
};

@interface PKFragmentDetialController ()<PKLoginControllerDelegate,UIWebViewDelegate>
{
    int kContentSizeFlag ;
}
@property (nonatomic, strong)NSMutableArray * statuses;
@property (nonatomic, strong)PKReadModelDetialWebview * modelWebView;
@property (nonatomic, weak)UIWebView * webView;
@property (nonatomic, weak)UIView * webBrowserView;

@property (nonatomic, weak)UIButton * commintBtn;
@property (nonatomic, weak)UIButton * likeBtn;
@end

@implementation PKFragmentDetialController
- (void)dealloc
{
    [PKNotificationCenter removeObserver:self];
}


-(NSMutableArray *)statuses
{
    if (_statuses == nil) {
        _statuses = [[NSMutableArray alloc]initWithCapacity:5];
    }
    return _statuses;
}


/**
 *  取出背景图片
 */
- (void)removeGradientBgColorOfWebView:(UIWebView*)aWebView{
    NSArray *subViews = aWebView.subviews;
    for (UIView* subView in subViews){
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews]){
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
}

-(UIWebView *)webView
{
    if (_webView==nil) {
        
        UIWebView * webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:webview];
        webview.delegate = self;
        self.webBrowserView = webview.scrollView.subviews[0];
        _webView = webview;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加titleView
    [self setupTitleView];
    
    // 取出webview中imageveiw
    [self removeGradientBgColorOfWebView:self.webView];
    
    // 1,发起网络请求
    [self setupDataRequest];
    
    
}

/**
 *  网页顶部加上一个headerView,并随着网页一起滚动
 */
-(void)setupWebHeaderView
{
    
    // 1,加载刷新titleView
    [self.commintBtn setTitle:self.modelWebView.counterList.comment.stringValue forState:UIControlStateNormal];
    [self.likeBtn setTitle:self.modelWebView.counterList.like.stringValue forState:UIControlStateNormal];
    
    CGFloat headerViewX = 0;
    CGFloat headerViewY = 0;
    CGFloat headerViewW = PKOnePageWidth;
    CGFloat headerViewH = 100;
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(headerViewX, headerViewY, headerViewW, headerViewH)];
    
    
    /** 2.头像 */
    CGFloat iconViewX = 10;
    CGFloat iconViewY = 10;
    CGFloat iconViewW = 40;
    CGFloat iconViewH = 40;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.modelWebView.userinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    iconView.layer.cornerRadius = 20;
    iconView.clipsToBounds = YES;
    [headerView addSubview:iconView];
    

    
    /** 6.时间 */
    CGFloat timeLabelY = CGRectGetMinY(iconView.frame) + PKStatusTableBorder * 0.5;
    CGSize timeLabelSize = [self.modelWebView.addtime_f sizeWithAttributes:@{NSFontAttributeName:PKStatusTimeFont}];
    CGFloat timeLabelX = PKOnePageWidth - 3*timeLabelSize.width;
    CGRect timeLabelF = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeLabelF];
    timeLabel.text = self.modelWebView.addtime_f;
    timeLabel.font = PKStatusTimeFont;
    timeLabel.textColor = PKColor(240, 140, 19);
    timeLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:timeLabel];
    
    
//    [_webView.scrollView addSubview:headerView];
    [self.webBrowserView addSubview:headerView];
//    UIView *webBrowserView = self.webBrowserView;
//    CGRect frame = webBrowserView.frame;
//    frame.origin.y = CGRectGetMaxY(headerView.frame);
//    webBrowserView.frame = frame;
    
    
    
    
}

/**
 *  发起网络请求
 */
-(void)setupDataRequest
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"version"] = @"3.0.1";
    params[@"deviceid"] = @"7E603523-75CB-4DC7-A16C-2C9B802D7C9C";
    params[@"client"] = @"1";
    params[@"contentid"] = self.model.contentid;
    
    if ([PKAccountTool account].auth) {
        params[@"auth"] =  [PKAccountTool account].auth ;
    }
    
    
    NSString * url = @"http://api2.pianke.me/timeline/info";
    
    
    
    // 2,发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.modelWebView = [PKReadModelDetialWebview objectWithKeyValues:json[@"data"]];
        
        self.statuses = self.modelWebView.commentlist;
        
//        [self.webView loadHTMLString:self.modelWebView.html baseURL:nil];
        
        _webView.opaque = NO;
        self.webBrowserView.hidden = YES;
        
        
        NSString * urlStr = [NSString stringWithFormat:@"http://pianke.me/webview/%@",self.modelWebView.contentid];
        PKLog(@"%@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];

        
        [self performSelectorOnMainThread:@selector(setupWebHeaderView) withObject:self waitUntilDone:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - titleview
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
    [commintBtn setTitle:@"0" forState:UIControlStateNormal];
    [commintBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commintBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    commintBtn.tag = ButtonTagCommint;
    [titiView addSubview:commintBtn];
    self.commintBtn = commintBtn;
    
    UIButton * likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 50, 30)];
    [likeBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [likeBtn setTitle:@"0" forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.tag = ButtonTagLike;
    [titiView addSubview:likeBtn];
    self.likeBtn = likeBtn;
    
}

/**
 *  按钮点击
 */
-(void)buttonClick:(UIButton *)button
{
    if (ButtonTagCommint == button.tag) {
        // 推出下一个页面
        PKMainViewCommentController * cc = [[PKMainViewCommentController alloc]init];
        cc.model = self.modelWebView;
        [[SlideNavigationController sharedInstance]pushViewController:cc animated:YES];
        
    }else{
        // 直接点赞加1, 反之取消赞
        if ([PKAccountTool account].auth) {
            // 已经登录
            [self sendLikeRequest];
        }else{
            // 推出登录页面
            
            PKLoginController * controller = [[PKLoginController alloc]init];
            controller.delegate = self;
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:controller];
            nav.navigationBar.backgroundColor = [UIColor clearColor];
            
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }
    }
}

-(void)reloadViewAfterLogin:(PKLoginController *)loginController
{
    
}
/**
 *  发送like的请求
 */
-(void)sendLikeRequest
{
    
    [IWHttpTool postLikeWithContentID:self.modelWebView.contentid success:^(id json) {
        
//        [self.likeBtn setTitle:self.modelWebView.counterList.like.stringValue forState:UIControlStateNormal];
        
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.webBrowserView.hidden = NO;
    _webView.backgroundColor = [UIColor whiteColor];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _webView.opaque = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    PKLog(@"dididdididd");
//    
//    
//    NSString* mata = [NSString stringWithFormat:@"var script = document.createElement('script');"
//                      "script.type = 'text/javascript';"
//                      "script.text = \"function ResizeImages() { "
//                      "var myimg,oldwidth;"
//                      "var maxwidth=%f;" //缩放系数
//                      "for(i=0;i <document.images.length;i++){"
//                        "myimg = document.images[i];"
//                        "if(myimg.width > maxwidth){"
//                            "oldwidth = myimg.width;"
//                            "myimg.width = maxwidth;"
//                            "myimg.height = myimg.height * (maxwidth/oldwidth);"
//                        "}"
//                      "}"
//                      "}\";"
//                      "document.getElementsByTagName('head')[0].appendChild(script);",((float)(PKOnePageWidth-50))];
//    
//    //修改服务器页面的meta的值
//    [webView stringByEvaluatingJavaScriptFromString: mata ];
//    
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//}

@end
