//
//  PLogViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "PLogViewController.h"
#import "PLogCell.h"
#import "AFNetworking.h"
#import "SPDetailModel.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "PLogModel.h"
#import "PlogHeaderFooterView.h"
#import "PLogAllModel.h"
#import "CYQYModel.h"

@interface PLogViewController ()<UITableViewDelegate,UITableViewDataSource,PlogHeaderFooterViewDelegate>
@property (nonatomic,strong)UIButton * bgButton;
@property (nonatomic,strong)NSMutableArray * temArray;
@property (nonatomic,strong)UIImageView * imm;
@property (nonatomic,strong) NSString *lastDay;

@property (nonatomic,strong)NSMutableArray *tempArray ;


@end

@implementation PLogViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)loadData{

    //加载提示框
    //[self.view showJiaZaiWithBool:YES WithTitle:@"正在加载" WithAnimation:NO WithSuperViewStyle:1];
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
//    // 菊花背景
//    UIView *backView = [[UIView alloc] init];
//    if (SCREEN_WIDTH >= 768)
//    {
//        backView.frame = CGRectMake(0, 0, 120, 100);
//    }
//    else
//    {
//        backView.frame = CGRectMake(0, 0, 100, 80);
//    }
//    
//    backView.center = KeyWindow.center;
//    backView.layer.cornerRadius = 10 ;
//    backView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0] ;
//    [KeyWindow addSubview:backView];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/Log.ashx"];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[params setObject:[Global deviceUUID] forKey:@"deviceId"];
    //[params setObject:[Global userName] forKey:@"username"];

    if (_dataType !=nil )
    {
        if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
        {
            [params setObject:self.model.ProjectId forKey:@"project"];
        }
        else
        {
            [params setObject:self.cyModel.owner forKey:@"project"];

        }
    }
    else
    {
        if (_isCompre) {
            [params setObject:self.compreModel.Id forKey:@"project"];
        }
        else
        {
            if (_model.ProjectId)
            {
                params = @{@"project":_model.ProjectId,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
            }
            else if (_model.Id)
            {
                params = @{@"project":_model.Id,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
                
            }
        }
    }
   
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=params) {
        for (NSString *key in params.keyEnumerator) {
            NSString *val = [params objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"项目日志%@",requestAddress);
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        NSString *dateString = nil;
        NSArray *td = [rs objectForKey:@"result"];
        
       // NSLog(@"********%ld---%@",(unsigned long)td.count,td);
        PLogModel *plogModel=nil;
        NSMutableArray *mulArr =[NSMutableArray array];
        
        
        for (NSDictionary *dict in td)
        {
            plogModel = [[PLogModel alloc] initWithDict:dict];
            
            NSArray *arrsepar=[plogModel.ReceiveTime componentsSeparatedByString:@"/"];
            NSString *temStr =[arrsepar objectAtIndex:1];
            if (![temStr isEqualToString: dateString]) {
                //保存不同月份数组
                [_tempArray addObject:plogModel.ReceiveTime];
                dateString = temStr;
                //把第一个月份保存
                // NSLog(@"%@",dateString);
            }
            
            //保存所有模型
            [mulArr addObject:plogModel];
            
        }
        
        //循环遍历保存不同月份日期的数组
        NSString *year;
        NSString *month;
        NSString *date;
        NSMutableDictionary *allDict =[NSMutableDictionary dictionary];
        NSMutableArray *tempCArray =[NSMutableArray array];
        
        //循环取出数组日期
        for (NSString *dateString in _tempArray) {
            NSMutableArray *claArray=[NSMutableArray array];
            
            //分割日期取出年月
            NSArray *tArray=[dateString componentsSeparatedByString:@"/"];                    year = [tArray objectAtIndex:0];
            month = [tArray objectAtIndex:1];
            
            //最后保存的日期样式
            date = [NSString stringWithFormat:@"%@年%@月",year,month];
            //循环遍历时数组
            
            
            for (PLogModel *model in mulArr) {
                NSArray *arrsepar=[model.ReceiveTime componentsSeparatedByString:@"/"];
                //取出月份
                NSString *temStr =[arrsepar objectAtIndex:1];
                //如果月份相同
                if ([temStr isEqualToString: month]) {
                    //加到同一个数组中
                    [claArray addObject:model];
                }
                //  [_temArray addObject:date];
                
                // 显示的内容
                NSString *content=[NSString stringWithFormat:@"%@(%@ -> %@)",model.ActivityContent,model.PreviousRoleName,model.NextRoleName];
                model.content = content;
            }
            // 用日期作为key 用数组作为value
            [allDict setValue:claArray forKey:@"log"];
            [allDict setValue:date forKey:@"date"];
            [allDict setValue:@"YES" forKey:@"open"];
            PLogAllModel *allModel = [PLogAllModel pLogAllWithDict:allDict];
            
            [tempCArray  addObject:allModel];
        }
        
        _datasource = [tempCArray copy];
        
        
        [self.btableView reloadData];
        
        
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tabV =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    
    
    tabV.delegate = self;
    tabV.dataSource = self;
    //tabV.sectionHeaderHeight = 40;
    tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _btableView = tabV;
    [self.view addSubview:_btableView];
    
    [self loadData];
    
    self.temArray =[NSMutableArray array];
    self.tempArray =[NSMutableArray array];
    
    if(_dataType!=nil)
    {
        self.navigationItem.title = @"公文日志";
 
    }
    else{
    
        //self.navigationItem.title = @"项目日志";
        
        if ([_spOrgw isEqualToString:@"sp"]){
            
            [self initNavigationBarTitle:@"项目日志"];
        }else if ([_spOrgw isEqualToString:@"gw"]){
        
            [self initNavigationBarTitle:@"公文日志"];
        }
    }
    
    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);

    self.opened = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlog) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    
}
//屏幕旋转结束执行的方法
- (void)changePlog
{
    self.btableView.frame=CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
}
#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //
    //    NSInteger counts = self.datasource.count;
    //    ;
    //    NSInteger count = self.isOpened ?0:counts;
    //
    PLogAllModel *allmodel= [_datasource objectAtIndex:section];
    
    NSInteger counts =allmodel.log.count;
    NSInteger count = allmodel.isOpened ? counts: 0;
    
    return  count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _datasource.count;

}

