//
//  StatisticsVController.m
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//
#import "StatisticsVController.h"
#import "StaticCell.h"
#import "ZFChart.h"
#import "AFNetworking.h"
#import "Global.h"
#import "StatisticModel.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
static NSString *reuseIdentifierChart = @"SCChartCell";

@interface StatisticsVController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * array1;
@property (nonatomic, strong) NSMutableArray * array2;
@property (nonatomic, strong) NSMutableArray * totalArray;
@property (nonatomic, strong) StatisticModel * SModel;



@end

@implementation StatisticsVController


- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-74-49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView =tableView;
     _tableView.header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDatas)];
    [self.view addSubview:_tableView];
    [self loadDatas];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatic) name:UIDeviceOrientationDidChangeNotification object:nil];

}
//加载数据

-(void)loadDatas{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters;
    
    NSString *url =@"http://192.168.2.239/HAYDService/ServiceProvider.ashx?type=smartplan&action=statistics&enddate=";
    parameters = @{@"type":@"smartplan",@"action":@"statistics",@"enddate":@""};
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"])
        {
            NSArray *td= [rs objectForKey:@"result"];
            
            NSMutableArray *mulArr =[NSMutableArray array];
            for (NSDictionary *dict in td) {
                _SModel = [StatisticModel StaticModelWithDict:dict];
                [mulArr addObject:_SModel];
            }
            _totalArray = mulArr;
            [_tableView.header endRefreshing];
            [_tableView.footer endRefreshing];
            
        }
        else{
            [_tableView.header endRefreshing];
            [_tableView.footer endRefreshing];
        }
        
        
        [_tableView reloadData];
        //        //设置下次取消下拉刷新
        //        _isDropRefersh = NO;
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
    }];
}

- (void)changeStatic
{
    [self.tableView reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
            return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    StaticCell *cell;

            if (!cell) {
                cell = [[StaticCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierChart];
                            }
    if (indexPath.section == 0) {
        NSMutableArray *mulA=[NSMutableArray array];
        for (StatisticModel * sModel in _totalArray) {
            [mulA addObject:sModel.sjCount];
        }
        cell.array0 =[mulA copy];
//  @[@"0",@"44", @"23", @"105", @"117", @"0"];
    }
    else if(indexPath.section == 1)
    {
        NSMutableArray *mulA=[NSMutableArray array];
        for (StatisticModel * sModel in _totalArray) {
            [mulA addObject:sModel.fjCount];
        }
        cell.array1 =[mulA copy];
        
    }
    else
    {
        cell.array2=@[@"66", @"18", @"57", @"16", @"10", @"88"];
        
    }
    NSMutableArray *mulA=[NSMutableArray array];
    for (StatisticModel * sModel in _totalArray) {
        NSString *str =[sModel.month substringFromIndex:2];
        [mulA addObject:str];
        
    }
    cell.timeArr =[mulA copy];
    
            [cell configUI:indexPath];

   
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
            return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 10);

    UIView *view =[[UIView alloc] initWithFrame:frame];
    view.backgroundColor =RGB(238.0, 238.0, 238.0);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 15;
    }
    else{
    
    return 0.1;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
