/* vim: set ft=objc fenc=utf-8 sw=2 ts=2 et: */
/*
 *  DOUAudioStreamer - A Core Audio based streaming audio player for iOS/Mac:
 *
 *      https://github.com/douban/DOUAudioStreamer
 *
 *  Copyright 2013-2014 Douban Inc.  All rights reserved.
 *
 *  Use and distribution licensed under the BSD license.  See
 *  the LICENSE file for full text.
 *
 *  Authors:
 *      Chongyu Zhu <i@lembacon.com>
 *
 */

#define JDPageNum 4
#define PKBorderBottom 100
#define PKBorderMusic 15

#import "PlayerViewController.h"
#import "Track.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"

// PK文件
#import "PKHomeModelRoot.h"
#import "PKHomeModelPlayInfo.h"
#import "PKMainModelUserInfo.h"
#import "UIImageView+WebCache.h"




static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface PlayerViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
@private
    UILabel *_titleLabel;
    UILabel *_statusLabel;
    UILabel *_miscLabel;
    
    UIButton *_buttonPlayPause;
    UIButton *_buttonNext;
    UIButton *_buttonStop;
    
    UISlider *_progressSlider;
    
    UILabel *_volumeLabel;
    UISlider *_volumeSlider;
    
    NSUInteger _currentTrackIndex;
    NSTimer *_timer;
    
    DOUAudioStreamer *_streamer;
    DOUAudioVisualizer *_audioVisualizer;
    
    UIView * audioStreamerView;
    
    //需要刷新的控件
    //音乐图片
    UIImageView * albumImage;
    UILabel * albumTitle;
    UIWebView * albumWebView;
    UIImageView * albumUserImage;
    UIImageView * albumAuthorImage;
    UILabel * albumUserLabel;
    UILabel * albumAuthorLabel;
    
}

@property (nonatomic, weak)UIScrollView * scrollView;

@property (nonatomic, weak)UITableView * tableView;

@property (nonatomic, weak)UIPageControl * pageControl;

@property (nonatomic, strong)NSArray * playListArr;

@property (nonatomic, strong)PKHomeModelPlayInfo * playInfo;

// 设置音频信息数组..
@property (nonatomic, copy) NSArray *tracks;

@end

@implementation PlayerViewController


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
    
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:10];
    int currentMusic = 0;
    for (PKHomeModelPlayInfo * playInfo in model.playList) {
        Track * track = [[Track alloc]init];
        track.title = model.title;
        track.artist = model.userinfo.uname;
        track.audioFileURL = [NSURL URLWithString:playInfo.musicUrl];
        [tempArray addObject:track];
        
        
        if ([model.playInfo.title isEqualToString:model.title]) {
            _currentTrackIndex = currentMusic;
        }else{
            currentMusic ++;
        }
        
        
    }

    self.tracks = tempArray;

 
    // 0,保存数据模型数组
    self.playListArr = model.playList;
    self.playInfo = model.playInfo; 
    
    // 1,设置播放器的控件
    [self myloadView:self.playInfo];
    
    // 2,刷新, 第一页
    [self.tableView reloadData];
    
    // 3,设置音乐播放界面 第二页, 合并到了1中
//    [self setupMusicView];
    
    // 4,添加webView  第三页
    [self setupWebView:self.playInfo];
    [self createPageControl];
    
    // 5,作者信息  第四页

    [self setupAuthorInfo:self.playInfo];
    
    
    
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

// 2,刷新, 第一页
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

/**
 *  3,设置音乐播放界面 第二页
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

/**
 * 4,添加webView  第三页
 */
