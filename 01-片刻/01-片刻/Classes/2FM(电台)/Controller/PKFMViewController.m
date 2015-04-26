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
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PKOnePageWidth, PKOnePageHeight) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
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
    
    NSString * url = @"http://api2.pianke.me/ting/radio";
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.hotlist = (NSMutableArray *)[PKFMModelDetial objectArrayWithKeyValuesArray:json[@"data"][@"hotlist"]];
        
        self.alllist = (NSMutableArray *)[PKFMModelDetial objectArrayWithKeyValuesArray:json[@"data"][@"alllist"]];
        
        [self.statuses addObject:self.hotlist];
        [self.statuses addObject:self.alllist];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
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
