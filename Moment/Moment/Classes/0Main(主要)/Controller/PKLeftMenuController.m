//
//  PKLeftMenuController.m
//  01-片刻
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "PKLeftMenuController.h"
#import "SlideNavigationController.h"
#import "PKHomeViewController.h"
#import "PKFMViewController.h"
#import "PKReadViewController.h"
#import "PKCommunityViewController.h"
#import "PKFragmentViewController.h"
#import "PKSettingViewController.h"

#import "PKLeftCell.h"

@interface PKLeftMenuController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak)UITableView * tableView;
@property (nonatomic, strong)NSArray * nameArray;
@property (nonatomic, strong)NSArray * picArray;



@end

@implementation PKLeftMenuController




-(void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat w = self.view.frame.size.width;
//    CGFloat wScale = 500/w;
//    CGFloat h = 800 / wScale;
    CGFloat h = self.view.frame.size.height;
    
    UIImageView * imageView= [[ UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    [imageView setImage:[UIImage imageNamed:@"LeftControllerBG.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    self.slideOutAnimationEnabled = YES;
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, w, self.view.frame.size.height) style:UITableViewStylePlain ];
    tableView.contentInset = UIEdgeInsetsMake(100, 0, 100, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [UIColor clearColor];

    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.nameArray = @[@"首页",@"电台",@"阅读",@"碎片",@"设置"];
    self.picArray = @[@"LeftHome",@"LeftFM",@"LeftRead",@"LeftFre",@"LeftSetting"];
//    self.nameArray = @[@"首页",@"电台",@"阅读",@"碎片"];
//    self.picArray = @[@"LeftHome",@"LeftFM",@"LeftRead",@"LeftFre"];
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
//    self.tableView.backgroundView = imageView;
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}


#pragma mark - TableView代理方法 -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.picArray.count   ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKLeftCell * cell = [PKLeftCell cellWithTableView:tableView];
    cell.textLabel.text=self.nameArray[indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:self.picArray[indexPath.row]]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    UIViewController *vc ;
    
    switch (indexPath.row)
    {
        case 0:
            vc = [PKHomeViewController sharedInstance];
            vc.title = @"首页";
            break;
            
        case 1:
            vc = [PKFMViewController sharedInstance];
            vc.title = @"电台";

            break;
            
        case 2:
            vc = [PKReadViewController sharedInstance];
            vc.title = @"阅读";

            break;
            
//        case 3:
//            vc = [PKCommunityViewController sharedInstance];
//            vc.title = @"社区";
//
//            break;
        case 3:
            vc = [PKFragmentViewController sharedInstance];
            vc.title = @"碎片";

            break;
        case 4:
            vc = [PKSettingViewController sharedInstance];
            vc.title = @"设置";

            break;
    }
    
    [[SlideNavigationController sharedInstance]popAllAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}




@end
