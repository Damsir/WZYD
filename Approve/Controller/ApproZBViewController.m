
//
//  ApproZBViewController.m
//  XAYD
//
//  Created by songdan Ye on 16/4/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ApproZBViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "PDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "SHPushVCAnimation.h"
#import "SPDetailCell.h"
#import "SPDetailModel.h"
#import "UITableView+ReloadExten.h"
#import "BaseMessageVC.h"
static const CGFloat AnimationDuration = 2.0;
@interface ApproZBViewController ()<SendViewDelegate>
{
    BOOL _isDropRefersh;//下拉刷新
    NSInteger _selectedIndex;
    UISearchBar *gwSearchBar;
}

@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageCount;

//搜素关键字
@property (nonatomic,strong)NSString *searchKey;
@property (nonatomic,strong)SPDetailCell *cell;
@property (nonatomic,strong)PDetailViewController *pDetail;
@property (nonatomic,strong)BaseMessageVC *baseMessage;
@property (nonatomic,strong)NSMutableArray *searchSource;

@property (nonatomic,strong)NSMutableArray *datasource;
@property (nonatomic,strong)NSString *searchString;

//发送成功后修改其值,用该值来确定是否需要需要移除该行cell
@property (nonatomic,assign,getter = isProjectDidRemoved) BOOL projectDidRemoved;
@end


@implementation ApproZBViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tabBarController.tabBar.hidden = YES;
  
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 35);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page= @"0";
    _pageCount = @"20";
    _datasource =[NSMutableArray array];
    //设置返回按钮的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
       //创建tableView
    [self createTableView];
    //加载数据
    [self loadData];
    //监听搜索按钮被点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searching:) name:@"seacrchAction0" object:nil];
  
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMattering" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"updateMattering" object:nil];
    //监听取消按钮被点击
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelClicked) name:@"searchCancelClicked" object:nil];
    
    //监听屏幕旋转的通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation
{
    self.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-HeaderHeight-113);
    [self.tableView reloadData];
}

- (void)changeSelectedButton:(NSNotification *)text
{
    NSLog(@"sBar:%@",_searchString);
    
}
- (void) searching:(NSNotification *)text
{
    mode = 1;
    _searchString =text.userInfo[@"open0"];
    [self loadData];

}

- (void)createTableView
{
    UITableView *spTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-113-HeaderHeight) style:UITableViewStylePlain];
    spTableView.delegate =self;
    spTableView.dataSource = self;
    spTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView = spTableView;
    //
    [self.view addSubview:self.tableView];
    
    //..下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = @"0";
        [self loadData];
    }];
    //..上拉刷新
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageCount = [NSString stringWithFormat:@"%d",[_pageCount intValue] + 30];
        
        [self loadData];
        
    }];
}

- (void)cancelClicked
{
    if (mode == 1) {//如果是搜索状态,即设置为正常状态
        mode =0;
        self.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
        gwSearchBar.text =nil;
        [self.tableView reloadData];

    }
}

-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters;
    
    //如果为正常模式
    if (mode==0) {
        gwSearchBar.text =nil;
        self.searchString = @"";
    }
    
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/project/ProjectList.ashx"];
    parameters = @{@"type":@"1",@"index":_page,@"size":_pageCount,@"uid":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"ZB%@",requestAddress);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *rs = (NSDictionary *)responseObject;
//        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            NSArray *td= [rs objectForKey:@"result"];
            SPDetailModel *spModel;
            NSMutableArray *mulArr =[NSMutableArray array];
            for (NSDictionary *dict in td) {
                spModel = [SPDetailModel spDetailModelWithDict:dict];
                [mulArr addObject:spModel];
            }
            if(mode==0)
            {
                _datasource = mulArr;
                // 暂无数据
                _datasource.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
            }
            else if (mode==1)//搜索
            {
                _searchSource = mulArr;
                // 暂无数据
                _searchSource.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
                
            }
//                   }
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];


        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];

        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];

    }];
}


#pragma -mark  UITableViewDataSource,UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(mode == 1)//搜索
    {
        return _searchSource.count;
    }
    
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPDetailCell *cell;
    
    if (cell==nil) {
        cell=[SPDetailCell cellWithTableView:tableView];
    }
    if(mode == 1)
    {
        cell.spDetailmodel = [_searchSource objectAtIndex:indexPath.row];
    }
    else
    {
        cell.spDetailmodel= [_datasource objectAtIndex:indexPath.row];
        cell.imageState.image = [UIImage imageNamed:@"wenjian_spp"];
    }
    if (MainR.size.width>414) {
        cell.iconImageLC.constant =10;
        cell.flowLeftTimeRC.constant = 15;
    }
    
    if (indexPath.row ==0) {
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        [cell.contentView addSubview:line];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationItem setTitle:@"返回"];
    _selectedIndex = indexPath.row;
    
    PDetailViewController *pDetail = [[PDetailViewController alloc] init];
    pDetail.spOrgw = @"sp";
    //提前初始化basemessage(为了设置代理为SPDetailVC)
    BaseMessageVC  *baseMess=[[BaseMessageVC alloc] init];
    baseMess.sendDelegate =self;
    baseMess.Id = @"ZB";
    _baseMessage = baseMess;
    _pDetail =pDetail;
    pDetail.baseMessage = _baseMessage;
    
    SPDetailModel *model;
    if(mode == 0)
    {
        model =[_datasource objectAtIndex:indexPath.row];
    }
    else
    {
        
        model = [_searchSource objectAtIndex:indexPath.row];
        
    }
    
    
    [pDetail setModel:model];
    [SHPushVCAnimation addAnimationOnView:self.view animation:SHAnimationTypeFade direction:SHAnimationTypeMoveIn duration:0.5];
    [self.nav pushViewController:pDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//移除选定cell
-(void)removeSelectedRow{
    
    if (mode==1) {
        [_searchSource removeObjectAtIndex:_selectedIndex];
    }
    else
    {
    
    [_datasource removeObjectAtIndex:_selectedIndex];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    //[self.spDetailTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

-(void)sendViewDidSendCompleted
{
    [MBProgressHUD showSuccess:@"发送成功"];

    [self.nav popToViewController:[self.nav.viewControllers objectAtIndex:0] animated:YES];
    [self removeSelectedRow];

}




@end
