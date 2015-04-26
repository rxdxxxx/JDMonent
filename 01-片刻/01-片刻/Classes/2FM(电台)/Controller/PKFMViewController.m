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
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
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
    //1,创建 cell
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //2,设置 cell 的数据
    PKFMModelDetial * model = ( PKFMModelDetial *)self.statuses[indexPath.section][indexPath.row];
    cell.textLabel.text = model.title;
    
    
    return cell;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
