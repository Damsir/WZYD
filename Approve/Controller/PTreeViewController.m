//
//  PTreeViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "PTreeViewController.h"
#import "FileTableVCell.h"
#import "SPDetailModel.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MBProgressHUD+MJ.h"
#import "PTreeModel.h"
#import "PTreeHeaderFooterView.h"
#import "PTreeItems.h"

@interface PTreeViewController ()<PTreeHeaderFooterViewDelegate,UITableViewDataSource, UITableViewDelegate>

@end

@implementation PTreeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationItem.title = @"项目树";
    [self initNavigationBarTitle:@"项目树"];
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 50;
    
    [self.view addSubview:_tableView];
    
    [self loadTreeData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePtree) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
//屏幕旋转结束执行的方法
- (void)changePtree
{
    self.tableView.frame=CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
}

-(void)loadTreeData{
    
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/ProjectTreeHandler.ashx"];
    
    if (_isCompre) {
        params[@"projectId"]=_compreModel.slbh;
        
    }
    else
    {
        if (_model.ProjectId) {
            params[@"projectId"]=_model.ProjectId;
        }else{
            params[@"projectId"]=_model.Id;
        }
    }
    
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=params) {
        for (NSString *key in params.keyEnumerator) {
            NSString *val = [params objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"项目树%@",requestAddress);
    /*
     {
     "success": true,
     "result": [
     {
     "name": "瓯海区卧龙路（霞新路-高科路）燃气市政管设计方案(OH20150569)",
     "child": [
     {
     "id": "94394",
     "projectNo": "OH20150569",
     "projectCaseNo": "OHSZSJ20159",
     "name": "市政工程设计方案：2015-08-26[在办]"
     },
     {
     "id": "101741",
     "projectNo": "OH20150569",
     "projectCaseNo": "XXZXGX",
     "name": "地下管线处理上机流程：2016-03-24[在办]"
     },
     {
     "id": "99943",
     "projectNo": "OH20150569",
     "projectCaseNo": "XXZXGX",
     "name": "地下管线处理上机流程：2016-01-27[结案]"
     },
     {
     "id": "101062",
     "projectNo": "OH20150569",
     "projectCaseNo": "XXZXGX",
     "name": "地下管线处理上机流程：2016-03-07[结案]"
     }
     ]
     }
     ]
     }
     */
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        
        if ([[rs objectForKey:@"success"] isEqual:@1]) {
            NSArray *td= [rs objectForKey:@"result"];
            PTreeModel *pTreeModel;
            NSMutableArray *mulArr =[NSMutableArray array];
            for (NSDictionary *dict in td) {
                pTreeModel = [PTreeModel pTreeWithDict:dict];
                [mulArr addObject:pTreeModel];
            }
            self.datasource = [mulArr copy];
            [self.tableView reloadData];
            NSLog(@"%@",self.datasource);
            
        }
        else
        {
        }
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    }];
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PTreeModel *model= [_datasource objectAtIndex:section];
    NSInteger counts =model.items.count;
    NSInteger count = !model.isOpened ? counts: 0;
    return  count;
}

#pragma mark -tabelViewDelge代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PTreeHeaderFooterView *headerView = [PTreeHeaderFooterView pTreeHeaderWithTableView:tableView];
//                                                                      fileTypeImageName:@"iconfont-pinlei"];
    headerView.delegate =self;
    headerView.pTreeModel = _datasource[section];
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
    FileTableVCell *cell =[FileTableVCell cellWithTableView:tableView];
   PTreeModel *model =[_datasource objectAtIndex:indexPath.section];
    NSArray *tmp =model.items;
    PTreeItems *item = [tmp objectAtIndex:indexPath.row];
//    cell.fileImage.image = [UIImage imageNamed:@"iconfont-wenjianjia@2x"];
    [cell setItemModel:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    

    
}


#pragma mark-PTreeHeaderFooterView代理方法

- (void)clickHeaderView
{
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
