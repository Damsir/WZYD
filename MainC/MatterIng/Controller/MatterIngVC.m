//
//  MatterIngVC.m
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MatterIngVC.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "DejalActivityView.h"
#import "Global.h"
#import "SPViewController.h"
#import "MBProgressHUD+MJ.h"
#import "matterModel.h"
#import "matterCell.h"
#import "MatterDetailVC.h"
@interface MatterIngVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isDropRefersh;
    BOOL _isTodo;
    NSInteger _selectedIndex;
    BOOL _projectDidRemoved;
    MJRefreshComponent *myRefreshView;
}
@property (nonatomic,strong) NSMutableArray *datasource;
@property (nonatomic,strong) NSMutableArray *searchSource;
@property (nonatomic,strong)UISearchBar *searchBar;
@property (strong, nonatomic)UIButton *searchBtn;
@property (strong, nonatomic)CAShapeLayer *shapeCircle;


@end
@implementation MatterIngVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
}

- (void)loadMatterData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"type":@"smartplan",@"action":@"getofficalList"};
    
    //    [MBProgressHUD showMessage:@"正在加载Matt"];
    
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.matterTableView.header endRefreshing];
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            matterModel *mModel;
            NSMutableArray *mulA =[NSMutableArray array];
            NSArray *array=[rs objectForKey:@"result"];
            for (NSDictionary *dict in array) {
                mModel=[matterModel matterWithDict:dict];
                [mulA addObject:mModel];
            }
            _datasource= [mulA copy];
            [_matterTableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.matterTableView.header endRefreshing];
        
    }];
}

- (void) dataReload
{
    [self.matterTableView reloadData];
    //    [self.matterTableView headerEndRefreshing];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建导航栏
    self.view.backgroundColor =[UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    self.view.backgroundColor=[UIColor whiteColor];
    //创建tableView
    [self createTableView];
    //添加下拉刷新
    [self setupRefresh];
    //加载数据
    [self loadMatterData];
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatSearchBar) name:@"searchBtnClick0" object:nil];
    //搜索栏
//    UISearchBar *searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,44)];
//    searchBar.delegate =  self;
//    _searchBar = searchBar;
    [self createSearchBar];
    
}

//创建搜索栏
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
    _searchBar = searchBar;
    
    
    
}

//创建tabelView
- (void)createTableView
{
    UITableView *matterTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-44-MENUHEIHT) style:UITableViewStylePlain];
    
    matterTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    matterTable.dataSource= self;
    matterTable.delegate =self;
    
    matterTable.backgroundColor =[UIColor whiteColor];
    _matterTableView =matterTable;
    [self.view addSubview:_matterTableView];
    
}
- (void)creatSearchBar
{
    _searchBar.hidden =  NO;
    [self.view addSubview:_searchBar];
    _matterTableView.frame =CGRectMake(0, 44, MainR.size.width, MainR.size.height);
    [_searchBar becomeFirstResponder];
    
}
// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
    _searchBar.hidden = YES;
    _matterTableView.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    mode = 0;
    [self dataReload];
}
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"---%@",searchBar.text);
    [_searchBar resignFirstResponder];// 放弃第一响应者
    mode = 1;
    [self doSearch:searchBar.text];
    [self dataReload];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self changeCancel];//改cancel为取消
}
-(void) changeCancel{
    for(id subView in [_searchBar.subviews[0] subviews]){
        if([subView isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)subView;
            [btn setTitle:@"取消"forState:UIControlStateNormal];
        }
    }
}

//有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    NSLog(@"textDidChange---%@",searchBar.text);
    [self doSearch:searchBar.text];
}

- (void)doSearch:(NSString*) targetText {
    
    NSString *title;
    NSString *date;
    matterModel *mModel;
    _searchSource = [[NSMutableArray alloc]initWithCapacity:1];
    for(int i=0;i<_datasource.count;i++)
    {
        mModel = [_datasource objectAtIndex:i];
        title = mModel.maintitle;
        date =mModel.publishtime;
        NSRange range1 = [title rangeOfString:targetText];
        NSRange range2 = [date rangeOfString:targetText];
        if(range1.location != NSNotFound)
        {
            [_searchSource addObject:mModel];
            continue;
        }
        else
        {
            if(range2.location != NSNotFound)
            {
                [_searchSource addObject:mModel];
            }
        }
    }
}


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
    matterCell *mCell;
    matterModel *mModel;
    if (mCell==nil) {
        mCell =[matterCell CellWithTableView:tableView];
    }
    
    
    if(mode == 1)
    {
        mModel = [_searchSource objectAtIndex:indexPath.row];
        
    }
    else
    {
        mModel = [_datasource objectAtIndex:indexPath.row];
        
    }
    mCell.matterModel = mModel;
    mCell.tag=indexPath.row;
    return mCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationItem setTitle:@"返回"];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    [backItem setBackgroundImage:[UIImage imageNamed:@"op.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    backItem.tintColor=[UIColor redColor];
    self.nav.navigationItem.backBarButtonItem = backItem;
    _selectedIndex = indexPath.row;
    
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    switch (3) {
        case 0:
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
            break;
        case 1:
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
            break;
        case 2:
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
            break;
        case 3:
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
            break;
        default:
            break;
    }
    
    [UIView commitAnimations];
        if(mode == 1)//搜索
        {
    
            MatterDetailVC *matterDetail =[[MatterDetailVC alloc] init];
            matterDetail.matModel=[_searchSource objectAtIndex:indexPath.row];
            [self.nav pushViewController:matterDetail animated:YES];
    
        }
        else//正常
        {
    
            MatterDetailVC *matterDetail =[[MatterDetailVC alloc] init];
            matterDetail.matModel =[_datasource objectAtIndex:indexPath.row];
            [self.nav pushViewController:matterDetail animated:YES];
       
        }

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
    _matterTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        page = 0;
        myRefreshView = _matterTableView.header;
        [self headerReresh];
    }];
    
}

#pragma mark 开始进入刷新状态
- (void)headerReresh
{
    _isDropRefersh = YES;
    [self loadMatterData];
}

-(void)removeSelectedRow{
    [_datasource removeObjectAtIndex:_selectedIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [self.matterTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                withRowAnimation:UITableViewRowAnimationFade];
}


@end
