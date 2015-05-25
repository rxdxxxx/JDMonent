//
//  PKSettingRootController.m
//  Moment
//
//  Created by qianfeng on 15-5-18.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKSettingRootController.h"
#import "PKSettingGroup.h"
#import "PKSettingCell.h"
#import "PKSettingArrowItem.h"

@interface PKSettingRootController ()

@end

@implementation PKSettingRootController

-(NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}
-(PKSettingGroup *)addGroup
{
    PKSettingGroup * group = [PKSettingGroup group];
    [self.groups addObject:group];
    return group;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(void)viewDidAppear:(BOOL)animated{}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = PKColor(226, 226, 226);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    if (iOS7) {
        self.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    }
    
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PKSettingGroup * group = self.groups[section];
    return group.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKSettingCell * cell = [PKSettingCell cellWithTableView:tableView];
    PKSettingGroup * group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - 代理
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    PKSettingGroup * group = self.groups[section];
    return group.footer;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PKSettingGroup * group = self.groups[section];
    return group.header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 消除cell被选中的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 1,取出模型
    PKSettingGroup * group = self.groups[indexPath.section];
    PKSettingItem * item = group.items[indexPath.row];
    
    // 2,操作
    if (item.operation) {
        item.operation();
    }
    
    // 3,跳转
    if ([item isKindOfClass:[PKSettingArrowItem class]]) {
        PKSettingArrowItem * arrowItem = (PKSettingArrowItem *)item;
        if (arrowItem.destVcClass) {
            UIViewController * destVc = [[arrowItem.destVcClass alloc]init];
            destVc.title = arrowItem.title;
            [self.navigationController pushViewController:destVc animated:YES];
        }
        
    }
}

























@end
