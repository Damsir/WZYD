//
//  ApproDBViewController.m
//  XAYD
//
//  Created by songdan Ye on 16/4/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ApproDBViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "PDetailViewController.h"
//#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "SHPushVCAnimation.h"
#import "SPDetailCell.h"
#import "SPDetailModel.h"
#import "UITableView+ReloadExten.h"
#import "BaseMessageVC.h"
static const CGFloat AnimationDuration = 2.0;

@interface ApproDBViewController ()<SendViewDelegate>
{
    //    NSMutableArray *_datasource;
//    NSMutableArray *_searchSource;
    BOOL _isDropRefersh;//下拉刷新
    NSInteger _selectedIndex;
    UISearchBar *gwSearchBar;
    //MJRefreshComponent *myRefresh;
}


@property (nonatomic,strong)NSString *page2;
@property (nonatomic,strong)NSString *pageCount2;
//搜素关键字
@property (nonatomic,strong)NSString *searchKey;
@property (nonatomic,strong)SPDetailCell *cell;
@property (nonatomic,strong)PDetailViewController *pDetail;
@property (nonatomic,strong)BaseMessageVC *baseMessage;
@property (nonatomic,strong)NSMutableArray *datasource;
@property (nonatomic,strong)NSMutableArray *searchSource;


//搜索内容
@property (nonatomic,strong)NSString *searchString;


//发送成功后修改其值,用该值来确定是否需要需要移除该行cell
@property (nonatomic,assign,getter = isProjectDidRemoved) BOOL projectDidRemoved;


@end


@implementation ApproDBViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    //    //    t.font = [UIFont systemFontOfSize:18];
    //    t.textColor = [UIColor blackColor];
    //    t.font = [UIFont fontWithName:@"Helvetica-Bold"  size:(20.0)];
    //    t.backgroundColor = [UIColor clearColor];
    //    t.textAlignment = UITextAlignmentCenter;
    //    if ([_docProperty isEqual:@"在办箱"]) {
    //        [self.navigationItem setTitle:@"在办"];
    //        //        t.text = @"在办";
    //
    //
    //    }
    //    else if([_docProperty isEqual:@"已办箱"])
    //    {
    //        [self.navigationItem setTitle:@"已办"];
    //        //        t.text = @"已办";
    //
    //    }
    //    else if([_docProperty isEqual:@"督办箱"])
    //    {
    //        [self.navigationItem setTitle:@"督办"];
    //        //        t.text = @"督办";
    //
    //    }
    //
    //    //    self.navigationItem.titleView = t;
    //
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
    _page2= @"0";
    _pageCount2 = @"20";
    _datasource =[NSMutableArray array];
    //设置返回按钮的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //创建tableView
    [self createTableView];

    [self loadData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searching:) name:@"seacrchAction2" object:nil];
    //监听搜索取消
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelClicked) name:@"searchCancelClicked" object:nil];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    [_spDetailTableView reloadData];
}
- (void) searching:(NSNotification *)text
{
    mode = 1;
    _searchString =text.userInfo[@"open0"];
    [self loadData];
    
}


- (void)createTableView
{
    UITableView *spTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-MENUHEIHT) style:UITableViewStylePlain];
    spTableView.delegate =self;
    spTableView.dataSource = self;
    spTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _spDetailTableView = spTableView;
    //
    
  
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        [_spDetailTableView addSubview:line];
        
    [self.view addSubview:_spDetailTableView];
    
    //..下拉刷新
    _spDetailTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page2 = @"0";
        [self loadData];
    }];
    //..上拉刷新
    _spDetailTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _pageCount2 = [NSString stringWithFormat:@"%d",[_pageCount2 intValue] + 30];
        [self loadData];
        
    }];
}


- (void)cancelClicked
{
    if (mode==1) {//如果是搜索状态,即设置为正常状态
        mode =0;
        _spDetailTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
        gwSearchBar.text =nil;
        [self.spDetailTableView reloadData];

    }
   }

-(void)loadData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters;
    
    //如果为正常模式
    if (mode==0) {
        gwSearchBar.text =nil;
        _searchString =@"";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/project/ProjectList.ashx"];
    parameters = @{@"type":@"3",@"index":_page2,@"size":_pageCount2,@"uid":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"DB%@",requestAddress);
    //    if(!_isDropRefersh)//下拉刷新
//    [MBProgressHUD showMessage:@"正在加载SP!"];
//    [MBProgressHUD showMessage:@"正在加载"];

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
                
            }
            else if (mode==1)//搜索
            {
                
                _searchSource = mulArr;
                
            }
            
            
            [_spDetailTableView.header endRefreshing];
            [_spDetailTableView.footer endRefreshing];
            
//        }else{
//            [_spDetailTableView.header endRefreshing];
//            [_spDetailTableView.footer endRefreshing];
//            
//        }
        
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.spDetailTableView.header endRefreshing];
//            [self.spDetailTableView reloadDataWithDirectionType:SHReloadAnimationDirectionTop AnimatrionWithTimeNum:0.5 interval:0.05];
//        });
        
        [_spDetailTableView reloadData];
        //        //设置下次取消下拉刷新
        //        _isDropRefersh = NO;
//        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [_spDetailTableView.header endRefreshing];
        [_spDetailTableView.footer endRefreshing];
        
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
    if (indexPath.row ==0) {
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        [cell.contentView addSubview:line];
    }
    
    if (MainR.size.width>414) {
        cell.iconImageLC.constant =10;
        cell.flowLeftTimeRC.constant = 15;
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
    [self.nav pushViewController:pDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//
////进入编辑模式，按下出现的编辑按钮后
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self openZw:[[_datasource objectAtIndex:indexPath.row] objectForKey:@"identity"]];
//}
//
////修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return @"查看正文";
//}

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
    
    
    if (mode==1) {
        [_searchSource removeObjectAtIndex:_selectedIndex];
    }
    else
    {
        
        [_datasource removeObjectAtIndex:_selectedIndex];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [self.spDetailTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
}

-(void)sendViewDidSendCompleted{
//    _projectDidRemoved = YES;
//    [self.nav popToViewController:self animated:YES];
    [self.nav popToViewController:[self.nav.viewControllers objectAtIndex:0] animated:YES];
    [self removeSelectedRow];
}

@end
