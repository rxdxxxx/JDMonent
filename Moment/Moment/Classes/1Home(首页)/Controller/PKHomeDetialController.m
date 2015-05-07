//
//  PKHomeDetialController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#define JDPageNum 4
#define PKBorderBottom 100
#define PKBorderMusic 15


#import "PKHomeDetialController.h"
#import "PKHomeModelRoot.h"
#import "PKHomeModelPlayInfo.h"
#import "PKMainModelUserInfo.h"
#import "UIImageView+WebCache.h"

@interface PKHomeDetialController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, weak)UIScrollView * scrollView;

@property (nonatomic, weak)UITableView * tableView;

@property (nonatomic, weak)UIPageControl * pageControl;

@property (nonatomic, strong)NSArray * playListArr;

@property (nonatomic, strong)PKHomeModelPlayInfo * playInfo;





@end

@implementation PKHomeDetialController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)dealloc
{
    NSLog(@"");
    self.playInfo = nil;
    self.playListArr = nil;
}

-(void)setModel:(PKHomeModelRoot *)model
{
    _model = model;
    
    // 1,保存数据模型数组
    self.playListArr = model.playList;
    self.playInfo = model.playInfo;

    // 2,刷新, 第一页
    [self.tableView reloadData];
    
    // 3,设置音乐播放界面 第二页
    [self setupMusicView];

    // 4,添加webView  第三页
    [self setupWebView];
    [self createPageControl];
    
    // 5,作者信息  第四页
    [self setupAuthorInfo];


    
}

/**
 *  作者信息  第四页
 */
-(void)setupAuthorInfo
{
    // 1,主播名称
    // 1.1
    CGFloat unameLabelForX = 3 * PKOnePageWidth + PKBorderMusic ;
    CGFloat unameLabelForY = PKBorderMusic;
    CGFloat unameLabelForW = 30;
    CGFloat unameLabelForH = 30;
    UILabel * unameLabeForl = [[UILabel alloc]initWithFrame:CGRectMake(unameLabelForX, unameLabelForY, unameLabelForW, unameLabelForH)];
    unameLabeForl.text = @"主播:";
    unameLabeForl.font = [UIFont systemFontOfSize:11];
    unameLabeForl.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:unameLabeForl];
    
    // 1.2,主播对应的图片和姓名
    CGFloat unameBtnX = CGRectGetMaxX(unameLabeForl.frame) + PKBorderMusic ;
    CGFloat unameBtnY = unameLabelForY;
    CGFloat unameBtnW = 30;
    CGFloat unameBtnH = 30;
    {
//    UIButton * unameBtn = [[UIButton alloc]initWithFrame:CGRectMake(unameBtnX, unameBtnY, unameBtnW, unameBtnH)];
//    [unameBtn setImage:nil forState:UIControlStateNormal];
//    [unameBtn.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.userinfo.icon] placeholderImage:[UIImage imageNamed:@"pig_3"]];
//    [unameBtn setTitle:self.model.userinfo.uname forState:UIControlStateNormal];
//    [self.scrollView addSubview:unameBtn];
    }
    UIImageView * unameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(unameBtnX, unameBtnY, unameBtnW, unameBtnH)];
    unameImageView.layer.cornerRadius = 15;
    unameImageView.layer.masksToBounds = YES;
    [unameImageView sd_setImageWithURL:[NSURL URLWithString:self.playInfo.userinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    PKLog(@"self.model.userinfo.icon:%@",self.model.userinfo.icon);
    [self.scrollView addSubview:unameImageView];
    
    // 1.3
    CGFloat unameLabelX = CGRectGetMaxX(unameImageView.frame) + PKBorderMusic  ;
    CGFloat unameLabelY = unameBtnY;
    CGFloat unameLabelW = 100;
    CGFloat unameLabelH = 30;

    UILabel * unameLabel = [[UILabel alloc]initWithFrame:CGRectMake(unameLabelX, unameLabelY, unameLabelW, unameLabelH)];
    unameLabel.font = [UIFont systemFontOfSize:11];
    unameLabel.text = self.playInfo.userinfo.uname;
    [self.scrollView addSubview:unameLabel];
    
    
    // 2,作者名称
    // 2.1
    CGFloat authorLabelForX = 3 * PKOnePageWidth + PKBorderMusic ;
    CGFloat authorLabelForY = CGRectGetMaxY(unameLabeForl.frame) + PKBorderMusic;
    CGFloat authorLabelForW = 30;
    CGFloat authorLabelForH = 30;
    UILabel * authorLabeForl = [[UILabel alloc]initWithFrame:CGRectMake(authorLabelForX, authorLabelForY, authorLabelForW, authorLabelForH)];
    authorLabeForl.text = @"原文:";
    authorLabeForl.font = [UIFont systemFontOfSize:11];
    authorLabeForl.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:authorLabeForl];
    
    // 2.2,作者对应的图片和姓名
    CGFloat authorImageViewX = CGRectGetMaxX(authorLabeForl.frame) + PKBorderMusic ;
    CGFloat authorImageViewY = authorLabelForY;
    CGFloat authorImageViewW = 30;
    CGFloat authorImageViewH = 30;

    UIImageView * authorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(authorImageViewX, authorImageViewY, authorImageViewW, authorImageViewH)];
    authorImageView.layer.cornerRadius = 15;
    authorImageView.layer.masksToBounds = YES;
    [authorImageView sd_setImageWithURL:[NSURL URLWithString:self.playInfo.authorinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    [self.scrollView addSubview:authorImageView];
    
    // 1.3
    CGFloat authorLabelX = CGRectGetMaxX(authorImageView.frame) + PKBorderMusic  ;
    CGFloat authorLabelY = authorLabelForY;
    CGFloat authorLabelW = 100;
    CGFloat authorLabelH = 30;
    
    UILabel * authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(authorLabelX, authorLabelY, authorLabelW, authorLabelH)];
    authorLabel.font = [UIFont systemFontOfSize:11];
    authorLabel.text = self.playInfo.authorinfo.uname;
    [self.scrollView addSubview:authorLabel];
}

