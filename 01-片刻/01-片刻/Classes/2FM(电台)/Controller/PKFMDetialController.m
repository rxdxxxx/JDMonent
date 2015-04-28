//
//  PKFMDetialController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKFMDetialController.h"
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "PKFMModelList.h"
#import "PKFMModelRadioInfo.h"
#import "PKFMModelDetial.h"
#import "UIImageView+WebCache.h"
#import "PKMainModelUserInfo.h"
#import "PlayerViewController.h"
#import "SlideNavigationController.h"
#import "PKHomeModelRoot.h"
#import "PKFMCellDetial.h"
#import "MJRefresh.h"

@interface PKFMDetialController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)UITableView * tableView;

@property (nonatomic, strong)NSMutableArray * list;
@property (nonatomic, strong)PKFMModelRadioInfo * radioInfo;


@end

@implementation PKFMDetialController

- (void)dealloc
{
    self.list = nil;
    self.tableView = nil;
}


-(UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PKOnePageWidth, PKOnePageHeight) style:UITableViewStyleGrouped];

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // 头部的图片
        UIImageView *headerView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
        headerView.contentMode = UIViewContentModeScaleAspectFill;
        headerView.clipsToBounds = YES;
//        [headerView sd_setImageWithURL:[NSURL URLWithString:self.radioInfo.coverimg] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
        [headerView sd_setImageWithURL:[NSURL URLWithString:self.model.coverimg] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
        tableView.tableHeaderView = headerView;
        
        
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
    
    
    // 2,上拉刷新(上拉加载更多数据)
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
/**
 *  发起网络请求
 */
-(void)loadNewData
{
    
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"start"] = @"0";
    params[@"client"] = @"2";
    params[@"limit"] = @"10";
    params[@"radioid"] = self.model.radioid;
    
    NSString * url = @"http://api2.pianke.me/ting/radio_detail";
    
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.list = nil;
        self.radioInfo = nil;
        
        self.list = (NSMutableArray *)[PKFMModelList objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        self.radioInfo = (PKFMModelRadioInfo *)[PKFMModelRadioInfo objectWithKeyValues:json[@"data"][@"radioInfo"]];
        
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
    NSUInteger num = (self.list != nil) ? [self.list count] : 0;
    
    params[@"start"] = @(num);
    params[@"limit"] = @10;
    params[@"client"] = @"2";
    params[@"radioid"] = self.model.radioid;
    
    NSString * url = @"http://api2.pianke.me/ting/radio_detail_list";
    
    
    
    // 2,发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        // 创建frame模型对象
        NSMutableArray* temp = (NSMutableArray *)[PKFMModelList objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
    
        // 添加
        [self.list addObjectsFromArray:temp];
        
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    // 1,主播名称
    // 1.1
    int iPKBorderWidth = 20;
    
    CGFloat unameLabelForX = iPKBorderWidth ;
    CGFloat unameLabelForY = iPKBorderWidth;
    CGFloat unameLabelForW = 30;
    CGFloat unameLabelForH = 30;
    UILabel * unameLabeForl = [[UILabel alloc]initWithFrame:CGRectMake(unameLabelForX, unameLabelForY, unameLabelForW, unameLabelForH)];
    unameLabeForl.text = @"主播:";
    unameLabeForl.font = [UIFont systemFontOfSize:11];
    [view addSubview:unameLabeForl];
    
    // 1.2,主播对应的图片和姓名
    CGFloat unameBtnX = CGRectGetMaxX(unameLabeForl.frame) + iPKBorderWidth ;
    CGFloat unameBtnY = unameLabelForY;
    CGFloat unameBtnW = 30;
    CGFloat unameBtnH = 30;

    UIImageView * unameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(unameBtnX, unameBtnY, unameBtnW, unameBtnH)];
    unameImageView.layer.cornerRadius = 15;
    unameImageView.layer.masksToBounds = YES;
    [unameImageView sd_setImageWithURL:[NSURL URLWithString:self.model.userinfo.icon] placeholderImage:[UIImage imageNamed:PKPlaceholderImage]];
    [view addSubview:unameImageView];
    
    // 1.3
    CGFloat unameLabelX = CGRectGetMaxX(unameImageView.frame) + iPKBorderWidth  ;
    CGFloat unameLabelY = unameBtnY;
    CGFloat unameLabelW = 100;
    CGFloat unameLabelH = 30;
    
    UILabel * unameLabel = [[UILabel alloc]initWithFrame:CGRectMake(unameLabelX, unameLabelY, unameLabelW, unameLabelH)];
    unameLabel.font = [UIFont systemFontOfSize:11];
    unameLabel.text = self.model.userinfo.uname;
    [view addSubview:unameLabel];
    

    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1,创建 cell
    PKFMCellDetial * cell = [PKFMCellDetial cellWithTableView:tableView];
    cell.model = self.list[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建一个rootModel再传递给PlayView
    // 1,赋值一个playInfo
    PKFMModelList* list =  self.list[indexPath.row];
    PKHomeModelRoot * rootModel = [[PKHomeModelRoot alloc]init];
    rootModel.playInfo = list.playInfo;

    // 2,取出每一个playInfo赋给RootModel的PlayList
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:10];
    for (PKFMModelList * listModel in self.list) {
        [tempArray addObject:listModel.playInfo];
    }
    rootModel.playList = tempArray;
    
    PlayerViewController * pvc = [[PlayerViewController alloc]init];
    pvc.model = rootModel;
    [[SlideNavigationController sharedInstance] pushViewController:pvc animated:YES];
}


@end
