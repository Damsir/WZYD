//
//  SendOffDocDetailVC.m
//  XAYD
//
//  Created by songdan Ye on 16/4/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SendOffDocDetailVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "SHPushVCAnimation.h"
#import "OfficialDocCell.h"
#import "SPDetailModel.h"
#import "BusinessCell.h"
#import "DocDetailVC.h"
#import "CYQYModel.h"
#import "SendViewController.h"
//#import "UITableView+ReloadExten.h"
static const CGFloat AnimationDuration = 2.0;

@interface SendOffDocDetailVC ()<UITableViewDelegate,UITableViewDataSource,SendViewDelegate>
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
//记录当前选中的seg
@property (nonatomic,strong)NSString *segIndex;


//搜索内容
@property (nonatomic,strong)NSString *searchString;
//搜素关键字
@property (nonatomic,strong)NSString *searchKey;
@property (nonatomic,strong)OfficialDocCell *cell;
@property (nonatomic,strong)UISearchBar *searchBar;

//请求参数 保存传阅为0,签阅箱为1
@property (nonatomic,strong)NSString *dataType;


@end

@implementation SendOffDocDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    
    _segIndex = @"0";

    //初始化刷新数据的参数
    _page= @"0";
    _pageCount = @"20";
    _page1= @"0";
    _pageCount1 = @"20";
    _page2= @"0";
    _pageCount2 = @"20";
    
    //默认请求参数值
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searching:) name:@"gwSeacrchAction1" object:nil];
    //监听取消按钮被点击
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelClicked) name:@"gwSearchCancelClicked" object:nil];
//    //添加搜索监听者
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatSearchB) name:@"sBtnClick1" object:nil];
    
    //添加监听者(传阅箱还是签约箱内容)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCYXorQYX:) name:@"loadCYXdataOrQYXdata" object:nil];
    
    
}

- (void) searching:(NSNotification *)text
{
    mode = 1;
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
    [self.sendOffTableV reloadData];
}

- (void)cancelClicked
{
    if (mode == 1) {//如果是搜索状态,即设置为正常状态
        mode =0;
        _sendOffTableV.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
        gwSearchBar.text =nil;
        [self.sendOffTableV reloadData];
        
    }
    
}




//监听到segment值改变时加载的方法
- (void)loadCYXorQYX:(NSNotification *)text
{
    _datasource =[NSMutableArray array];
    [self.sendOffTableV reloadData];
    if(mode == 1)
    {
        [self cancelClicked];
    }
    
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
        self.forwardType = @"0";
    }
    else
    {
        self.dataType = @"cyqylist";
        self.forwardType = @"1";
    }
    //加载数据
    [self loadData];
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
    
    _sendOffTableV = tabV;
    self.sendOffTableV.backgroundColor =[UIColor whiteColor];
    
   
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        [_sendOffTableV addSubview:line];

    
    [self.view addSubview:_sendOffTableV];
    //..下拉刷新
    _sendOffTableV.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = @"0";
        [self loadData];
    }];
    
    //..上拉刷新
    _sendOffTableV.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
      
        _pageCount = [NSString stringWithFormat:@"%d",[_pageCount intValue] + 20];
        
        [self loadData];
        
    }];
}


-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary *parameters= [NSMutableDictionary dictionary];
    

//workitem
//    zbgwlist
  
    
//    parameters = @{@"type":@"smartplan",@"action":@"zbgwlist",@"user":[Global myuserId],@"pagesize":_pageCount,@"pageindex":_page,@"boxtype":self.dataType,@"businessTypes":@"0",@"key":_searchBar.text};
    if([_dataType isEqualToString:@"0"])
    {
        _dataType= @"zbgwlist";
        [parameters setObject:@"1" forKey:@"sftype"];

        
    }
    else if([_dataType isEqualToString:@"1"])
    {
        _dataType= @"ybgwlist";
        [parameters setObject:@"1" forKey:@"sftype"];

        
    }else if ([_dataType isEqualToString:@"ybgwlist"])
    {
        _dataType= @"ybgwlist";
        [parameters setObject:@"1" forKey:@"sftype"];
    
    }

    
    [parameters setObject:@"smartplan" forKey:@"type"];
    [parameters setObject:_dataType forKey:@"action"];
    [parameters setObject:[Global myuserId] forKey:@"user"];
    [parameters setObject:_pageCount forKey:@"pagesize"];
    [parameters setObject:_page forKey:@"pageindex"];

    
    if([_dataType isEqualToString:@"cyqylist"])
    {
        [parameters setObject:self.forwardType forKey:@"forwardType"];
        [parameters setObject:@"false" forKey:@"isLoadToMe"];
        [parameters setObject:@"false" forKey:@"isFinish"];
        //固定为1
        [parameters setObject:@"1" forKey:@"resourceType"];

    }
    
    //发文
//     NSLog(@"%@?type=smartplan&action=%@&user=%@&pagesize=%@&pageindex=%@&resourceType=%@&isLoadToMe=%@&sftype=%@&forwardType=%@",[Global serverAddress],_dataType,[parameters objectForKey:@"user"],[parameters objectForKey:@"pagesize"],[parameters objectForKey:@"pageindex"],[parameters objectForKey:@"resourceType"],[parameters objectForKey:@"isLoadToMe"],[parameters objectForKey:@"sftype"],[parameters objectForKey:@"forwardType"]);
    //
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"发文/我发送的%@",requestAddress);
    //
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
                if(mode==0)
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
                if(mode==0)
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
            
           
            
            
            [_sendOffTableV.header endRefreshing];
            [_sendOffTableV.footer endRefreshing];
            
        }else{
            _datasource = nil;
            [self.sendOffTableV reloadData];
            [_sendOffTableV.header endRefreshing];
            [_sendOffTableV.footer endRefreshing];
            
        }
        
        [_sendOffTableV reloadData];
        //        //设置下次取消下拉刷新
        //        _isDropRefersh = NO;
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [_sendOffTableV.header endRefreshing];
        [_sendOffTableV.footer endRefreshing];
        
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
    OfficialDocCell *cell;
    if (cell==nil) {
        cell=[OfficialDocCell cellWithTableView:tableView];
    }
    if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"]) {
        if(mode == 1)
        {
            cell.spDetailmodel = [_searchSource objectAtIndex:indexPath.row];
        }
        else
        {
            cell.spDetailmodel= [_datasource objectAtIndex:indexPath.row];
        }
    }else
        {
            if(mode == 1)
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
    DocDetailVC *docDetail = [[DocDetailVC alloc] init];
    docDetail.currentState = self.segIndex;
    docDetail.selectedIndex = @"1";
    docDetail.dataType = self.dataType;
    docDetail.forwordType = self.segIndex;

   
    if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"]) {
        SPDetailModel *model =nil;
        if(mode == 0)
        {
            model =[_datasource objectAtIndex:indexPath.row];
        }
        else
        {
            
            model = [_searchSource objectAtIndex:indexPath.row];
            
        }
       
        docDetail.spModel = model;
    }else
    {
        
        CYQYModel *cqModel;
        if(mode == 0)
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
    if (mode == 1) {
        [_searchSource removeObjectAtIndex:_selectedIndex];

    }
    else
    {
    [_datasource removeObjectAtIndex:_selectedIndex];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [self.sendOffTableV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
}

-(void)sendViewDidSendCompleted{

    [self.nav popToViewController:[self.nav.viewControllers objectAtIndex:0] animated:YES];
    [self removeSelectedRow];
}


@end
