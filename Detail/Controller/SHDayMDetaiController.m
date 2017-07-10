//
//  SHDayMDetaiController.m
//  distmeeting
//
//  Created by songdan Ye on 15/11/6.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "SHDayMDetaiController.h"
#import "SHMeetingDCell.h"
//#import "SHMeetingDetailController.h"
#import "SHMeetingModel.h"
#import "SHMyMeetingModel.h"
#import "MBProgressHUD+MJ.h"
#import "SHAgencyVController.h"
#import "SHMeetingDetailVC.h"

@interface SHDayMDetaiController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SHDayMDetaiController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
    UITableView *tabView =[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tabView = tabView;
    _tabView.dataSource =self;
    _tabView.delegate = self;
    [self.view addSubview:_tabView];
    self.view.backgroundColor =[UIColor colorWithRed:250/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1 ];
    
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dayDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.创建自定制cell
    SHMeetingModel *model = nil;
    
    SHMeetingDCell  *cell = [SHMeetingDCell cellWithTableView:tableView];
    //2.给cell设置要显示的数据
    
    model = _dayDatas[indexPath.row];
    
    [cell setModel:model];
    cell.backgroundColor =[UIColor whiteColor];
    
    if (MainR.size.width<414) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      
    }
    else
    {
        
        
        
            UIImageView *jiantouI = [[UIImageView alloc] initWithFrame:CGRectMake(MainR.size.width-60, 35, 20,20 )];
            jiantouI.image =[UIImage imageNamed:@"jiant"];
            [cell.contentView addSubview:jiantouI];
    
    }
     UIView *line= [[UIView alloc]initWithFrame:CGRectMake(0, 89, MainR.size.width, 1)];
    line.backgroundColor =RGB(238.0, 238.0, 238.0);
    [cell.contentView addSubview:line];
    
    return cell;

}
//设置cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    
//    
//    SHAgencyVController *meetD =[SHAgencyVController alloc] ;
//    SHMeetingModel *model = _dayDatas[indexPath.row];
//    meetD.dataS = model;
//        meetD.meetingId= model.meetingId;
    
    SHMeetingDetailVC *meetingDVC=[[SHMeetingDetailVC alloc] init];
        SHMeetingModel *model = _dayDatas[indexPath.row];
    meetingDVC.mDatas =model;
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:meetingDVC animated:YES];

}



@end
