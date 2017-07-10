//
//  SPDetailVC.m
//  XAYD
//
//  Created by songdan Ye on 16/3/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SPDetailVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "PDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "SHPushVCAnimation.h"
#import "SPDetailCell.h"
#import "SPDetailModel.h"
#import "UITableView+ReloadExten.h"
#import "baseMessageVC.h"
static const CGFloat AnimationDuration = 2.0;

@interface SPDetailVC ()<SendViewDelegate>
{
//    NSMutableArray *_datasource;
    NSMutableArray *_searchSource;
    BOOL _isDropRefersh;//下拉刷新
    NSInteger _selectedIndex;
    UISearchBar *gwSearchBar;
    //MJRefreshComponent *myRefresh;
}

@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageCount;
@property (nonatomic,strong)NSString *page1;
@property (nonatomic,strong)NSString *pageCount1;
@property (nonatomic,strong)NSString *page2;
@property (nonatomic,strong)NSString *pageCount2;
//搜素关键字
@property (nonatomic,strong)NSString *searchKey;
@property (nonatomic,strong)SPDetailCell *cell;
@property (nonatomic,strong)PDetailViewController *pDetail;
@property (nonatomic,strong)BaseMessageVC *baseMessage;
@property (nonatomic,strong)NSMutableArray *datasource;

//发送成功后修改其值,用该值来确定是否需要需要移除该行cell
@property (nonatomic,assign,getter = isProjectDidRemoved) BOOL projectDidRemoved;



@end

@implementation SPDetailVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    //    t.font = [UIFont systemFontOfSize:18];
    t.textColor = [UIColor blackColor];
    t.font = [UIFont fontWithName:@"Helvetica-Bold"  size:(20.0)];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = UITextAlignmentCenter;
    if ([_docProperty isEqual:@"在办箱"]) {
        [self.navigationItem setTitle:@"在办"];
        //        t.text = @"在办";
        
        
    }
    else if([_docProperty isEqual:@"已办箱"])
    {
        [self.navigationItem setTitle:@"已办"];
        //        t.text = @"已办";
        
    }
    else if([_docProperty isEqual:@"督办箱"])
    {
        [self.navigationItem setTitle:@"督办"];
        //        t.text = @"督办";
        
    }
    
    //    self.navigationItem.titleView = t;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_projectDidRemoved) {
        [self removeSelectedRow];
    }
    _projectDidRemoved = NO;
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
    _page1= @"0";
    _pageCount1 = @"20";
    _page2= @"0";
    _pageCount2 = @"20";
    _datasource =[NSMutableArray array];
    //设置返回按钮的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //搜索栏
    [self createSearchBar];
    
    //创建tableView
    [self createTableView];
    
    //创建导航栏
    [self setNavigationbar];
    [self loadData];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeSelectedRow) name:@"sendDidCompelte" object:nil];
    
    
}


- (void)createSearchBar
{
    gwSearchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,44)];
    gwSearchBar.hidden = YES;
    //设置输入颜色
    gwSearchBar.tintColor = [UIColor blackColor];
    UIImage *image =[self imageWithColor:[UIColor whiteColor]];
    //设置搜索框的背景图片
    [gwSearchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    //设置背景颜色
    [gwSearchBar setBarTintColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    gwSearchBar.delegate =  self;
    
    
}

- (void)createTableView
{
    UITableView *spTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height) style:UITableViewStylePlain];
    spTableView.delegate =self;
    spTableView.dataSource = self;
    spTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _spDetailTableView = spTableView;
    //
    [self.view addSubview:_spDetailTableView];
    
    //..下拉刷新
    _spDetailTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = @"0";
        [self loadData];
    }];
    
    //..上拉刷新
    _spDetailTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([_docProperty isEqual:@"在办箱"]) {
            _pageCount = [NSString stringWithFormat:@"%d",[_pageCount intValue] + 20];
            
        }
        else if ([_docProperty isEqual:@"已办箱"])
        {
            _pageCount1 = [NSString stringWithFormat:@"%d",[_pageCount1 intValue] + 20];
            
            
            
        }
        else if ([_docProperty isEqual:@"督办箱"])
        {
            _pageCount2 = [NSString stringWithFormat:@"%d",[_pageCount2 intValue] + 20];
            
        }
        [self loadData];
        
    }];
}

