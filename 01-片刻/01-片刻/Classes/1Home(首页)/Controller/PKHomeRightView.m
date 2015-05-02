//
//  PKHomeRightView.m
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeRightView.h"
#import "PKLoginController.h"
#import "SlideNavigationController.h"
#import "PKAccountTool.h"
#import "IWHttpTool.h"
#import "MJRefresh.h"
#import "PKHomeModelFeedRoot.h"
#import "MJExtension.h"
#import "PKHomeCellRightFeed.h"
#import "PKHomeModelFeedRootFrame.h"

@interface PKHomeRightView ()<PKLoginControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)UITableView * tableView;

@property (nonatomic, strong)NSMutableArray * statuses;


@end

@implementation PKHomeRightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        if ([PKAccountTool account].auth) {
            // 1 如果已经注册过了,那么直接刷新tableView
            [self reloadViewAfterLogin:nil];
        }else{
            // 2,创建提示登录的view
            [self createLoginView];
        }
        
        
    }
    return self;
}
/**
 *  创建提示登录的view
 */
-(void)createLoginView
{
    
    CGFloat hintLoginViewX = 0;
    CGFloat hintLoginViewY = 0;
    CGFloat hintLoginViewW = PKOnePageWidth;
    CGFloat hintLoginViewH = self.bounds.size.height;
    
    CGRect frame = CGRectMake(hintLoginViewX, hintLoginViewY, hintLoginViewW, hintLoginViewH);
    // 1,创建背景view
    UIView * hintLoginView = [[UIView alloc]initWithFrame:frame];
    hintLoginView.backgroundColor = [UIColor whiteColor];
    [self addSubview:hintLoginView];
    
    
    // 2,添加文字.
    
    CGFloat hintLabeX = 0;
    CGFloat hintLabeY = CGRectGetMidY(hintLoginView.frame);

    CGFloat hintLabeW = PKOnePageWidth;
    CGFloat hintLabeH = 30;
    
    UILabel * hintLabe = [[UILabel alloc]initWithFrame:CGRectMake(hintLabeX, hintLabeY, hintLabeW, hintLabeH)];
    hintLabe.text = @"一个人的世界太单调,快快登录吧...";
    hintLabe.textAlignment = NSTextAlignmentCenter;
    hintLabe.numberOfLines = 0;
    [hintLoginView  addSubview:hintLabe];
    
    
    // 3,创建弹出登录视图的按钮
    
    
    CGFloat buttonW = 100;
    CGFloat buttonH = 30;
    CGFloat buttonX = CGRectGetMidX(hintLoginView.bounds)- buttonW * 0.5;
    CGFloat buttonY = CGRectGetMidY(hintLoginView.bounds)+ 50;
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button setTitle:@"点击登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushLoginController) forControlEvents:UIControlEventTouchUpInside];
    [hintLoginView addSubview:button];
    
}

/**
 *  推出登录的视图
 */
-(void)pushLoginController
{
    PKLoginController * controller = [[PKLoginController alloc]init];
    controller.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:controller];
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    
    [self.delegate presentViewController:nav animated:YES completion:^{
        
    }];
}

/**
 *  登录页面的代理方法,用于在登录成功后,刷新本页面.
 */
-(void)reloadViewAfterLogin:(PKLoginController *)loginController
{
    // 1,清除原本页面上的其他视图.
    [self removeOtherView];
    
    // 2, 创建tableView,进行网络请求,刷新和展示数据.
    [self setupRefreshView];
    
}
/**
 *  1,清除原本页面上的其他视图.
 */
-(void)removeOtherView
{
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
}

/**
 *   2,创建tableView
 */
-(UITableView *)tableView
{
    
    if (_tableView == nil) {
        
        CGFloat tableViewX = 0;
        CGFloat tableViewY = 0;
        CGFloat tableViewW = PKOnePageWidth;
        CGFloat tableViewH = self.bounds.size.height - 64;
        
        CGRect frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
        
        // 1,创建tableView
        UITableView * tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self addSubview:tableView];
        _tableView = tableView;
        
    }
    
    return _tableView;
    
}
#pragma mark - 数据刷新模块
/**
 *  3,进行网络请求,刷新和展示数据
 */
/**
 *  集成刷新控件
 */
-(void)setupRefreshView
{
    
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    // 框架中会自动调用一次回调函数.
    // 也可以禁止自动加载
    // self.tableView.footer.automaticallyRefresh = NO;
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
}
/**
 * 2,增加上拉模块(上拉加载更多数据)
 */
-(void)addFooterReflash
{
    // 2,上拉刷新(上拉加载更多数据)
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
/**
 *  发起网络请求, 下拉刷新
 */
-(void)loadNewData
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"start"] = @0;
    params[@"limit"] = @10;
    params[@"client"] = @"2";
    
    if ([PKAccountTool account].auth) {
        params[@"auth"] =  [PKAccountTool account].auth ;
    }
    
    
    NSString * url = @"http://api2.pianke.me/user/feed";
    
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        NSMutableArray* temp = (NSMutableArray *)[PKHomeModelFeedRoot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        NSMutableArray * frameArray = [NSMutableArray arrayWithCapacity:10];
        for (PKHomeModelFeedRoot * model in temp) {
            PKHomeModelFeedRootFrame * frameModel = [[PKHomeModelFeedRootFrame alloc]init];
            frameModel.status = model;
            [frameArray addObject:frameModel];
        }
        temp = frameArray;
        
        self.statuses = temp;
        
        
        // 刷新tableView
        [self.tableView reloadData];
        
        // 在第一次得到数据之后,创建底部的上拉刷新模块
        if (self.tableView.footer == nil) {
            [self performSelectorOnMainThread:@selector(addFooterReflash) withObject:self waitUntilDone:YES];
        }
        
        
        
        
        // 让刷新控件停止显示刷新状态
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    
    
}
/**
 *  上拉加载
 */
-(void)loadMoreData
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"start"] = @(self.statuses.count);
    params[@"limit"] = @10;
    params[@"client"] = @"1";
    if ([PKAccountTool account].auth) {
        params[@"auth"] =  [PKAccountTool account].auth ;
    }
    
    NSString * url = @"http://api2.pianke.me/user/feed";
    
    
    
    // 2,发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        // 创建frame模型对象
        NSMutableArray* temp = (NSMutableArray *)[PKHomeModelFeedRoot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        NSMutableArray * frameArray = [NSMutableArray arrayWithCapacity:10];
        for (PKHomeModelFeedRoot * model in temp) {
            PKHomeModelFeedRootFrame * frameModel = [[PKHomeModelFeedRootFrame alloc]init];
            frameModel.status = model;
            [frameArray addObject:frameModel];
        }
        temp = frameArray;
        
        
        // 添加
        [self.statuses addObjectsFromArray:temp];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 让刷新控件停止显示刷新状态
        [self.tableView.footer endRefreshing];
        
        
        
        
    } failure:^(NSError *error) {
        // 让刷新控件停止显示刷新状态
        [self.tableView.footer endRefreshing];
        
    }];
}





#pragma mark - TableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.statuses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1,创建 cell
    PKHomeCellRightFeed * cell = [PKHomeCellRightFeed cellWithTableView:tableView];
    cell.statuesFrame = self.statuses[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKHomeModelFeedRootFrame * frame = self.statuses[indexPath.row];
    return frame.cellHeight;
}



@end
