//
//  PKHomeDetialController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeDetialController.h"

@interface PKHomeDetialController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)UIScrollView * scrollView;

@property (nonatomic, weak)UITableView * tableView;



@end

@implementation PKHomeDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        
        CGRect frame = [[UIScreen mainScreen]bounds];
        
        // 1,创建scrollView
        UIScrollView * scrollView = [[UIScrollView alloc]init];
        scrollView.frame = frame ;
        scrollView.contentSize = CGSizeMake(frame.size.width * 4, 0);
        
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

-(UITableView *)tableView
{
    if (_tableView == nil) {
        
        CGRect frame = [[UIScreen mainScreen]bounds];

        // 1,创建tableView
        UITableView * tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self.scrollView addSubview:tableView];
        _tableView = tableView;
        
    }
    
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView代理方法 -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    cell.textLabel.text = @"222";
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
