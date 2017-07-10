//
//  OffiDocDetaiVController.m
//  XAYD
//
//  Created by songdan Ye on 16/4/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "OffiDocDetaiVController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "SHPushVCAnimation.h"
#import "OfficialDocCell.h"
#import "SPDetailModel.h"
#import "BusinessCell.h"
#import "DocDetailVC.h"
#import "SendViewController.h"
#import "CYQYModel.h"

@interface OffiDocDetaiVController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SendViewDelegate>
{
    BOOL _isDropRefersh;//下拉刷新
    NSInteger _selectedIndex;
    BOOL _projectDidRemoved;
    //MJRefreshComponent *myRefresh;
     UISearchBar *gwSearchBar;
}


@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageCount;
@property (nonatomic,strong)NSString *page1;
@property (nonatomic,strong)NSString *pageCount1;
@property (nonatomic,strong)NSString *page2;
@property (nonatomic,strong)NSString *pageCount2;


@property (nonatomic,strong)NSString *segIndex;

//搜索内容
@property (nonatomic,strong)NSString *searchString;

//搜素关键字
@property (nonatomic,strong)NSString *searchKey;
@property (nonatomic,strong)OfficialDocCell *cell;
@property (nonatomic,strong)UISearchBar *searchBar;


@property (nonatomic,strong)NSString *dataType;

@end

@implementation OffiDocDetaiVController

- (void)viewDidLoad {
    [super viewDidLoad];
    _segIndex = @"0";
    //初始化刷新数据的参数
    _page= @"0";
    _pageCount = @"20";
    _page1= @"0";
    _pageCount1 = @"20";
    _page2= @"0";
    _pageCount2 = @"20";
    //设置默认加载的数据为(传阅箱内容)
    self.dataType = @"0";
    
    
    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-MENUHEIHT);
    self.view.backgroundColor = [UIColor whiteColor];
    //设置返回按钮的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    //创建搜索条
//    [self createSearchBar];
    
    //创建tableView
    [self createTableView];
    //加载数据
    [self loadData];
    //监听搜索按钮被点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searching:) name:@"gwSeacrchAction0" object:nil];
    //监听取消按钮被点击
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelClicked) name:@"gwSearchCancelClicked" object:nil];
    
//    //添加搜索监听者
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatSearchB) name:@"sBtnClick0" object:nil];
    //添加监听者(传阅箱还是签约箱内容)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCYXorQYX:) name:@"loadCYXdataOrQYXdata" object:nil];
    
    
}

- (void) searching:(NSNotification *)text
{
    _mode = 1;
    _searchString =text.userInfo[@"open1"];
//    [self loadData];
    
 if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
 {
     NSMutableArray *mulArr =[NSMutableArray array];
     for (SPDetailModel *spModel in _datasource)
     {
         NSRange range = [spModel.projectName
                          rangeOfString:_searchString];
         if(range.location != NSNotFound)
         {
             [mulArr addObject:spModel];
         }
         NSRange range1 =[spModel.xmbh rangeOfString:_searchString];
         if (range1.location != NSNotFound)
         {
             [mulArr addObject:spModel];
         }
         NSRange range2 =[spModel.time rangeOfString:_searchString];
         
         if (range2.location != NSNotFound)
         {
             [mulArr addObject:spModel];
         }
         
     }
     _searchSource = mulArr;
     
     
 }
    else
    {
        NSMutableArray *mulArr =[NSMutableArray array];
        for (CYQYModel *cqModel in _datasource)
        {
            
            NSRange range = [cqModel.name
                             rangeOfString:_searchString];
            if(range.location != NSNotFound)
            {
                [mulArr addObject:cqModel];
            }
            NSRange range1 =[cqModel.bh rangeOfString:_searchString];
            if (range1.location != NSNotFound)
            {
                [mulArr addObject:cqModel];
            }
            NSRange range2 =[cqModel.time rangeOfString:_searchString];
            
            if (range2.location != NSNotFound)
            {
                [mulArr addObject:cqModel];
            }
            
        }
        _searchSource = mulArr;
    
    }
    [self.offDDetailtableView reloadData];
    
}