#pragma mark -tabelViewDelge代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PlogHeaderFooterView *headerView = [PlogHeaderFooterView pLogHeaderWithTableView:tableView];
    headerView.delegate = self;
    headerView.pLogAllModel = _datasource[section];
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PLogAllModel *logAmodel =_datasource[indexPath.section];
    PLogModel *model =logAmodel.log[indexPath.row];
    CGFloat height = [self caculateRowHeightWithContent:model.content];
    
    return height > 44 ? height : 44;
}

-(CGFloat)caculateRowHeightWithContent:(NSString *)content{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-140, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    return rect.size.height + 19.0;
}

#pragma mark-PTreeHeaderFooterView代理方法

- (void)clickHeaderView
{
    [self.btableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLogCell *cell = [PLogCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PLogAllModel *logAmodel =_datasource[indexPath.section];
    PLogModel *logModel =logAmodel.log[indexPath.row];
    cell.model = logModel;
    PLogAllModel *ttmodel =[_datasource objectAtIndex:(_datasource.count-1)];
    NSArray *tempArray = ttmodel.log;
    
    if (indexPath.section == (_datasource.count-1)&&indexPath.row == (tempArray.count -1)) {
//        cell.dayLabel.backgroundColor =RGB(162, 255, 145);
      cell.dayLabel.backgroundColor=[UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f];
    }
    
    NSArray *arr=[logModel.ReceiveTime componentsSeparatedByString:@"/"];
    NSString *subString =[arr objectAtIndex:2];
    NSArray *temparr= [subString componentsSeparatedByString:@" "];
    NSString *day=[temparr objectAtIndex:0];
    if ([_lastDay isEqualToString: day]) {
        cell.heightC.constant = 10;
        cell.widthC.constant =10;
        if (MainR.size.height ==480) {
            cell.leftC.constant = 38;
            cell.topC.constant = 24;
            
        }
        else
        {
            cell.leftC.constant = 31;
            cell.topC.constant = 17;
            
        }
        cell.dayLableLeftC.constant = 16;
        cell.dayLabel.text =nil;
        cell.dayLabel.layer.cornerRadius = cell.heightC.constant/2.0;
        cell.dayLabel.clipsToBounds = YES;
    }
    else
    {
        _lastDay = day;
        cell.heightC.constant = 30;
        cell.widthC.constant = 30;
        
        if (MainR.size.height ==480) {
            cell.leftC.constant = 28;
        }
        else
        {
            
            cell.leftC.constant = 21;
            cell.topC.constant =7 ;
            
        }
        cell.dayLabel.layer.cornerRadius = cell.heightC.constant/2;
        cell.dayLabel.clipsToBounds = YES;
        
        
    }
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
