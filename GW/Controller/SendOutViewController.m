//
//  SendOutViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/26.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SendOutViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "PDetailViewController.h"
#import "BaseMessageVC.h"
#import "SendViewController.h"
#import "SPDetailCell.h"
#import "SPDetailModel.h"

@interface SendOutViewController ()<UITableViewDelegate,UITableViewDataSource,SendViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,strong) PDetailViewController *pDetail;
@property(nonatomic,strong) BaseMessageVC *baseMessage;

@end

@implementation SendOutViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _pageSize = 20;
    _dataArray = [NSMutableArray array];
    
    [self createTableView];
    [self loadData];
}

-(void)screenRotation
{
    self.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-49-HeaderHeight);
    [self.tableView reloadData];
}

#pragma mark -- 创建 tableView
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-49-HeaderHeight) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"SPDetailCell" bundle:nil] forCellReuseIdentifier:@"SPDetailCell"];
    [self.view addSubview:tableView];
    
    //下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        //_pageSize = 20;
        [self loadData];
    }];
    //上拉加载更多
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        _pageSize += 20;
        [self loadData];
    }];
    
}

-(void)loadData
{
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //http://61.153.29.236:8891/mobileService/service/gw/GwList.ashx?type=sw&index=0&size=20&user=王任&me=1&uid=996&deviceNumber=c9e9163d-5619-3b91-af06-34cb890c496f&username=王任
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/gw/GwList.ashx"];
    NSDictionary *paremeters = @{@"type":@"fw",@"index":@"0",@"size":[NSString stringWithFormat:@"%ld",(long)_pageSize],@"user":[Global userName],@"me":@"1",@"uid":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager GET:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = [responseObject objectForKey:@"result"];
        for (NSDictionary *dic in arr)
        {
            SPDetailModel *model = [[SPDetailModel alloc] initWithDict:dic];
            [_dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        
        // 暂无数据
        _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
    
}

#pragma -mark  UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPDetailCell"];
    
    if(_dataArray.count > indexPath.row)
    {
        cell.spDetailmodel = [_dataArray objectAtIndex:indexPath.row];
        cell.imageState.image = [UIImage imageNamed:@"wenjian_gww"];

        if (indexPath.row == 0)
        {
            UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
            line.backgroundColor = RGB(238.0, 238.0, 238.0);
            //[cell.contentView addSubview:line];
        }
        
    }
    
    if (MainR.size.width > 414)
    {
        cell.iconImageLC.constant =10;
        cell.flowLeftTimeRC.constant = 15;
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    
    PDetailViewController *pDetail = [[PDetailViewController alloc] init];
    pDetail.spOrgw = @"gw";
    //提前初始化basemessage(为了设置代理为SPDetailVC)
    BaseMessageVC  *baseMess = [[BaseMessageVC alloc] init];
    baseMess.sendDelegate = self;
    baseMess.spOrgw = @"gw";
    baseMess.Id = @"gwfw";
    _baseMessage = baseMess;
    _pDetail =pDetail;
    pDetail.baseMessage = _baseMessage;
    
    SPDetailModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [pDetail setModel:model];
    
    
    [self.nav pushViewController:pDetail animated:YES];
    
}

#pragma mark -- sendViewControllerDelegate
-(void)sendViewDidSendCompleted
{
    [MBProgressHUD showSuccess:@"发送成功"];
    [self.nav popToViewController:[self.nav.viewControllers objectAtIndex:0] animated:YES];
    [self removeSelectedRow];
}
//移除选定cell
-(void)removeSelectedRow
{
    [_dataArray removeObjectAtIndex:_selectedIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