- (void)cancelClicked
{
    if (_mode == 1) {//如果是搜索状态,即设置为正常状态
        _mode =0;
        _offDDetailtableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
        gwSearchBar.text =nil;
        [self.offDDetailtableView reloadData];
        
    }
    
}


//监听到segment值改变时加载的方法
- (void)loadCYXorQYX:(NSNotification *)text
{
    _datasource =[NSMutableArray array];
    [self.offDDetailtableView reloadData];

    
    if(_mode==1)
    {
        [self cancelClicked];
        
    }
    [MBProgressHUD hideHUDForView:self.view];
    //保存segment选中的index
    self.dataType =text.userInfo[@"selectedIndex"];
    _segIndex =self.dataType;
    if ([self.dataType isEqualToString:@"0"]) {
        self.dataType = @"zbgwlist";
    }else if([self.dataType isEqualToString:@"1"])
    {
        self.dataType = @"ybgwlist";
    
    }
    else if ([self.dataType isEqualToString:@"2"])
    {
    
     self.dataType = @"cyqylist";
        _forwardType = @"0";
    }
    else
    {self.dataType = @"cyqylist";
        _forwardType = @"1";
        
    }
    
    //加载数据
    [self loadData];
}
//监听到搜索执行的方法
- (void)creatSearchB
{
    _offDDetailtableView.frame= CGRectMake(0, _searchBar.frame.size.height, MainR.size.width, MainR.size.height);
    _searchBar.hidden =  NO;
    [self.view addSubview:_searchBar];
    [_searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_projectDidRemoved) {
        [self removeSelectedRow];
    }
    _projectDidRemoved = NO;
}

/**
 *  根据颜色生成图片
 */

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
/**
 *  创建tableView
 */
- (void)createTableView
{
    UITableView *tabV =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-MENUHEIHT) style:UITableViewStylePlain];
    tabV.delegate = self;
    tabV.dataSource = self;
    //    tabV.sectionHeaderHeight = 40;
    tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _offDDetailtableView = tabV;
    self.offDDetailtableView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_offDDetailtableView];
    //..下拉刷新
    _offDDetailtableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = @"0";
        [self loadData];
    }];
    
    //..上拉刷新
    _offDDetailtableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
 
        _pageCount = [NSString stringWithFormat:@"%d",[_pageCount intValue] + 20];
        
        [self loadData];
        
    }];
}

-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if([_dataType isEqualToString:@"0"])
    {
        _dataType= @"zbgwlist";
        [parameters setObject:@"0" forKey:@"sftype"];

    
    }
    else if([_dataType isEqualToString:@"1"])
    {
        _dataType= @"ybgwlist";
        [parameters setObject:@"0" forKey:@"sftype"];

        
    }
    else if ([_dataType isEqualToString:@"ybgwlist"])
    {
        _dataType= @"ybgwlist";
        [parameters setObject:@"0" forKey:@"sftype"];
    
    }
        
    [parameters setObject:@"smartplan" forKey:@"type"];
    [parameters setObject:_dataType forKey:@"action"];
    [parameters setObject:[Global myuserId] forKey:@"user"];
    [parameters setObject:_pageCount forKey:@"pagesize"];
    [parameters setObject:_page forKey:@"pageindex"];

    if([_dataType isEqualToString:@"cyqylist"])
    {
        [parameters setObject:self.forwardType forKey:@"forwardType"];
        [parameters setObject:@"true" forKey:@"isLoadToMe"];
        [parameters setObject:@"false" forKey:@"isFinish"];

        [parameters setObject:@"1" forKey:@"resourceType"];


        
    }

    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"收文/发给我的%@",requestAddress);
 
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            NSArray *td= [rs objectForKey:@"result"];
            if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"]) {
                SPDetailModel *spModel;
                NSMutableArray *mulArr =[NSMutableArray array];
                for (NSDictionary *dict in td) {
                    spModel = [SPDetailModel spDetailModelWithDict:dict];
                    [mulArr addObject:spModel];
                }
                if(_mode==0)
                {
                    _datasource = mulArr;
                    
                }
