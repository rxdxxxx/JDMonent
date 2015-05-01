//
//  PKHomeLeftTableView.m
//  01-片刻
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeLeftTableView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "PKHomeModelRoot.h"
#import "MJRefresh.h"
#import "PKAccountTool.h"

#import "SlideNavigationController.h"


/*不同类型的cell*/
#import "PKHomeCellSound.h"
#import "PKHomeCellMusic.h"
#import "PKHomeCellTimeline.h"
#import "PKHomeCellTopic.h"
#import "PKHomeCellMor.h"
#import "PKHomeCellPhoto.h"

/*详情控制器*/
#import "PKHomeDetialController.h"
#import "PKHomeMorController.h"



/*工具类*/
#import "IWHttpTool.h"

#import "PlayerViewController.h"

@interface PKHomeLeftTableView()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, strong)NSMutableArray * statuses;


@property (nonatomic, weak)UITableView * tableView;

@end


@implementation PKHomeLeftTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 0,刷新控件
        [self setupRefreshView];
        
    }
    return self;
}

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
    params[@"client"] = @"1";
    
    if ([PKAccountTool account].auth) {
        params[@"auth"] =  [PKAccountTool account].auth ;
    }
    
    
    NSString * url = @"http://api2.pianke.me/pub/today";
    
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        NSMutableArray* temp = (NSMutableArray *)[PKHomeModelRoot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        [temp addObjectsFromArray:self.statuses];
        self.statuses = temp;
        
        
        // 刷新tableView
        [self.tableView reloadData];
        
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
    
    NSString * url = @"http://api2.pianke.me/pub/today";
    
    
    
    // 2,发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        // 创建frame模型对象
        NSMutableArray* temp = (NSMutableArray *)[PKHomeModelRoot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        
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


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //一共有多少行.
    return self.statuses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PKHomeModelRoot * model = self.statuses[indexPath.row];
    PKHomeCellRoot * cell = nil;
    
    // 1,选择不同的cell
    switch (model.type.intValue) {
        case 2:
        {
            cell = [PKHomeCellSound cellWithTableView:tableView];
        }
            break;
        case 3:
        {
            cell = [PKHomeCellTopic cellWithTableView:tableView];
        }
            break;
        case 4:
        case 17:
        {
            cell = [PKHomeCellPhoto cellWithTableView:tableView];
            
        }
            break;
        case 5:
        {
            cell = [PKHomeCellMusic cellWithTableView:tableView];
            
        }
            break;
        case 24:
        {
            cell = [PKHomeCellTimeline cellWithTableView:tableView];
        }
            break;
            
        default:
        {
            cell = [PKHomeCellMor cellWithTableView:tableView];
        }
            break;
    }
    
    // 2.传递模型
    cell.model = model;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKHomeModelRoot * model = self.statuses[indexPath.row];
    
    
    // 1,选择不同的cell的高度.
    switch (model.type.intValue) {
        case 2:
        {
            return 290;
            
        }
            break;
        case 3:
        {
            return 320;
            
        }
            break;
        case 4:
        case 17:
            
        {
            return 440;
            
        }
            break;
        case 5:
        {
            return 0;
            
        }
            break;
        case 24:
        {
            return 450;
        }
            break;
            
        default:
        {
            return 350;
        }
            
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKHomeModelRoot * model = self.statuses[indexPath.row];
    
    // 1,选择不同的cell的高度.
    switch (model.type.intValue) {
        case 2://sound
        {
            //            PKHomeDetialController * dc = [[PKHomeDetialController alloc]init];
            //            dc = model;
            
            PlayerViewController * pvc = [[PlayerViewController alloc]init];
            pvc.model = model;
            [[SlideNavigationController sharedInstance] pushViewController:pvc animated:YES];
            
        }
            break;
        case 3://Topic
        {
            
            PKHomeMorController * mc = [[PKHomeMorController alloc]init];
            mc.model = model;
            [[SlideNavigationController sharedInstance] pushViewController:mc animated:YES];
            
        }
            break;
        case 4://photo
        case 17://illustration
            
        {
            PKHomeMorController * mc = [[PKHomeMorController alloc]init];
            mc.model = model;
            [[SlideNavigationController sharedInstance] pushViewController:mc animated:YES];
            
        }
            break;
        case 5://Music
        {
            
            
        }
            break;
        case 24://Timeline
        {
            PKHomeMorController * mc = [[PKHomeMorController alloc]init];
            mc.model = model;
            [[SlideNavigationController sharedInstance] pushViewController:mc animated:YES];
            
        }
            break;
            
        default:// Mor 等
        {
            PKHomeMorController * mc = [[PKHomeMorController alloc]init];
            mc.model = model;
            [[SlideNavigationController sharedInstance] pushViewController:mc animated:YES];
            
        }
            
            break;
    }
}


@end