/**
 *  5,设置音乐播放界面
 */
-(void)setupMusicView
{
    int num = 3;
    CGFloat musicImageViewX = PKOnePageWidth + num * PKBorderMusic ;
    CGFloat musicImageViewY = PKBorderMusic;
    CGFloat musicImageViewW = PKOnePageWidth - 2 * num * PKBorderMusic;
    CGFloat musicImageViewH = musicImageViewW;
    CGRect frame = CGRectMake(musicImageViewX, musicImageViewY, musicImageViewW, musicImageViewH);
    
    // 1,设置中间图片.

    UIImageView * musicImageView = [[UIImageView alloc]initWithFrame:frame];
    [musicImageView sd_setImageWithURL:[NSURL URLWithString:self.playInfo.imgUrl] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    [self.scrollView addSubview:musicImageView];
    
    // 2,设置标题
    CGFloat titleLabelX = PKOnePageWidth;
    CGFloat titleLabelY = CGRectGetMaxY(musicImageView.frame) + 10;
    CGFloat titleLabelW = PKOnePageWidth;
    CGFloat titleLabelH = 30;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.text = self.playInfo.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.scrollView addSubview:titleLabel];
    
    // 3,设置进度条,音乐时长.
    
    
    


}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        
        
        
        CGRect frame = self.view.bounds;
        
        // 1,创建scrollView
        UIScrollView * scrollView = [[UIScrollView alloc]init];
        scrollView.frame = frame ;
        scrollView.contentSize = CGSizeMake(frame.size.width * 4, 0);
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
        
        // 6,初始偏移值
        scrollView.contentOffset = CGPointMake(frame.size.width, 0);
        
        // 7,添加到view中.
        [self.view addSubview:scrollView];
        _scrollView = scrollView;

        
    }
    
    return _scrollView;
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        
        CGFloat tableViewX = 0;
        CGFloat tableViewY = 0;
        CGFloat tableViewW = PKOnePageWidth;
        CGFloat tableViewH = self.view.frame.size.height - PKBorderBottom;
        
        CGRect frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);

        // 1,创建tableView
        UITableView * tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self.scrollView addSubview:tableView];
        _tableView = tableView;
        
    }
    
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView代理方法 -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playListArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1,创建 cell
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //2,设置 cell 的数据
    PKHomeModelPlayInfo * playInfo = self.playListArr[indexPath.row];
    cell.textLabel.text = playInfo.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by: %@",playInfo.authorinfo.uname];
    
    return cell;
}

#pragma mark -  scrollView 代理方法 -
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //根据scrollView的滚动位置决定pageControl显示第几页
    CGFloat scrollW = scrollView.frame.size.width;
    
    
    int page = (scrollView.contentOffset.x + scrollW * 0.5)/scrollW ;
    if (page<0) {
        page = 0;
    }
    
    
    self.pageControl.currentPage = page;
    
}

#pragma mark - UIPageController
-(void)createPageControl
{
    CGFloat pageContorlX = 0;
    CGFloat pageContorlY = self.scrollView.frame.size.height - 50;
    CGFloat pageContorlW = PKOnePageWidth;
    CGFloat pageContorlH = 10;
    //创建pageController
    UIPageControl * pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(pageContorlX, pageContorlY, pageContorlW, pageContorlH)];
//    UIView * vv = [UIApplication sharedApplication].keyWindow;
    [self.view addSubview:pageControl];
    self.pageControl.backgroundColor = [UIColor redColor];
    self.pageControl = pageControl;
    //设置
    self.pageControl.numberOfPages = JDPageNum;
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    
    //设置当前页数
    self.pageControl.currentPage = 1;
    
    PKLog(@"%@",NSStringFromCGRect(self.pageControl.frame));
    PKLog(@"%@",self.view.subviews);
    
    
    
}


/**
 *
 */
-(void)setupWebView
{
    
    
    
    // 1,刷新网页
    CGFloat webViewX = PKOnePageWidth*2;
    CGFloat webViewY = 0;
    CGFloat webViewW = PKOnePageWidth;
    CGFloat webViewH = self.view.frame.size.height - PKBorderBottom;
    
    CGRect frame = CGRectMake(webViewX, webViewY, webViewW, webViewH);
    
    UIWebView * webView= [[ UIWebView alloc]initWithFrame:frame];
    webView.delegate =self;

    //2,加载页面
    PKHomeModelPlayInfo * playInfo = self.model.playList[0];
    
    NSString * urlStr = playInfo.webview_url;
    PKLog(@"%@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.scrollView addSubview:webView];
}

<<<<<<< HEAD:01-片刻/01-片刻/Classes/1Home(首页)/Controller/PKHomeDetialController.m
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
//    [MBProgressHUD hideHUD];
}
/**
 *  webView 请求失败
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏提醒框
//    [MBProgressHUD hideHUD];
}
>>>>>>> DeveloperBranch:Moment/Moment/Classes/1Home(首页)/Controller/PKHomeDetialController.m
/**
 *  当 webView 发送一个请求之前,就会调用这个方法.询问代理可不可以加载这个页面.
 *
 *  @param request
 *
 *  @return  yes :可以加载  no: 不可以加载
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    
    PKLog(@"webView");
    
    return YES;
}



@end
