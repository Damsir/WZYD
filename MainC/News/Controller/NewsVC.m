//
//  NewsVC.m
//  XAYD
//
//  Created by songdan Ye on 16/2/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "NewsVC.h"
#import "pressModel.h"
#import "PressCell.h"
#import "PressDetailVC.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "SystemNewCell.h"
#import "UIImageView+AFNetworking.h"


@interface NewsVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIWebView *webView;

@end

@implementation NewsVC

- (NSArray *)presses
{
    if (_presses==nil) {
        _presses  =[NSArray array];
    }
    return _presses;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.nav.navigationBar.hidden = YES;
//    self.tab.tabBar.hidden = NO;
 
    
}

//- (void) viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//
////    self.tab.tabBar.hidden = YES;
//
//}



- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-MENUHEIHT-49-20)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ghj.huaian.gov.cn/bjdt/wap/list.html"]]];
    webView.scrollView.bounces = NO;
    _webView = webView;
    [self.view addSubview:webView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-MENUHEIHT-49-20);
//    NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);

    //创建tableView
   // [self createTableView];
   // [self loadDatas];
    
}

//屏幕旋转结束执行的方法
- (void)screenRotation
{
    _webView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-MENUHEIHT-49-20);
}

- (void) createTableView
{

    UITableView *tabView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-49) style:UITableViewStylePlain];
    _tabView = tabView;
    _tabView.dataSource =self;
    _tabView.delegate = self;
    [self.view addSubview:_tabView];
    self.view.backgroundColor =[UIColor colorWithRed:250/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1 ];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tabView];
    _tabView.header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDatas)];
  
}



//加载数据
-(void)loadDatas{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters;
    //        http://58.246.138.178:8040/ioffice/ServiceProvider.ashx?type=smartplan&action=picnews
    //        http://192.168.2.239/KSYDService/ServiceProvider.ashx?type=smartplan&action=picnews&pageIndex=0&pageSize=10
    //        2.160.
    
    parameters = @{@"type":@"smartplan",@"action":@"picnews",@"pageIndex":@"0",@"pageSize":@"100"};
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"])
        {
            NSArray *td= [rs objectForKey:@"result"];
            pressModel *pModel;
            NSMutableArray *mulArr =[NSMutableArray array];
            for (NSDictionary *dict in td) {
                pModel = [pressModel pressModelWithDict:dict];
                [mulArr addObject:pModel];
            }
            _presses = mulArr;
            [_tabView.header endRefreshing];
            [_tabView.footer endRefreshing];
            
        }
        else{
            [_tabView.header endRefreshing];
            [_tabView.footer endRefreshing];
        }
        
        
        [_tabView reloadData];
        //        //设置下次取消下拉刷新
        //        _isDropRefersh = NO;
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [_tabView.header endRefreshing];
        [_tabView.footer endRefreshing];
        
    }];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _presses.count;
//    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.创建自定制cell
    pressModel *model = nil;
    
    SystemNewCell  *cell = nil;
    
    
   
    if (cell==nil) {
        cell =[SystemNewCell cellWithTableView:tableView];
    }
    if (MainR.size.width>414) {
        cell.viewOfNewsBHeightC.constant = 180+100;
        cell.titleLTopC.constant =154+100;
    }
   
 //2.给cell设置要显示的数据
    
   pressModel *pressM = (pressModel *)[_presses objectAtIndex:indexPath.row];
    NSString *urls =pressM.showurl;
//  NSString *news=  [urls stringByReplacingOccurrencesOfString:@"95" withString:@"160"];
//    
    NSURL *url =  [NSURL URLWithString:urls];
    
    //将图片设置为圆形的
    
    [cell.imageV setImageWithURL:url placeholderImage:[UIImage imageNamed:@"meeting.png"]];
    
    cell.pModel = pressM;
    
    if (MainR.size.width >414) {
        cell.bgViewLC.constant = cell.bgViewRC.constant = 20;
    }
    
     return cell;
    
}
//设置cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MainR.size.width>414) {
        return 300;
    }
    else
    {
    return 200;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PressDetailVC *pressDetail =[[PressDetailVC alloc]init];
    [pressDetail transNav:self.nav andTab:self.tab];
    pressModel *model =  [_presses objectAtIndex:indexPath.row];
//    NSString *url = @"";
    
    
//    NSString *urls =model.showurl;
//    NSString *news =[urls stringByReplacingOccurrencesOfString:@"95" withString:@"160"];
//    pressDetail.urlStr =news;
    pressDetail.pmodel= model;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.nav pushViewController:pressDetail animated:YES];
       
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