//                else if (mode==1)//搜索
//                {
//                    
//                    _searchSource = mulArr;
//                    
//                }

            }
            else
            {
                CYQYModel *cymodel;
                NSMutableArray *mulArr =[NSMutableArray array];
                for (NSDictionary *dict in td) {
                    cymodel = [CYQYModel CYQYModelWithDict:dict];
                    [mulArr addObject:cymodel];
                }
                if(_mode==0)
                {
                    _datasource = mulArr;
                    
                }
//                else if (mode==1)//搜索
//                {
//                    
//                    _searchSource = mulArr;
//                    
//                }
            
            
            }
            [_offDDetailtableView.header endRefreshing];
            [_offDDetailtableView.footer endRefreshing];
            
        }else{
            _datasource = [NSMutableArray array];
            [self.offDDetailtableView reloadData];
            [_offDDetailtableView.header endRefreshing];
            [_offDDetailtableView.footer endRefreshing];
            
            
        }
        
        [_offDDetailtableView reloadData];
        //        //设置下次取消下拉刷新
        //        _isDropRefersh = NO;
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [_offDDetailtableView.header endRefreshing];
        [_offDDetailtableView.footer endRefreshing];
        
        //        _isDropRefersh = NO;
    }];
}




#pragma -mark  UITableViewDataSource,UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mode == 1)//搜索
    {
        return _searchSource.count;
    }
    NSLog(@"count=============%d",_datasource.count);
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfficialDocCell *cell;
    if (cell==nil) {
        cell=[OfficialDocCell cellWithTableView:tableView];
    }
     if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"]) {
    if(_mode == 1)
    {
        cell.spDetailmodel = [_searchSource objectAtIndex:indexPath.row];
    }
    else
    {
        cell.spDetailmodel= [_datasource objectAtIndex:indexPath.row];
    }}else
    {
        if(_mode == 1)
        {
            cell.cqModel = [_searchSource objectAtIndex:indexPath.row];
        }
        else
        {
            cell.cqModel= [_datasource objectAtIndex:indexPath.row];
        }
    
    }
    
    if (indexPath.row ==0) {
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        [cell.contentView addSubview:line];
    }
    
    if (MainR.size.width>414) {
        cell.iconLC.constant =cell.timeLabelRC.constant = 10;
    }

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationItem setTitle:@"返回"];
    _selectedIndex = indexPath.row;
    //公文详情控制器
    DocDetailVC *docDetail = [[DocDetailVC alloc] init];
    docDetail.currentState = self.segIndex;
    docDetail.selectedIndex = @"0";
    docDetail.dataType = self.dataType;
    docDetail.forwordType = self.segIndex;
       if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"]) {
    SPDetailModel *model =nil;
    if(_mode == 0)
    {
        model =[_datasource objectAtIndex:indexPath.row];
    }
    else
    {

        model = [_searchSource objectAtIndex:indexPath.row];

    }
//
//    [docDetail setModel:model];
    docDetail.spModel = model;
    }else
    {
        
        CYQYModel *cqModel;
        if(_mode == 0)
        {
            cqModel =[_datasource objectAtIndex:indexPath.row];
        }
        else
        {
            
            cqModel = [_searchSource objectAtIndex:indexPath.row];
            
        }
        docDetail.cqModel =cqModel;
    }
    docDetail.nav = self.nav;
    docDetail.sendDelegate = self;
    [self.nav pushViewController:docDetail animated:YES];

}


-(void)removeSelectedRow{
    
    if (_mode ==1) {
        [_searchSource removeObjectAtIndex:_selectedIndex];

    }
    else
    {
        [_datasource removeObjectAtIndex:_selectedIndex];

    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [self.offDDetailtableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
}

-(void)sendViewDidSendCompleted{
//    _projectDidRemovedj    = YES;
    
    [self.nav popToViewController:[self.nav.viewControllers objectAtIndex:0] animated:YES];
    
        [self removeSelectedRow];
}

@end
