
//
//  MaterialViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "MaterialViewController.h"

#import "PTreeHeaderFooterView.h"
#import "AFNetworking.h"
#import "SPDetailModel.h"
#import "Global.h"
#import "MaterialModel.h"
#import "MBProgressHUD+MJ.h"
#import "materialListCell.h"
#import "MaterialItems.h"
#import "FileViewController.h"

@interface MaterialViewController ()<UIScrollViewDelegate,PTreeHeaderFooterViewDelegate,FileViewerDelegate>

@property (nonatomic,strong) NSString *fileId;
@property (nonatomic,strong) NSString *ext;
@property (nonatomic,strong) UIButton *tip;

@end

@implementation MaterialViewController

-(void)loadData
{
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 创建一个参数字典
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/FileList.ashx"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    if (_model.ProjectId)
    {
        parameters = @{@"project":_model.ProjectId,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    }
    else if (_model.Id)
    {
        parameters = @{@"project":_model.Id,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
    }
    
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
        [requestAddress appendString:@"?"];
    
        if (nil!=parameters) {
            for (NSString *key in parameters.keyEnumerator) {
                NSString *val = [parameters objectForKey:key];
                [requestAddress appendFormat:@"&%@=%@",key,val];
            }
        }
    
    NSLog(@"材料清单%@",requestAddress);
    self.datasource =[NSArray array];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        NSArray *result= [rs objectForKey:@"result"];
        MaterialItems *model;
        NSMutableArray *mulArr =[NSMutableArray array];
        if (result.count) {
            for (NSDictionary *dict in result){
                model = [[MaterialItems alloc] initDetailWithDict:dict];
                [mulArr addObject:model];
            }
            self.datasource = [mulArr copy];
            [self.tableView reloadData];
        }else{
            // 无材料提示
            [self showNoneMaterialTip];
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)showNoneMaterialTip
{
    if (!_tip) {
        
        UIButton *tip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tip.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64-50)/2.0);
        [tip setTitle:@"暂无附件材料!点击刷新" forState:UIControlStateNormal];
        [tip.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [tip setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        [tip addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
        _tip = tip;
        [self.view addSubview:tip];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.nav.navigationBar.hidden = NO;
    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    self.tableView.frame = CGRectMake(0, 64+47, MainR.size.width, MainR.size.height-64-47);

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64+47, MainR.size.width, MainR.size.height-64-47) style:UITableViewStylePlain];
    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 50;
    
    [self.view addSubview:_tableView];
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation
{
    _tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64-50)/2.0);
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    MaterialModel *model= [_datasource objectAtIndex:section];
//    NSInteger counts = model.files.count;
//    NSInteger countss = !model.isOpened ? counts: 0;
//    return  countss;
    return _datasource.count;
}

#pragma mark -tabelViewDelge代理方法

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    PTreeHeaderFooterView *headerView = [PTreeHeaderFooterView pTreeHeaderWithTableView:tableView fileTypeImageName:@"fileicon"];
//    
//    headerView.delegate =self;
//    headerView.mModel = (MaterialModel *)_datasource[section];
//    
//    
//    return headerView;
//    
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    
//    NSInteger count =self.datasource.count;
//    return  count;
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建自定制cell
    materialListCell *cell =[materialListCell cellWithTableView:tableView];
//    MaterialModel *mModel =[_datasource objectAtIndex:indexPath.section];
//    NSArray *tmp =mModel.files;
//  
//    MaterialItems *mDetailModel = [tmp objectAtIndex:indexPath.row];
//    [cell setMaterialDetailModel:mDetailModel];
    MaterialItems *model = _datasource[indexPath.row];
    [cell setMaterialDetailModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileViewController *fvc = [[FileViewController alloc]init];
    fvc.fileViewDelegate = self;
    MaterialItems *model=[_datasource objectAtIndex:indexPath.row];
    NSString *fileId = [NSString stringWithFormat:@"%@",model.Name];
    _fileId = fileId;
    _ext = [NSString stringWithFormat:@".%@",model.Extension];
    //    [self loadMatrialUrlWithFileId:mDetailModel.identity];

    NSString *downloadUrl = @"";
    if (_model.ProjectId)
    {
        downloadUrl = [NSString stringWithFormat:@"%@%@?project=%@&id=%@",[Global Url],@"service/form/DownLoadFile.ashx",_model.ProjectId,model.Id];
    }
    else if (_model.Id)
    {
        downloadUrl = [NSString stringWithFormat:@"%@%@?project=%@&id=%@",[Global Url],@"service/form/DownLoadFile.ashx",_model.Id,model.Id];
    }
    NSLog(@"mDetailModel.ext:%@",model.Extension);
    
    [fvc openFile:fileId url:downloadUrl ext:_ext];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
    {
        [self.nav pushViewController:fvc animated:YES];
    }
    else
    {
        //[self.nav pushViewController:fvc animated:YES];
        [self presentViewController:fvc animated:YES completion:nil];
    }

    
//    MaterialModel *model = (MaterialModel *)[_datasource objectAtIndex:indexPath.section];
//    MaterialItems *mDetailModel=[model.files objectAtIndex:indexPath.row];
//    NSString *fileId = [NSString stringWithFormat:@"%@_%@",model.instanceid,mDetailModel.identity];
////    _fileId = fileId;
////    
////   _ext = mDetailModel.ext;
////    [self loadMatrialUrlWithFileId:mDetailModel.identity];
//    
//    NSString *downloadUrl = [NSString stringWithFormat:@"%@?type=smartplan&action=getmaterial&fileId=%@",[Global serverAddress],mDetailModel.identity];
//   // NSLog(@"mDetailModel.ext:%@",mDetailModel.ext);
//    
//   [fvc openFile:fileId url:downloadUrl ext:mDetailModel.ext];
//    
////    [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController: fvc animated: YES completion:nil];
//
//    
//    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
//    {
//        [self.nav pushViewController:fvc animated:YES];
//    }
//    else
//    {
//        [self presentViewController:fvc animated:YES completion:nil];
//    }

}

//- (void)loadMatrialUrlWithFileId:(NSString *)fileId
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSDictionary *parameters;
//    
//  
//    parameters = @{@"type":@"smartplan",@"action":@"getmaterial",@"fileId":fileId};
//    //
//    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
//    [requestAddress appendString:@"?"];
//    
//    if (nil!=parameters) {
//        for (NSString *key in parameters.keyEnumerator) {
//            NSString *val = [parameters objectForKey:key];
//            [requestAddress appendFormat:@"&%@=%@",key,val];
//        }
//    }
//    
//    NSLog(@"材料链接%@",requestAddress);
//    
//    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD hideHUDForView:self.view];
//        NSString *url=@"";
//        NSDictionary *rs = (NSDictionary *)responseObject;
//        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
//             url=  [rs objectForKey:@"result"];
//            
//            
//            [self pushMaterialDetailViewWithUrl:url];
//            
//            
//        }
//     
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view];
//        
//        }];
//
//
//}

//- (void)pushMaterialDetailViewWithUrl:(NSString *)downloadUrl
//{
//    FileViewController *fvc = [[FileViewController alloc]init];
//   
////    NSString *downloadUrl = [NSString stringWithFormat:@"%@?type=smartplan&action=getmaterial&fileId=%@",[Global serverAddress],mDetailModel.identity];
////    // NSLog(@"mDetailModel.ext:%@",mDetailModel.ext);
//    
//    [fvc openFile:_fileId url:downloadUrl ext:_ext];
//    
//    
//    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
//    {
//        
//        [self.nav pushViewController:fvc animated:YES];
//        
//        
//        
//    }
//    else
//    {
//        [self presentViewController:fvc animated:YES completion:nil];
//        
//    }
//    
//
//}

//   //导航栏设置为不透明的
//self.nav.navigationBar.translucent = NO;
//
//    if (MainR.size.height==480) {
//        //
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//
//        //
//        ////
//    }
//
//

#pragma mark-PTreeHeaderFooterView代理方法

- (void)clickHeaderView
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






@end
