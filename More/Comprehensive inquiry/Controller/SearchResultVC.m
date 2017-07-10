//
//  SearchResultVC.m
//  XAYD
//
//  Created by songdan Ye on 16/4/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SearchResultVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "SPDetailCell.h"
#import "ComprehensiveModel.h"
#import "PDetailViewController.h"
#import "MJExtension.h"

@interface SearchResultVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *pageIndex;

@property (nonatomic,strong)NSString *pageSize;

@end

@implementation SearchResultVC
- (NSMutableArray *)dataSourceArray
{
    if (_dataSourceArray==nil) {
        _dataSourceArray =[NSMutableArray array];
    }
    return _dataSourceArray;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self searchAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = @"0";
    _pageSize = @"20";
    [self initTableView];

    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)screenRotation
{
    self.tableView.frame = CGRectMake(0,0, MainR.size.width,MainR.size.height-15);
    
}
-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, MainR.size.width,MainR.size.height-15) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //..下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _pageIndex = @"0";
        [self searchAction];
    }];
    
    //..上拉加载更多
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageSize = [NSString stringWithFormat:@"%d",[_pageSize intValue] + 20];
        [self searchAction];
        
    }];
}

- (void)searchAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    //NSDictionary *parameters = @{@"type":@"smartplan",@"action":@"queryproject",@"pagesize":@"20",@"pageindex":@"0",@"querystring":@"",@"queryjson":self.quryStr};
    NSDictionary *parameters = @{@"pageindex":_pageIndex,@"querystring":@"",@"queryjson":_quryStr,@"type":@"smartplan",@"pagesize":_pageSize,@"action":@"queryproject"};
    
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"高级查询%@",requestAddress);
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
//[Global serverAddress]
    NSString *url =@"http://192.168.2.217/server";
    [manager POST:[Global serverAddress]
 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ComprehensiveModel *spModel;
        NSMutableArray *mulA=[NSMutableArray array];
        
        spModel =[[ComprehensiveModel alloc] mj_setKeyValues:operation.responseString];
        
        if ([spModel.success isEqualToString:@"true"])
        {
            for (searchResultModel *model in spModel.result)
            {
                
                [mulA addObject:model];
                
            }
            
            _dataSourceArray =[mulA copy];
            
            [self.tableView reloadData];
        }
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _dataSourceArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPDetailCell *spCell ;
    if (spCell==nil) {
        spCell =[SPDetailCell cellWithTableView:tableView];
    }
    spCell.comModel =[_dataSourceArray objectAtIndex:indexPath.row];
    
    return spCell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PDetailViewController *pDetail = [[PDetailViewController alloc] init];
    //提前初始化basemessage(为了设置代理为SPDetailVC)
    BaseMessageVC  *baseMess=[[BaseMessageVC alloc] init];
    
    pDetail.baseMessage = baseMess;
    
    searchResultModel *model;
    
    model =[_dataSourceArray objectAtIndex:indexPath.row];
    
    [pDetail setCompreModel:model];
    
    [self.navigationController pushViewController:pDetail animated:YES];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
