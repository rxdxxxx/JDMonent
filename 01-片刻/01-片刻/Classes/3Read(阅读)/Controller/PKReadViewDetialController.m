//
//  PKReadViewDetialController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKReadViewDetialController.h"
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "PKReadModelRoot.h"
#import "PKReadModelDetialHot.h"
#import "PKReadCellDetial.h"
#import "PKReadViewArticleController.h"
#import "SlideNavigationController.h"
#import "MJRefresh.h"


@interface PKReadViewDetialController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray * statuses;
@property (nonatomic, weak)UITableView * tableView;

@end

@implementation PKReadViewDetialController
- (void)dealloc
{
    self.statuses = nil;
    self.tableView = nil;
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
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = PKColor(226, 226, 226);

        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1,发起网络请求
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
    params[@"sort"] = @"addtime";
    params[@"typeid"] = self.model.type;
    params[@"limit"] = @"10";
    params[@"start"] = @"0";
    
    
    
    NSString * url = @"http://api2.pianke.me/read/columns_detail";
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.statuses = nil;
        
        self.statuses = (NSMutableArray *)[PKReadModelDetialHot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];

        
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
 * 添加上拉加载
 */
-(void)addFooterReflash
{
    // 2,上拉刷新(上拉加载更多数据)
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadMoreData
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"client"] = @"2";
    params[@"sort"] = @"addtime";
    params[@"typeid"] = self.model.type;
    params[@"limit"] = @"10";
    params[@"start"] = @([self.statuses count]);
    
    NSString * url = @"http://api2.pianke.me/read/columns_detail";
    
    
    
    // 2,发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        // 创建frame模型对象
        NSMutableArray* temp = (NSMutableArray *)[PKReadModelDetialHot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];

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
    // 1,设置cell.
    PKReadCellDetial * cell = [PKReadCellDetial cellWithTableView:tableView];
    cell.model = self.statuses[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKReadViewArticleController * ac = [[PKReadViewArticleController alloc]init];
    ac.model = self.statuses[indexPath.row];
    [[SlideNavigationController sharedInstance]pushViewController:ac animated:YES];
}

@end
