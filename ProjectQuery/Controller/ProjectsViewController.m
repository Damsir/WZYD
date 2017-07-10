//
//  ProjectsViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ProjectsViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "QueryCell.h"
#import "SPDetailModel.h"
#import "PDetailViewController.h"
#import "BaseMessageVC.h"
#import "SendViewController.h"
#import "SearchViewController.h"

@interface ProjectsViewController ()<UITableViewDelegate,UITableViewDataSource,SendViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,strong) PDetailViewController *pDetail;
@property(nonatomic,strong) BaseMessageVC *baseMessage;
@property(nonatomic,strong) NSString *name;//项目名称
@property(nonatomic,strong) NSString *company;//建设单位
@property(nonatomic,strong) NSString *address;//建设地址
@property(nonatomic,strong) NSString *zhengNo;//证书编号;


@end

@implementation ProjectsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"项目列表";
    [self initNavigationBarTitle:@"项目列表"];
    
    _pageSize = 20;
    
    if (_searchInfoDic) {
        _name = [_searchInfoDic objectForKey:@"name"];
        _company = [_searchInfoDic objectForKey:@"company"];
        _address = [_searchInfoDic objectForKey:@"address"];
        _zhengNo = [_searchInfoDic objectForKey:@"zhengNo"];
    }else{
        _name = @"";
        _company = @"";
        _address = @"";
        _zhengNo = @"";
    }
    _dataArray = [NSMutableArray array];
    
    [self createTableViewAndNaviSearchBar];
    [self loadData];
    
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    self.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
    [self.tableView reloadData];
}

#pragma mark -- 创建 tableView && SearchBar
-(void)createTableViewAndNaviSearchBar
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"QueryCell" bundle:nil] forCellReuseIdentifier:@"QueryCell"];
    [self.view addSubview:tableView];
    [tableView.header beginRefreshing];
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
    

//    UIButton *searchBtn = [self createButtonWithImage:@"searchIcon" andTitle:@"搜索" andFrame:CGRectMake(0, 0, 80, 30) andTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchOnclick)];
    
}

-(void)loadData
{
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/project/Project.ashx"];
    NSString *businessname = @"";
    if (_childModel){
        businessname = _childModel.bizzName;
    }else{
        businessname = @"";
    }
    NSDictionary *paremeters = @{@"userID":[Global userId],@"pageIndex":@"0",@"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageSize],@"businessname":businessname,@"projName":_name,@"buildOrg":_company,@"buildAddr":_address,@"zhengNo":_zhengNo,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [JsonDic objectForKey:@"result"];
        for (NSDictionary *dic in arr)
        {
            SPDetailModel *model = [[SPDetailModel alloc] initWithDict:dic];
            if (![model.projName isEqualToString:@""]) {
                [_dataArray addObject:model];
            }
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
    QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell"];
    if(_dataArray.count > indexPath.row)
    {
        SPDetailModel *model = _dataArray[indexPath.row];
        cell.title.text = model.projName;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count > indexPath.row)
    {
        CGFloat cellHeight = [self GetCellHeightWithContent:[_dataArray[indexPath.row] projName]];
        if (cellHeight > 44.0)
        {
            return cellHeight;
        }
        
    }
    return 44.0;
}

-(CGFloat)GetCellHeightWithContent:(NSString *)content
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MainR.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil];
    return rect.size.height + 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;

    PDetailViewController *pDetail = [[PDetailViewController alloc] init];
    pDetail.spOrgw = @"sp";
    //提前初始化basemessage(为了设置代理为SPDetailVC)
    BaseMessageVC  *baseMess = [[BaseMessageVC alloc] init];
    baseMess.sendDelegate = self;
    baseMess.Id = @"xmcx";
    _baseMessage = baseMess;
    _pDetail =pDetail;
    pDetail.baseMessage = _baseMessage;
    
    SPDetailModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [pDetail setModel:model];
    
    
    [self.navigationController pushViewController:pDetail animated:YES];

}

// customButton
-(UIButton *)createButtonWithImage:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame andTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BLUECOLOR;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInsets];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 50)];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.highlighted = NO;
    button.adjustsImageWhenHighlighted = NO;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(searchOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 查询
-(void)searchOnclick
{
//    SearchViewController *searchVC = [[SearchViewController alloc] init];
//    searchVC.SearchBlock = ^(NSDictionary *searchInfoDic)
//    {
//        _name = [searchInfoDic objectForKey:@"name"];
//        _company = [searchInfoDic objectForKey:@"company"];
//        _address = [searchInfoDic objectForKey:@"address"];
//        //刷新数据
//        [_dataArray removeAllObjects];
//        _pageSize = 20;
//        [self loadData];
//    };
    
//    [self.navigationController popViewControllerAnimated:YES];
}



-(void)sendViewDidSendCompleted
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
