//
//  MailDraftViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MailDraftViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MailCell.h"
#import "MailModel.h"
#import "MailDetailViewController.h"

@interface MailDraftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageSize;

@end

@implementation MailDraftViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _pageSize = 20;
    _dataArray = [NSMutableArray array];
    
    [self createTableViewAndNaviSearchBar];
    [self loadData];
    
    // 监听发送,回复成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"sendMailSuccess" object:nil];
    // 监听保存草稿成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"saveDraftSuccess" object:nil];
}

-(void)refresh:(NSNotification *)noty
{
    [_dataArray removeAllObjects];
    [self loadData];
}

//屏幕旋转改变视图的Frame
-(void)screenRotation
{
    self.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-HeaderHeight-113);
    [self.tableView reloadData];
}

#pragma mark -- 创建 tableView && SearchBar
-(void)createTableViewAndNaviSearchBar
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-HeaderHeight-113) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"MailCell" bundle:nil] forCellReuseIdentifier:@"MailCell"];
    [self.view addSubview:tableView];
    
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        //_pageSize = 20;
        [self loadData];
    }];
    // 上拉加载更多
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/MailList.ashx"];
    NSDictionary *paremeters = @{@"type":@"drafts",@"index":@"0",@"size":[NSString stringWithFormat:@"%ld",(long)_pageSize],@"user":[Global userName],@"me":@"1",@"uid":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = [responseObject objectForKey:@"result"];
        for (NSDictionary *dic in arr)
        {
            MailModel *model = [[MailModel alloc] initWithDictionary:dic];
            [_dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        
        // 暂无数据
        _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
        
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
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
    MailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailCell"];
    if(_dataArray.count > indexPath.row)
    {
        MailModel *model = _dataArray[indexPath.row];
        cell.title.text = model.EmailTile;
        cell.user.text = model.sendUser;
        cell.time.text = model.reciveTime;
    }
    if (indexPath.row == 0)
    {
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
        line.backgroundColor = GRAYCOLOR;
        //[cell.contentView addSubview:line];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailDetailViewController *mailDetailVC = [[MailDetailViewController alloc] init];
    mailDetailVC.mailModel = _dataArray[indexPath.row];
    mailDetailVC.mailType = @"mailDraft";
    mailDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.nav pushViewController:mailDetailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end