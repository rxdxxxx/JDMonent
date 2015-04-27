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
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PKOnePageWidth, PKOnePageHeight) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
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
    [self setupRequest];
    
    
    
}

/**
 *  发起网络请求
 */
-(void)setupRequest
{
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"client"] = @"2";
    params[@"sort"] = @"addtime";
    params[@"typeid"] = self.model.type;
    params[@"limit"] = @"10";
    
    
    
    NSString * url = @"http://api2.pianke.me/read/columns_detail";
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.statuses = (NSMutableArray *)[PKReadModelDetialHot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];

        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
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
