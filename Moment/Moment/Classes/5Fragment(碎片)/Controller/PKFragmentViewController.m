//
//  PKFragmentViewController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKFragmentViewController.h"
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "SlideNavigationController.h"
#import "PKFragmentModelRoot.h"
#import "PKFragmentModelRootFrame.h"
#import "PKFragmentCellRoot.h"
#import "MJRefresh.h"
#import "PKFragmentDetialController.h"

@interface PKFragmentViewController ()

@property (nonatomic, strong)NSMutableArray * statuses;

@end

@implementation PKFragmentViewController

static PKFragmentViewController *fragmentSingletonInstance = nil;

#pragma mark - Initialization -

+ (PKFragmentViewController *)sharedInstance
{
    if (!fragmentSingletonInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            fragmentSingletonInstance = [[self alloc]init];
        });
    }
    return fragmentSingletonInstance;
}

-(NSMutableArray *)statuses
{
    if (_statuses == nil) {
        _statuses = [[NSMutableArray alloc]initWithCapacity:5];
    }
    return _statuses;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.31f green:0.76f blue:0.70f alpha:1.00f];
    // 1,设置tableView
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = PKColor(226, 226, 226);


    // 2,发起网络请求
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
    

}
/**
 *  发起网络请求
 */
-(void)loadNewData
{
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"client"] = @"2";
    params[@"start"] = @"0";
    params[@"limit"] = @"10";
    
    NSString * url = @"http://api2.pianke.me/timeline/list";
    
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        NSArray* tempArray = [PKFragmentModelRoot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        self.statuses = nil;
        
        for (PKFragmentModelRoot * rootModel in tempArray) {
            PKFragmentModelRootFrame * frame = [[PKFragmentModelRootFrame alloc]init];
            // 传递数据模型
            frame.status = rootModel;
            
            [self.statuses addObject:frame];
        }
        
        
        [self.tableView reloadData];
        
        // 添加上拉加载
        if (self.tableView.footer == nil) {
            [self performSelectorOnMainThread:@selector(addFooterReflash) withObject:self waitUntilDone:YES];
        }
        
        // 让刷新控件停止显示刷新状态
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        
        // 让刷新控件停止显示刷新状态
        [self.tableView.header endRefreshing];
        
    }];
    
}
/**
 *  2,上拉刷新(上拉加载更多数据)
 */
-(void)addFooterReflash
{
    // 2,上拉刷新(上拉加载更多数据)
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)loadMoreData
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"start"] = @([self.statuses count]);
    params[@"limit"] = @10;
    params[@"client"] = @"2";
    
    PKFragmentModelRootFrame * rootFrameModel = self.statuses.lastObject;
    PKFragmentModelRoot* rootModel = rootFrameModel.status;
    params[@"addtime"] = rootModel.addtime;
    
    NSString * url = @"http://api2.pianke.me/timeline/list";
    
    
    
    
    // 2,发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        NSArray* tempArray = [PKFragmentModelRoot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        for (PKFragmentModelRoot * rootModel in tempArray) {
            PKFragmentModelRootFrame * frame = [[PKFragmentModelRootFrame alloc]init];
            // 传递数据模型
            frame.status = rootModel;
            
            [self.statuses addObject:frame];
        }

        
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    PKFragmentCellRoot *cell = [PKFragmentCellRoot cellWithTableView:tableView];
    
    // 2.传递frame模型
    cell.statuesFrame = self.statuses[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKFragmentModelRootFrame *statusFrame = self.statuses[indexPath.row];
    return statusFrame.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKFragmentDetialController * detialController  =[[ PKFragmentDetialController alloc]init];
    PKFragmentModelRootFrame * frame = self.statuses[indexPath.row];
    detialController.model = frame.status;
    
    [[SlideNavigationController sharedInstance]pushViewController:detialController animated:YES];
}

@end
