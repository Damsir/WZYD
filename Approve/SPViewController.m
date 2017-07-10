//
//  GWViewController.m
//  XAYD
//
//  Created by dist on 15/8/3.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SPViewController.h"
//#import "BusinessViewController.h"
//#import "EncyclicViewController.h"
#import "AFHTTPRequestOperationManager.h"
//#import "MainTodoTableViewCell.h"
//#import "MeetingViewController.h"
#import "SPDetailVC.h"
#import "Global.h"

@interface SPViewController ()<UINavigationControllerDelegate>
{
    
    
    SPDetailVC *_zbView;
    SPDetailVC *_ybView;
    SPDetailVC *_dbView;
    int _zbCount;
    int _ybCount;
    int _dbCount;
    BOOL _dataLoaded;
}

@end

@implementation SPViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
    [self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleDefault;
    [self loadCountInfo];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationItem.title=@"审批";
    self.tabBarItem.title = @"审批";
    self.keys=@[@"在办箱",@"已办箱",@"督办箱"];
    self.imgArr=@[@"iconfont-zaiban",@"iconfont-yiban",@"iconfont-duban"];
    self.dic=[[NSDictionary alloc] initWithObjects:@[@"0",@"0",@"0"] forKeys:self.keys];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor= [UIColor clearColor];
   
}

-(void)loadCountInfo{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"user":[Global userId],@"type":@"smartplan",@"action":@"count"};
    
    NSLog(@"%@?user=%@&type=smartplan&action=count",[Global serverAddress],[Global myuserId]);
    
    if(!_dataLoaded)
        //加载数据
        [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rs = (NSDictionary *)responseObject;
            if ([[rs objectForKey:@"success"] isEqualToString:@"true"])
            {
                NSArray *data = [rs objectForKey:@"result"];
                _zbCount = [[data objectAtIndex:0] intValue];
                _ybCount = [[data objectAtIndex:1] intValue];
                _dbCount = [[data objectAtIndex:2] intValue];
//                _toReadCount = [[data objectAtIndex:3] intValue];
            }
            [self refreshTable];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
         }];
}

-(void)refreshTable{
    self.dic=[[NSDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"%d",_zbCount],[NSString stringWithFormat:@"%d",_ybCount],[NSString stringWithFormat:@"%d",_dbCount]] forKeys:self.keys];
    [self.myTableView reloadData];
}

#pragma -mark  UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //分类个数
    return self.dic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier=@"SPCell";
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    NSString *name,*count;
    name=[self.keys objectAtIndex:indexPath.row];
    count=[self.dic objectForKey:name];
    if ([count isEqualToString:@"0"]) {
        count=@"";
    }
    cell.textLabel.text=name;
    cell.imageView.image=[UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text=count;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor =[UIColor clearColor];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//返回头部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 20;
            break;
        case 1:
            return 40;
            break;
        default:
            break;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        _dataLoaded = YES;
        if (indexPath.row==0) {
            
            if(nil == _zbView){
                _zbView = [[SPDetailVC alloc]init];
            }
            
            [self.navigationController pushViewController:_zbView animated:YES];
            _zbView.docProperty  = @"在办箱";
        }
        else if(indexPath.row==1){
            if(nil==_ybView){
                _ybView = [[SPDetailVC alloc] init];
                _ybView.docProperty = @"已办箱";
            }
            [self.navigationController pushViewController:_ybView animated:YES];
        }
        else if(indexPath.row==2){
            if(nil==_dbView){
                _dbView = [[SPDetailVC alloc] init];
            }
            [self.navigationController pushViewController:_dbView animated:YES];
            _dbView.docProperty = @"督办箱";
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
