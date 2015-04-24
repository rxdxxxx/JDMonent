//
//  PKHomeViewController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKHomeViewController.h"
#import "SlideNavigationController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "PKHomeModelRoot.h"


@interface PKHomeViewController ()

@property (nonatomic, strong)NSMutableArray * statuses;

@end

@implementation PKHomeViewController


static PKHomeViewController *HomesingletonInstance = nil;

#pragma mark - Initialization -

+ (PKHomeViewController *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HomesingletonInstance = [[self alloc]init];
    });
    
    return HomesingletonInstance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1,发起网络请求
    [self setupRequest];
    
    
    
}

/**
 *  发起网络请求
 */
-(void)setupRequest
{
    
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    //说明服务器,返回的是 json 类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"start"] = @0;
    params[@"limit"] = @20;
    params[@"deviceid"] = @"8DBCAF13-689C-49C1-ADFB-0EC866F4BC2B";
    params[@"client"] = @"1";
    params[@"auth"] = @"";
    params[@"version"] = @"3.0.1";

    
    
    NSString * url = @"http://api2.pianke.me/pub/today";
    
    //发送请求
    [mgr POST:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         self.statuses = (NSMutableArray *)[PKHomeModelRoot objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
         NSLog(@"");
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@",error);
         
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - SlideNavigationControllerDelegate -
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
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
