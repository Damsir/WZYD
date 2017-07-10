//
//  announcementVC.m
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//.

#import "announcementVC.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "Global.h"
#import "FileViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UITableView+ReloadExten.h"
#import "AnnoTableViewCell.h"
#import "AnnoModel.h"
static const CGFloat AnimationDuration = 2.0;

@interface announcementVC ()

{
    NSMutableArray *_datasource;
    NSMutableArray *_searchSource;
    BOOL _isDropRefersh;
    BOOL _isTodo;
    NSInteger _selectedIndex;
    BOOL _projectDidRemoved;
    MJRefreshComponent *myRefreshView;
    
}
@property (nonatomic,strong)UISearchBar *searchB;
@property (strong, nonatomic)UIButton *searchBtn;
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation announcementVC

- (void)loadAnnounceData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"type":@"smartplan",@"action":@"notice",@"pageIndex":@"0",@"pageSize":@"100"};
    
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            NSArray *array =[rs objectForKey:@"result"];
            
            AnnoModel *annoModel ;
            NSMutableArray *mulA = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                annoModel =[AnnoModel  annoModelWithDict:dic];
                [mulA addObject:annoModel];
            }
            _datasource = [mulA copy];
            [self.announceTableView.header endRefreshing];
            
            [_announceTableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [myRefreshView endRefreshing];
        
        
    }];
    
}


- (void) dataReload
{
    [self.announceTableView reloadData];
    [myRefreshView endRefreshing];
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
//- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
//{
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return image;
//}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.view.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height-MENUHEIHT-49-20);
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-MENUHEIHT-49-20)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http:ghj.huaian.gov.cn/tzgg/wap/list.html"]]];
    webView.scrollView.bounces = NO;
    _webView = webView;
    [self.view addSubview:webView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    

    
    
    
    NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    NSLog(@"%@,%@",self.nav,self.tab);
    //加载数据
   // [self loadAnnounceData];
    //创建tableView
   // [self createTableView];
    //添加刷新控件
   // [self setupRefresh];
    //创建搜索条
   // [self createSearchBar];
    
    
}

-(void)screenRotation
{
    _webView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-MENUHEIHT-49-20);

}

//创建搜索条
- (void)createSearchBar
{
    //搜索栏
    UISearchBar *searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,44)];
    //设置输入颜色
    searchBar.tintColor = [UIColor blackColor];
    UIImage *image =[self imageWithColor:[UIColor whiteColor]];
    //设置搜索框的背景图片
    [searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    //设置背景颜色
    [searchBar setBarTintColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    searchBar.delegate =  self;
    _searchB = searchBar;
    
}

//创建tabelView
- (void)createTableView
{
    UITableView *announce =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-49-20-MENUHEIHT) style:UITableViewStylePlain];
    
    announce.separatorStyle = UITableViewCellSeparatorStyleNone;
    announce.backgroundColor = [UIColor lightGrayColor];
    _announceTableView =announce;
    
    _announceTableView.dataSource= self;
    _announceTableView.delegate =self;
    _announceTableView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_announceTableView];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AnnoTableViewCell *annoCell ;
    
    if (!annoCell) {
        annoCell =[AnnoTableViewCell cellWithTableView:tableView];
        annoCell.backgroundColor =RGB(250.0, 250.0, 250.0);
    }
    
    annoCell.annoModel = [_datasource objectAtIndex:indexPath.row];
    return annoCell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationItem setTitle:@"返回"];
    _selectedIndex = indexPath.row;
    AnnoModel *annoModel = _datasource[indexPath.row];
    //    AnnoModel *annoModel = _datasource[2];
    NSLog(@"%@",annoModel);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AnnouncementDetailVC *annou=[[AnnouncementDetailVC alloc] init];
    [annou tranNav:self.nav andTabBar:self.tab];
    annou.anModel =annoModel;
    [self.nav pushViewController:annou animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    //..下拉刷新
    _announceTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        page = 0;
        myRefreshView = _announceTableView.header;
        [self headerRereshing];
    }];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _isDropRefersh = YES;
    [self loadAnnounceData];
}

-(void)removeSelectedRow{
    [_datasource removeObjectAtIndex:_selectedIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [self.announceTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
}


@end
