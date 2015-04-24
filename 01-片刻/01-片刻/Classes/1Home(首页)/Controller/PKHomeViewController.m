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

/*不同类型的cell*/
#import "PKHomeCellSound.h"
#import "PKHomeCellMusic.h"
#import "PKHomeCellTimeline.h"
#import "PKHomeCellTopic.h"
#import "PKHomeCellMor.h"
#import "PKHomeCellPhoto.h"

/*工具类*/
#import "IWHttpTool.h"



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
    
    // 2,设置tableView
    [self setupTableView];
    
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
    params[@"limit"] = @40;
    params[@"deviceid"] = @"8DBCAF13-689C-49C1-ADFB-0EC866F4BC2B";
    params[@"client"] = @"1";
    params[@"auth"] = @"";
    params[@"version"] = @"3.0.1";

    
    
    NSString * url = @"http://api2.pianke.me/pub/today";
    
    //发送请求
    [IWHttpTool postWithURL:url params:params success:^(id json) {
        
        self.statuses = (NSMutableArray *)[PKHomeModelRoot objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);

    }];
    
//    [mgr POST:url parameters:params
//     success:^(AFHTTPRequestOperation *operation, id responseObject) {
//         
//
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         
//         
//     }];
    
}

/**
 *  2,设置tableView
 */
-(void)setupTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