- (void)setNavigationbar
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [gwSearchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [gwSearchBar resignFirstResponder];
    [gwSearchBar setShowsCancelButton:NO animated:YES];
    gwSearchBar.hidden = YES;
    mode = 0;
    [self.spDetailTableView reloadData];
    
}
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"---%@",searchBar.text);
    
    [gwSearchBar resignFirstResponder];// 放弃第一响应者
    mode = 1;
    //    [self doSearch:searchBar.text];
    [self loadData];
    [self.spDetailTableView reloadData];
    
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self changeCancel];//改cancel为取消
}
-(void) changeCancel{
    for(id subView in [gwSearchBar.subviews[0] subviews]){
        if([subView isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)subView;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancekClicked) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)cancekClicked
{
    mode =0;
    _spDetailTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    gwSearchBar.text =nil;
    [self.spDetailTableView reloadData];
}

- (void)btnClick  //🔍按下 显示搜索栏
{
    _spDetailTableView.frame =CGRectMake(0, gwSearchBar.frame.size.height, MainR.size.width, MainR.size.height-gwSearchBar.frame.size.height);
    gwSearchBar.hidden =  NO;
    [self.view addSubview:gwSearchBar];
    [gwSearchBar becomeFirstResponder];
}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    NSLog(@"textDidChange---%@",searchBar.text);
    //[liveViewAreaTable searchDataBySearchString:searchBar.text];// 搜索tableView数据
    
}


-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters;
    
    //如果为正常模式
    if (mode==0) {
        gwSearchBar.text =nil;
    }
    
    
    if([self.docProperty  isEqual: @"在办箱"]){
        //        type=smartplan&action=workitem&user=181&pagesize=10&pageindex=1&boxtype=1&businessTypes=0,1&key=
        parameters = @{@"type":@"smartplan",@"action":@"workitem",@"user":[Global myuserId],@"pagesize":_pageCount,@"pageindex":_page,@"boxtype":@"1",@"businessTypes":@"0",@"key":gwSearchBar.text};
        
    }
    else if([self.docProperty  isEqual: @"已办箱"])
    {
        parameters = @{@"type":@"smartplan",@"action":@"workitem",@"user":[Global myuserId],@"pagesize":_pageCount1,@"pageindex":_page1,@"boxtype":@"2",@"businessTypes":@"0",@"key":gwSearchBar.text};
    }
    else if([self.docProperty  isEqual: @"督办箱"])
    {
        parameters = @{@"type":@"smartplan",@"action":@"workitem",@"user":[Global myuserId],@"pagesize":_pageCount2,@"pageindex":_page2,@"boxtype":@"3",@"businessTypes":@"0",@"key":gwSearchBar.text};
        
    }
    
    //    if(!_isDropRefersh)//下拉刷新
//    [MBProgressHUD showMessage:@"正在加载SP!"];
    [MBProgressHUD showMessage:@"正在加载"toView:self.view];

    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
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
                
            }
            else if (mode==1)//搜索
            {
                
                _searchSource = mulArr;
                
            }
            
            
            [_spDetailTableView.header endRefreshing];
            [_spDetailTableView.footer endRefreshing];
            
        }else{
            [_spDetailTableView.header endRefreshing];
            [_spDetailTableView.footer endRefreshing];
            
        }
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.spDetailTableView.header endRefreshing];
            [self.spDetailTableView reloadDataWithDirectionType:SHReloadAnimationDirectionTop AnimatrionWithTimeNum:0.5 interval:0.05];
        });
        
        [_spDetailTableView reloadData];
        //        //设置下次取消下拉刷新
        //        _isDropRefersh = NO;
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [_spDetailTableView.header endRefreshing];
        [_spDetailTableView.footer endRefreshing];
        
        //        _isDropRefersh = NO;
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
    //提前初始化basemessage(为了设置代理为SPDetailVC)
    BaseMessageVC  *baseMess=[[BaseMessageVC alloc] init];
    baseMess.sendDelegate =self;
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
    _selectedIndex = indexPath.row;
    
    
    [pDetail setModel:model];
    
    
    [SHPushVCAnimation addAnimationOnView:self.view animation:SHAnimationTypeFade direction:SHAnimationTypeMoveIn duration:0.5];
    
    
    //    pDetail.project = [_datasource objectAtIndex:_selectedIndex];
    [self.navigationController pushViewController:pDetail animated:YES];
    
}


//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openZw:[[_datasource objectAtIndex:indexPath.row] objectForKey:@"identity"]];
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"查看正文";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
///**
// *  集成刷新控件
// */
//- (void)setupRefresh
//{
//    //..下拉刷新
//    _spDetailTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        //        page = 0;
//        myRefresh = _spDetailTableView.header;
//        [self headerRereshing];
//    }];
//
//
//}

//#pragma mark 开始进入刷新状态
//- (void)headerRereshing
//{
//    //设置下次下拉标记标记
//    _isDropRefersh = YES;
//    [self loadData];
//}


//移除选定cell
-(void)removeSelectedRow{
    [_datasource removeObjectAtIndex:_selectedIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [self.spDetailTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
}

-(void)sendViewDidSendCompleted{
    _projectDidRemoved = YES;
    [self.navigationController popToViewController:self animated:YES];
}
@end
