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

@interface PKLeftMenuController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak)UITableView * tableView;

@end

@implementation PKLeftMenuController




-(void)viewDidLoad
{
    [super viewDidLoad];
<<<<<<< HEAD:01-片刻/01-片刻/Classes/0Main(主要)/Controller/PKLeftMenuController.m
=======
    CGFloat w = self.view.frame.size.width;
//    CGFloat wScale = 500/w;
//    CGFloat h = 800 / wScale;
    CGFloat h = self.view.frame.size.height;
    
    UIImageView * imageView= [[ UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    [imageView setImage:[UIImage imageNamed:@"LeftControllerBG.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
>>>>>>> DeveloperBranch:Moment/Moment/Classes/0Main(主要)/Controller/PKLeftMenuController.m
    
    self.slideOutAnimationEnabled = YES;
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, 320, self.view.frame.size.height-300) style:UITableViewStylePlain ];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
<<<<<<< HEAD:01-片刻/01-片刻/Classes/0Main(主要)/Controller/PKLeftMenuController.m

=======
    
//    self.nameArray = @[@"首页",@"电台",@"阅读",@"碎片",@"设置"];
//    self.picArray = @[@"LeftHome",@"LeftFM",@"LeftRead",@"LeftFre",@"LeftSetting"];
    self.nameArray = @[@"首页",@"电台",@"阅读",@"碎片"];
    self.picArray = @[@"LeftHome",@"LeftFM",@"LeftRead",@"LeftFre"];
>>>>>>> DeveloperBranch:Moment/Moment/Classes/0Main(主要)/Controller/PKLeftMenuController.m
    
    
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
    
<<<<<<< HEAD:01-片刻/01-片刻/Classes/0Main(主要)/Controller/PKLeftMenuController.m
    return 5   ;
=======
    return self.picArray.count   ;
>>>>>>> DeveloperBranch:Moment/Moment/Classes/0Main(主要)/Controller/PKLeftMenuController.m
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1,创建 cell
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    //2,设置 cell 的数据
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"首页";
            break;
            
        case 1:
            cell.textLabel.text = @"电台";
            break;
            
        case 2:
            cell.textLabel.text = @"阅读";
            break;
            
//        case 3:
//            cell.textLabel.text = @"社区";
//            break;
            
        case 3:
            cell.textLabel.text = @"碎片";
            break;
        case 4:
            cell.textLabel.text = @"设置";
            break;

    }
    
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
<<<<<<< HEAD:01-片刻/01-片刻/Classes/0Main(主要)/Controller/PKLeftMenuController.m
        case 4:
            vc = [PKSettingViewController sharedInstance];
            vc.title = @"设置";

            break;
=======
//        case 4:
//            vc = [PKSettingViewController sharedInstance];
//            vc.title = @"设置";
//
//            break;
>>>>>>> DeveloperBranch:Moment/Moment/Classes/0Main(主要)/Controller/PKLeftMenuController.m
    }
    
    [[SlideNavigationController sharedInstance]popAllAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];
}





@end
