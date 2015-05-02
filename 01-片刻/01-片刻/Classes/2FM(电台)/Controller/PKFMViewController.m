//
//  PKFMViewController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKFMViewController.h"
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "PKFMModelDetial.h"
#import "PKFMCellList.h"
#import "PKFMDetialController.h"
#import "SlideNavigationController.h"
#import "MJRefresh.h"

@interface PKFMViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray * hotlist;
@property (nonatomic, strong)NSMutableArray * alllist;
@property (nonatomic, strong)NSMutableArray * statuses;
@property (nonatomic, weak)UITableView * tableView;



@end

@implementation PKFMViewController


static PKFMViewController *FMsingletonInstance = nil;

#pragma mark - Initialization -

+ (PKFMViewController *)sharedInstance
{
    if (!FMsingletonInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            FMsingletonInstance = [[self alloc]init];
        });
    }
    
    return FMsingletonInstance;
}

- (void)dealloc
{
    self.hotlist = nil;
    self.alllist = nil;
    self.statuses = nil;
    self.tableView = nil;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(NSMutableArray *)statuses
{
    if (_statuses == nil) {
        _statuses = [[NSMutableArray alloc]init];
    }
    return _statuses;
}
-(UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PKOnePageWidth, PKOnePageHeight) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        tableView.backgroundColor = PKColor(226, 226, 226);
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 0.集成刷新控件
    [self setupRefreshView];
    

    
}
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
    
    
    // 2,上拉刷新(上拉加载更多数据)
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
/**
 *  发起网络请求
 */
-(void)loadNewData
{
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"client"] = @"2";
    
    NSString * url = @"http://api2.pianke.me/ting/radio";
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.statuses = nil;
        
        self.hotlist = (NSMutableArray *)[PKFMModelDetial objectArrayWithKeyValuesArray:json[@"data"][@"hotlist"]];
        
        self.alllist = (NSMutableArray *)[PKFMModelDetial objectArrayWithKeyValuesArray:json[@"data"][@"alllist"]];
        
        [self.statuses addObject:self.hotlist];
        [self.statuses addObject:self.alllist];
        
        
        // 刷新tableView
        [self.tableView reloadData];
        
        
        // 让刷新控件停止显示刷新状态
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        
        // 让刷新控件停止显示刷新状态
        [self.tableView.header endRefreshing];
        
    }];
    
}

-(void)loadMoreData
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
   
    // 网络不好的时候,避免崩溃
    NSUInteger num = (self.statuses.count>0) ? [self.statuses[1] count] : 0;
    
    params[@"start"] = @(num);
    params[@"limit"] = @9;
    params[@"client"] = @"2";
    
    NSString * url = @"http://api2.pianke.me/ting/radio_list";
    
    
    
    // 2,发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        // 创建frame模型对象
        NSMutableArray* temp = (NSMutableArray *)[PKFMModelDetial objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        
        // 添加
        [self.statuses[1] addObjectsFromArray:temp];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 让刷新控件停止显示刷新状态
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        // 让刷新控件停止显示刷新状态
        [self.tableView.footer endRefreshing];
        
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.statuses.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.statuses[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PKFMCellList * cell = [PKFMCellList cellWithTableView:tableView];
    cell.model = self.statuses[indexPath.section][indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKFMDetialController * detialController = [[PKFMDetialController alloc]init];
    PKFMModelDetial * model = self.statuses[indexPath.section][indexPath.row];
    detialController.title = model.title;
    detialController.model = model;
    [[SlideNavigationController sharedInstance] pushViewController:detialController animated:YES];
}


@end
