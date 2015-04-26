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
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // 头部的图片
        UIImageView *headerView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
        headerView.contentMode = UIViewContentModeScaleAspectFill;
        headerView.clipsToBounds = YES;
        [headerView sd_setImageWithURL:[NSURL URLWithString:self.radioInfo.coverimg] placeholderImage:[UIImage imageNamed:@"pig_3"]];
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
    [self setupRequest];

}

/**
 *  发起网络请求
 */
-(void)setupRequest
{
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"start"] = @"0";
    params[@"client"] = @"2";
    params[@"limit"] = @"10";
    params[@"radioid"] = self.model.radioid;
    
    NSString * url = @"http://api2.pianke.me/ting/radio_detail";
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.list = (NSMutableArray *)[PKFMModelList objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        self.radioInfo = (PKFMModelRadioInfo *)[PKFMModelRadioInfo objectWithKeyValues:json[@"data"][@"radioInfo"]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark - TableView代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
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
    [unameImageView sd_setImageWithURL:[NSURL URLWithString:self.model.userinfo.icon] placeholderImage:[UIImage imageNamed:@"pig_3"]];
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
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //2,设置 cell 的数据
    PKFMModelList* model = self.list[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}


@end
