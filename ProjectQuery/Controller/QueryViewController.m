//
//  QueryViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "QueryViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "QueryCell.h"
#import "QueryModel.h"
#import "ProjectsViewController.h"
#import "SearchViewController.h"


@interface QueryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation QueryViewController

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
    //self.navigationItem.title = @"业务类型";
    [self initNavigationBarTitle:@"业务类型"];
    
    
    [self createTableViewAndNaviSearchBar];
    [self loadData];
    
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
    [_tableView reloadData];
}

#pragma mark -- 创建 tableView && SearchBar
-(void)createTableViewAndNaviSearchBar
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"QueryCell" bundle:nil] forCellReuseIdentifier:@"QueryCell"];
    [self.view addSubview:tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchOnclick)];
    
}

// 查询
-(void)searchOnclick
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)loadData
{
    _dataArray = [NSMutableArray array];
    
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"json/Businesses.json"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
        NSArray *arr = [responseObject objectForKey:@"result"];
        for (NSDictionary *dic in arr)
        {
            QueryModel *model = [[QueryModel alloc] initWithDictionary:dic];
            [_dataArray addObject:model];
        }
        
        [_tableView reloadData];
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];

    
}

#pragma -mark  UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray[section] child] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell"];
    
    QueryModel *model = _dataArray[indexPath.section];
    ChildModel *child = model.child[indexPath.row];
    cell.title.text = child.bizzName;

 
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainR.size.width, 35)];
    headerView.backgroundColor = BLUECOLOR;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainR.size.width-60, 35)];
    lab.textColor = [UIColor whiteColor];
    lab.text = [_dataArray[section] groupName];

    [headerView addSubview:lab];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectsViewController *projestsVC = [[ProjectsViewController alloc] init];
    
    QueryModel *model = _dataArray[indexPath.section];
    ChildModel *child = model.child[indexPath.row];
    projestsVC.childModel = child;
    
    projestsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:projestsVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
