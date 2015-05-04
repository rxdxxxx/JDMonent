//
//  PKMainViewCommentController.m
//  01-片刻
//
//  Created by qianfeng on 15-5-3.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKMainViewCommentController.h"
#import "PKMainModelCommentGet.h"
#import "PKMainModelCommentGetFrame.h"
#import "PKMainModelRoot.h"
#import "PKMainCellComment.h"


/*工具类*/
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "PKAccountTool.h"
#import "MBProgressHUD+MJ.h"

#define TextFildBarHeight 30

@interface PKMainViewCommentController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray * statuses;
@property (nonatomic, weak)UITextField * textField;
@property (nonatomic, weak)UITableView * tableView;

@end

@implementation PKMainViewCommentController
- (void)dealloc
{
    [PKNotificationCenter removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self setupRefreshView];
    
    [self setupNavi];
    
    [self setupTextFildBar];
}
-(UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PKOnePageWidth, PKOnePageHeight) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, TextFildBarHeight, 0);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = PKColor(226, 226, 226);
        
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}
/**
 *  添加ToolBar
 */
-(void)setupTextFildBar
{
    UITextField * textField = [[UITextField alloc]init];
    textField.background = [UIImage resizedImageWithName:@"searchbar_textfield_background"];
    //字体
    textField.font = [UIFont systemFontOfSize:13];
    //右边的清除按钮
    textField.clearButtonMode = UITextFieldViewModeAlways;
    //设置键盘右下角按钮的样式
    textField.returnKeyType = UIReturnKeySearch;
    textField.enablesReturnKeyAutomatically = YES;
    textField.delegate = self;
    
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"输入你想说的话..." attributes:attrs];
    
    CGFloat toolbarH = TextFildBarHeight;
    CGFloat toolbarW = self.view.frame.size.width;
    CGFloat toolbarX = 0;
    CGFloat toolbarY = self.view.frame.size.height - toolbarH;
    
    textField.frame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    [self.view addSubview:textField];
    self.textField = textField;
    
    
    // 2,监听textView文字改变的通知
    [PKNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:textField];
    // 3,监听键盘
    [PKNotificationCenter addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [PKNotificationCenter addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
/**
 *  监听文字改变
 */
-(void)textDidChange
{
    PKLog(@"-----%@",self.textField.text);
    
    
    self.navigationItem.rightBarButtonItem.enabled = (self.textField.text.length != 0);
}
/**
 *  键盘即将显示的时候调用
 */
-(void)KeyboardWillShow:(NSNotification *)note
{
    // 1,取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2,取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    // 3,执行动画
    [UIView animateWithDuration:duration animations:^{
        self.textField.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
    }];
}
/**
 *  键盘即将隐藏调用
 */
-(void)KeyboardWillHide:(NSNotification *)note
{
    
    // 1,取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    // 2,执行动画
    [UIView animateWithDuration:duration animations:^{
        self.textField.transform = CGAffineTransformIdentity;
    }];
}
/**
 *  拖拽一下键盘就收回了.
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
/**
 *
 */
-(void)setupNavi
{
//    {"client":"1","content":"黄金时代","deviceid":"7E603523-75CB-4DC7-A16C-2C9B802D7C9C","recid":"","reuid":"","version":"3.0.1","contentid":"552c9e3795f95b927000011f","auth":"Bs1m1FSq19fhDCMJzEMDilzJxQ8epNm2WP9TtqDDU1cWP23tZEQh5d6v4"}
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;

}
/**
 *  评论
 */
-(void)edit
{
    PKLog(@"%@",self.textField.text);
    
    if ([PKAccountTool account].auth) {
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"contentid"] = self.model.contentid;
        params[@"content"]=self.textField.text;
        params[@"deviceid"] = @"7E603523-75CB-4DC7-A16C-2C9B802D7C9C";
        params[@"auth"] =  [PKAccountTool account].auth ;
        
        
        
        NSString * url = @"http://api2.pianke.me/comment/add";
        
        //发送请求
        [IWHttpTool postWithURL:url params:params success:^(id json) {
            
            [MBProgressHUD showSuccess:@"评论成功"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.header beginRefreshing];

            });
            
        } failure:^(NSError *error) {
        }];

        self.textField.text = @"";
        [self.view endEditing:YES];

    }else{
        [MBProgressHUD showError:@"请先登录"];
        [self.view endEditing:YES];

    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    
}
-(NSMutableArray *)statuses
{
    if (_statuses == nil) {
        _statuses = [[NSMutableArray alloc]initWithCapacity:5];
    }
    return _statuses;
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
    params[@"contentid"] = self.model.contentid;
    params[@"limit"] = @10;
    params[@"start"] = @0;
    params[@"client"] = @"2";
    
    if ([PKAccountTool account].auth) {
        params[@"auth"] =  [PKAccountTool account].auth ;
    }
    
    
    NSString * url = @"http://api2.pianke.me/comment/get";
    
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        

        
        
        NSMutableArray* temp = (NSMutableArray *)[PKMainModelCommentGet objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        self.statuses = nil;
        
        for (PKMainModelCommentGet * model in temp) {
            PKMainModelCommentGetFrame * frame = [[PKMainModelCommentGetFrame alloc]init];
            frame.status = model;
            [self.statuses addObject:frame];
        }
        
        
        
        
        
        
        
        
        // 刷新tableView
        [self.tableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView.footer resetNoMoreData];
            
        });
        

        
        if (self.tableView.footer == nil) {
            [self performSelectorOnMainThread:@selector(addFooterReflash) withObject:self waitUntilDone:YES];
        }
        
        
        NSInteger total = ((NSString *)json[@"data"][@"total"]).integerValue;
        if (self.statuses.count == total) {
            
            PKLog(@"已经更新到了全部信息");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.footer noticeNoMoreData];
                
            });
            
            
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
    params[@"contentid"] = self.model.contentid;
    params[@"start"] = @(self.statuses.count);
    params[@"limit"] = @10;
    params[@"client"] = @"2";
    
    if ([PKAccountTool account].auth) {
        params[@"auth"] =  [PKAccountTool account].auth ;
    }
    
    NSString * url = @"http://api2.pianke.me/comment/get";
    
    
    
    // 2,发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        NSInteger total = ((NSString *)json[@"data"][@"total"]).integerValue;
        if (self.statuses.count == total) {
            
            PKLog(@"已经更新到了全部信息");
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.tableView.footer noticeNoMoreData];
 
            });
            

        }else{
        
            
            // 创建frame模型对象
            NSMutableArray* temp = (NSMutableArray *)[PKMainModelCommentGet objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            
            for (PKMainModelCommentGet * model in temp) {
                PKMainModelCommentGetFrame * frame = [[PKMainModelCommentGetFrame alloc]init];
                frame.status = model;
                [self.statuses addObject:frame];
            }
            
            // 刷新表格
            [self.tableView reloadData];

        }
        
        // 让刷新控件停止显示刷新状态
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        // 让刷新控件停止显示刷新状态
        [self.tableView.footer endRefreshing];
        
    }];
}


#pragma mark - Table view data source

#pragma mark - TableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.statuses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1,创建 cell
    PKMainCellComment * cell = [PKMainCellComment cellWithTableView:tableView];
    cell.statuesFrame = self.statuses[indexPath.row];
    
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKMainModelCommentGetFrame * frame = self.statuses[indexPath.row];
    return frame.cellHeight;
}

@end