-(void)setupWebView:(PKHomeModelPlayInfo *)playInfo
{
    CGFloat webViewX = PKOnePageWidth*2;
    CGFloat webViewY = 0;
    CGFloat webViewW = PKOnePageWidth;
    CGFloat webViewH = self.view.frame.size.height - PKBorderBottom;
    
    CGRect frame = CGRectMake(webViewX, webViewY, webViewW, webViewH);
    
    UIWebView * webView= [[ UIWebView alloc]initWithFrame:frame];
    webView.delegate =self;

    
    //2,加载页面
    NSString * urlStr = playInfo.webview_url;
    PKLog(@"%@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.scrollView addSubview:webView];
    albumWebView = webView;
}
#pragma mark - UIPageController
-(void)createPageControl
{
    CGFloat pageContorlX = 0;
    CGFloat pageContorlY = self.scrollView.frame.size.height - 80;
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
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.51f green:0.69f blue:0.21f alpha:1.00f];;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    
    //设置当前页数
    self.pageControl.currentPage = 1;
    
    PKLog(@"%@",NSStringFromCGRect(self.pageControl.frame));
    PKLog(@"%@",self.view.subviews);
    
    
    
}

/**
 *  作者信息  第四页
 */
-(void)setupAuthorInfo:(PKHomeModelPlayInfo *)playInfo
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
    [unameImageView sd_setImageWithURL:[NSURL URLWithString:playInfo.userinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
//    PKLog(@"self.model.userinfo.icon:%@",playInfo.userinfo.icon);
    [self.scrollView addSubview:unameImageView];
    albumUserImage = unameImageView;
    
    // 1.3
    CGFloat unameLabelX = CGRectGetMaxX(unameImageView.frame) + PKBorderMusic  ;
    CGFloat unameLabelY = unameBtnY;
    CGFloat unameLabelW = 100;
    CGFloat unameLabelH = 30;
    
    UILabel * unameLabel = [[UILabel alloc]initWithFrame:CGRectMake(unameLabelX, unameLabelY, unameLabelW, unameLabelH)];
    unameLabel.font = [UIFont systemFontOfSize:11];
    unameLabel.text = playInfo.userinfo.uname;
    [self.scrollView addSubview:unameLabel];
    albumUserLabel = unameLabel;
    
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
    [authorImageView sd_setImageWithURL:[NSURL URLWithString:playInfo.authorinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    [self.scrollView addSubview:authorImageView];
    albumAuthorImage = authorImageView;
    
    // 1.3
    CGFloat authorLabelX = CGRectGetMaxX(authorImageView.frame) + PKBorderMusic  ;
    CGFloat authorLabelY = authorLabelForY;
    CGFloat authorLabelW = 100;
    CGFloat authorLabelH = 30;
    
    UILabel * authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(authorLabelX, authorLabelY, authorLabelW, authorLabelH)];
    authorLabel.font = [UIFont systemFontOfSize:11];
    authorLabel.text = playInfo.authorinfo.uname;
    [self.scrollView addSubview:authorLabel];
    albumAuthorLabel = authorLabel;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKHomeModelPlayInfo * playInfo = self.playListArr[indexPath.row];
    _currentTrackIndex = indexPath.row;
    
    [self resetEveryViewInfo:playInfo];
    
}

/**
 *
 */
-(void)resetEveryViewInfo:(PKHomeModelPlayInfo *)playInfo
{
    // 0,设置音频
    [self _resetStreamer];

    // 1,音乐界面
    [albumImage sd_setImageWithURL:[NSURL URLWithString:playInfo.imgUrl] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    albumTitle.text = playInfo.title;
    
    // 2,加载页面
    NSString * urlStr = playInfo.webview_url;
    PKLog(@"%@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [albumWebView loadRequest:request];
    
    // 3,作者页面
    albumUserLabel.text = playInfo.userinfo.uname;
    [albumUserImage sd_setImageWithURL:[NSURL URLWithString:playInfo.userinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    
    albumAuthorLabel.text = playInfo.authorinfo.uname;
    [albumAuthorImage sd_setImageWithURL:[NSURL URLWithString:playInfo.authorinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
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

















#pragma mark -AudioStreamer-
- (void)myloadView:(PKHomeModelPlayInfo *)playInfo
{
    CGFloat viewX = PKOnePageWidth;
    CGFloat viewY = 0;
    CGSize viewSize = [[UIScreen mainScreen]bounds].size;
    CGRect frame = (CGRect){{viewX,viewY},viewSize};
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    int num = 3;
    CGFloat musicImageViewX = num * PKBorderMusic ;
    CGFloat musicImageViewY = PKBorderMusic;
    CGFloat musicImageViewW = PKOnePageWidth - 2 * num * PKBorderMusic;
    CGFloat musicImageViewH = musicImageViewW;
    CGRect musicImageViewFrame = CGRectMake(musicImageViewX, musicImageViewY, musicImageViewW, musicImageViewH);
    
    // 1,设置中间图片.
    
    UIImageView * musicImageView = [[UIImageView alloc]initWithFrame:musicImageViewFrame];
    [musicImageView sd_setImageWithURL:[NSURL URLWithString:playInfo.imgUrl] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    [view addSubview:musicImageView];
    albumImage = musicImageView;
    
    // 2,设置标题
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = CGRectGetMaxY(musicImageView.frame) + 10;
    CGFloat titleLabelW = PKOnePageWidth;
    CGFloat titleLabelH = 30;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.text = playInfo.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [view addSubview:titleLabel];
    albumTitle = titleLabel;

    {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 64.0, 0, 30.0)];
    [_titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    _titleLabel.hidden =YES;
    [view addSubview:_titleLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([_titleLabel frame]) + 10.0, 0, 30.0)];
    [_statusLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_statusLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
    [_statusLabel setTextAlignment:NSTextAlignmentCenter];
    [_statusLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    _statusLabel.hidden = YES;
    [view addSubview:_statusLabel];
    }
    
    _miscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(musicImageView.frame), CGRectGetWidth([view bounds]), 20.0)];
    [_miscLabel setFont:[UIFont systemFontOfSize:10.0]];
    [_miscLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
    [_miscLabel setTextAlignment:NSTextAlignmentCenter];
    [_miscLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [view addSubview:_miscLabel];
    
    _buttonPlayPause = [UIButton buttonWithType:UIButtonTypeSystem];
    [_buttonPlayPause setFrame:CGRectMake(80.0,CGRectGetMaxY([musicImageView frame]) + 150.0, 60.0, 20.0)];
    [_buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
    [_buttonPlayPause addTarget:self action:@selector(_actionPlayPause:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:_buttonPlayPause];
    
    _buttonNext = [UIButton buttonWithType:UIButtonTypeSystem];
    [_buttonNext setFrame:CGRectMake(CGRectGetWidth([view bounds]) - 80.0 - 60.0, CGRectGetMaxY([musicImageView frame]) + 150.0, 60.0, 20.0)];
    [_buttonNext setTitle:@"Next" forState:UIControlStateNormal];
    [_buttonNext addTarget:self action:@selector(_actionNext:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:_buttonNext];
    
    _buttonStop = [UIButton buttonWithType:UIButtonTypeSystem];
    [_buttonStop setFrame:CGRectMake(round((CGRectGetWidth([view bounds]) - 60.0) / 2.0), CGRectGetMaxY([musicImageView frame]) + 150.0, 60.0, 20.0)];
    [_buttonStop setTitle:@"Stop" forState:UIControlStateNormal];
    [_buttonStop addTarget:self action:@selector(_actionStop:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:_buttonStop];
    
    // 进度条
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0, CGRectGetMaxY([musicImageView frame]) + 50.0, CGRectGetWidth([view bounds]) - 20.0 * 2.0, 40.0)];
    [_progressSlider addTarget:self action:@selector(_actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_progressSlider];
    
    _volumeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_volumeLabel setText:@"Volume:"];
    [view addSubview:_volumeLabel];
    
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [_volumeSlider addTarget:self action:@selector(_actionSliderVolume:) forControlEvents:UIControlEventValueChanged];
    _volumeSlider.hidden = YES;
    [view addSubview:_volumeSlider];
    
    _audioVisualizer = [[DOUAudioVisualizer alloc] initWithFrame:CGRectMake(0.0,0, CGRectGetWidth([view bounds]), CGRectGetHeight([view bounds]) - CGRectGetMaxY([_volumeSlider frame]))];
    [_audioVisualizer setBackgroundColor:[UIColor colorWithRed:239.0 / 255.0 green:244.0 / 255.0 blue:240.0 / 255.0 alpha:1.0]];
    [view insertSubview:_audioVisualizer atIndex:0];
    
    [self.scrollView addSubview:view];
}



- (void)_cancelStreamer
{
  if (_streamer != nil) {
    [_streamer pause];
    [_streamer removeObserver:self forKeyPath:@"status"];
    [_streamer removeObserver:self forKeyPath:@"duration"];
    [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
    _streamer = nil;
  }
}

- (void)_resetStreamer
{
  [self _cancelStreamer];

    if (0 == [_tracks count])
    {
        [_miscLabel setText:@"(No tracks available)"];
    }
    else
    {
        Track *track = [_tracks objectAtIndex:_currentTrackIndex];
        NSString *title = [NSString stringWithFormat:@"%@ - %@", track.artist, track.title];
        [_titleLabel setText:title];
        
        _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
        [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
        [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
        
        [_streamer play];
        
        [self _updateBufferingStatus];
        [self _setupHintForStreamer];
    }
}

- (void)_setupHintForStreamer
{
  NSUInteger nextIndex = _currentTrackIndex + 1;
  if (nextIndex >= [_tracks count]) {
    nextIndex = 0;
  }

  [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

- (void)_timerAction:(id)timer
{
  if ([_streamer duration] == 0.0) {
    [_progressSlider setValue:0.0f animated:NO];
  }
  else {
    [_progressSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
  }
}

- (void)_updateStatus
{
  switch ([_streamer status]) {
  case DOUAudioStreamerPlaying:
    [_statusLabel setText:@"playing"];
    [_buttonPlayPause setTitle:@"Pause" forState:UIControlStateNormal];
    break;

  case DOUAudioStreamerPaused:
    [_statusLabel setText:@"paused"];
    [_buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
    break;

  case DOUAudioStreamerIdle:
    [_statusLabel setText:@"idle"];
    [_buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
    break;

  case DOUAudioStreamerFinished:
    [_statusLabel setText:@"finished"];
    [self _actionNext:nil];
    break;

  case DOUAudioStreamerBuffering:
    [_statusLabel setText:@"buffering"];
    break;

  case DOUAudioStreamerError:
    [_statusLabel setText:@"error"];
    break;
  }
}

- (void)_updateBufferingStatus
{
  [_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];

  if ([_streamer bufferingRatio] >= 1.0) {
    NSLog(@"sha256: %@", [_streamer sha256]);
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == kStatusKVOKey) {
    [self performSelector:@selector(_updateStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kDurationKVOKey) {
    [self performSelector:@selector(_timerAction:)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kBufferingRatioKVOKey) {
    [self performSelector:@selector(_updateBufferingStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  [self _resetStreamer];

  _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
  [_volumeSlider setValue:[DOUAudioStreamer volume]];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [_timer invalidate];
  [_streamer stop];
  [self _cancelStreamer];

  [super viewWillDisappear:animated];
}

- (void)_actionPlayPause:(id)sender
{
  if ([_streamer status] == DOUAudioStreamerPaused ||
      [_streamer status] == DOUAudioStreamerIdle) {
    [_streamer play];
  }
  else {
    [_streamer pause];
  }
}

- (void)_actionNext:(id)sender
{
  if (++_currentTrackIndex >= [_tracks count]) {
    _currentTrackIndex = 0;
  }

#warning 下一曲
    PKHomeModelPlayInfo * playInfo = self.playListArr[_currentTrackIndex];
    [self resetEveryViewInfo:playInfo];

}

- (void)_actionStop:(id)sender
{
  [_streamer stop];
}

- (void)_actionSliderProgress:(id)sender
{
  [_streamer setCurrentTime:[_streamer duration] * [_progressSlider value]];
}

- (void)_actionSliderVolume:(id)sender
{
  [DOUAudioStreamer setVolume:[_volumeSlider value]];
}

@end
