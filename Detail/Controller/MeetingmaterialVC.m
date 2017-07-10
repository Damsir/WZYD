//
//  MeetingmaterialVC.m
//  XAYD
//
//  Created by songdan Ye on 16/5/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingmaterialVC.h"
#import "AFNetworking.h"
#import "PTreeHeaderFooterView.h"
#import "SPDetailModel.h"
#import "Global.h"
#import "MaterialModel.h"
#import "MBProgressHUD+MJ.h"
#import "materialListCell.h"
#import "MaterialItems.h"
#import "FileViewController.h"

@interface MeetingmaterialVC ()<UIScrollViewDelegate,PTreeHeaderFooterViewDelegate>

@end

@implementation MeetingmaterialVC
-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"smartplan";
    params[@"action"]=@"materials";
    params[@"slbh"]=@"XZ2016046";
    self.datasource =[NSArray array];
    [manager POST:[Global serverAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            NSArray *td= [rs objectForKey:@"result"];
            MaterialModel *mModel;
            NSMutableArray *mulArr =[NSMutableArray array];
            for (NSDictionary *dict in td) {
                mModel = [MaterialModel materialWithDict:dict];
                [mulArr addObject:mModel];
            }
            self.datasource = [mulArr copy];
            [self.tableView reloadData];
            NSLog(@"%@",self.datasource);
            //   [myRefresh endRefreshing];
            
        }else{
            
            
            //            [myRefresh endRefreshing];
        }
        //        [_spDetailTableView reloadData];
        //设置下次取消下拉刷新
        //        _isDropRefersh = NO;
        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        //        [myRefresh endRefreshing];
        //        _isDropRefersh = NO;
        
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.nav.navigationBar.hidden = NO;
    
    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    self.tableView.frame = CGRectMake(0, 64+37, MainR.size.width, MainR.size.height-64-37);
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-37) style:UITableViewStylePlain];
    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 50;
    
    [self.view addSubview:_tableView];
    
}


#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    MaterialModel *model= [_datasource objectAtIndex:section];
//    NSInteger counts =model.files.count;
//    NSInteger countss = !model.isOpened ? counts: 0;
//    return  countss;
    return 1;
}

#pragma mark -tabelViewDelge代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PTreeHeaderFooterView *headerView = [PTreeHeaderFooterView pTreeHeaderWithTableView:tableView fileTypeImageName:@"fileicon"];
    
    headerView.delegate =self;
    headerView.mModel = (MaterialModel *)_datasource[section];
    
    
    return headerView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger count =self.datasource.count;
    return  count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建自定制cell
    materialListCell *cell =[materialListCell cellWithTableView:tableView];
//    MaterialModel *mModel =[_datasource objectAtIndex:indexPath.section];
//    NSArray *tmp =mModel.files;
//    
//    MaterialItems *mDetailModel = [tmp objectAtIndex:indexPath.row];
//    [cell setMaterialDetailModel:mDetailModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileViewController *fvc = [[FileViewController alloc] init];
    //    fvc.fileViewDelegate = self;
    
    
//    MaterialModel *model = (MaterialModel *)[_datasource objectAtIndex:indexPath.section];
//    MaterialItems *mDetailModel=[model.files objectAtIndex:indexPath.row];
//    NSString *fileId = [NSString stringWithFormat:@"%@_%@",model.instanceid,mDetailModel.identity];
//    NSString *downloadUrl = [NSString stringWithFormat:@"%@?type=smartplan&action=downloadmaterial&fileId=%@",[Global serverAddress],mDetailModel.identity];
//    
//    
//    [fvc openFile:fileId url:downloadUrl ext:mDetailModel.ext];
//    
//    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
//    {
//        
//        [self.nav pushViewController:fvc animated:YES];
//        
//        
//        
//    }
//    else
//    {
//        [self presentViewController:fvc animated:YES completion:nil];
//        
//    }
    
    //    [self.nav pushViewController:fvc animated:YES];
    
    
}


#pragma mark-PTreeHeaderFooterView代理方法

- (void)clickHeaderView
{
    [self.tableView reloadData];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
