
//
//  MaterialViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "MeetingMaterialVC.h"

#import "PTreeHeaderFooterView.h"
#import "AFNetworking.h"
#import "SPDetailModel.h"
#import "Global.h"
#import "MaterialModel.h"
#import "MBProgressHUD+MJ.h"
#import "materialListCell.h"
#import "MaterialItems.h"
#import "FileViewController.h"
#import "MeetingMaterialModel.h"
#import "MJExtension.h"
#import "MeetingMaterialModel.h"
#import "FormViewController.h"

@interface MeetingMaterialVC ()<UITableViewDelegate,UITableViewDataSource,PTreeHeaderFooterViewDelegate,FileViewerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) MeetingMaterialModel *materialModel;
@property(nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property (nonatomic,strong)UIButton *loadBtn;
@property (nonatomic,strong)UILabel *tipLabel;

@end

@implementation MeetingMaterialVC

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}
- (void)transFromMeetingId:(NSString *)meetingId
{
    self.meetingId = meetingId;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-114) style:UITableViewStylePlain];
    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 45;
    
    [self.view addSubview:_tableView];
    
}
//屏幕旋转改变视图的Frame
-(void)screenRotation
{
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-114);
    
    _loadBtn.frame =CGRectMake((MainR.size.width-150)*0.5, (MainR.size.height-200)*0.5-50, 150, 200);
    _tipLabel.frame =CGRectMake((MainR.size.width-150)*0.5,CGRectGetMaxY(_loadBtn.frame)-44, _loadBtn.frame.size.width,44);
    [_tableView reloadData];
}

-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"smartplan";
    params[@"action"] = @"meetingmateriallist";
    //    MaterialResultModel *model =_materialModel.result[0];
    
    params[@"meetingId"] = _meetingId;
    
    [manager POST:[Global serverAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求成功
        if ([[responseObject objectForKey:@"success"] isEqualToString:@"true"])
        {
            
            _materialModel = [[MeetingMaterialModel alloc] mj_setKeyValues:operation.responseString];
            // NSLog(@"%@",responseObject);
            
            //分组标记
            _markArray = [[NSMutableArray alloc] init];
            if (_materialModel.result.count)
            {
                for (int i=0; i<_materialModel.result.count; i++) {
                    NSString *mark = @"0";
                    [_markArray addObject:mark];
                }
            }
            else
            {
                if (!_loadBtn)
                {
                    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    loadBtn.frame =CGRectMake((MainR.size.width-150)*0.5, (MainR.size.height-200)*0.5-50, 150, 200);
                    [loadBtn setImage:[UIImage imageNamed:@"nofav"]  forState:UIControlStateNormal];
                    [loadBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 44,0)];
                    [loadBtn addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
                    _loadBtn = loadBtn;
                    [self.view addSubview:_loadBtn];
                    
                    UILabel *tipLabel =[[UILabel alloc] initWithFrame:CGRectMake((MainR.size.width-150)*0.5,CGRectGetMaxY(loadBtn.frame)-44, _loadBtn.frame.size.width,44)];
                    [tipLabel setText:@"暂时没有会议材料!!点击刷新"];
                    [tipLabel setFont:[UIFont systemFontOfSize:12]];
                    [tipLabel setTextAlignment:NSTextAlignmentCenter];
                    [tipLabel setTextColor:[UIColor lightGrayColor]];
                    _tipLabel =tipLabel;
                    [self.view addSubview:_tipLabel];
                    
                }
                [MBProgressHUD showSuccess:@"没有会议材料资料"];
            }
            
            [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
}

#pragma mark - Tableview datasource & delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = _materialModel.result.count;
    return  count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *mark = [_markArray objectAtIndex:section];
    
    if ([mark isEqualToString:@"1"])
    {
        NSInteger count = [_materialModel.result[section] MaterialList].count;
        return count;
    }
    
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建自定制cell
    materialListCell *cell =[materialListCell cellWithTableView:tableView];
    
    [cell setMaterialListModel:[_materialModel.result[indexPath.section] MaterialList][indexPath.row]];
    
    
    return cell;
}
#pragma mark -tabelViewDelge代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.tag = section;
    headView.backgroundColor = GRAYCOLOR_LIGHT;
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.frame = CGRectMake(0, 0, MainR.size.width, 45);
    [headView addSubview:backV];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    imageView.image = [UIImage imageNamed:@"fileicon"];
    [headView addSubview:imageView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, MainR.size.width-60, 45)];
    lab.text = [NSString stringWithFormat:@"%@  (%ld)", [_materialModel.result[section] ProjectName],(unsigned long)[_materialModel.result[section] MaterialList].count];
    [headView addSubview:lab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseHeader:)];
    [headView addGestureRecognizer:tap];
    return headView;
}
//打开关闭分组
-(void)openOrCloseHeader:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    NSString *mark = _markArray[tapView.tag];
    
    if ([mark isEqualToString:@"0"])
    {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"1"];
    }
    else
    {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"0"];
        
    }
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileViewController *fvc = [[FileViewController alloc]init];
    //    fvc.fileViewDelegate = self;
    
    MaterialResultModel *modelR =self.materialModel.result[indexPath.section];
    MaterialList *modelList = modelR.MaterialList[indexPath.row];
    NSString *fileId = [NSString stringWithFormat:@"%@_%@",modelR.Id,modelList.MaterialDetials];
    
    NSString *materialName=modelList.MaterialName;
    NSArray *arr=[materialName componentsSeparatedByString:@"."];
    if (arr.count > 1)
    {
        NSString *str =[arr lastObject];
        NSString *ext =[@"." stringByAppendingString:str];
        NSString *downloadUrl=@"";
        if([modelList.MaterialDetials isEqualToString:@""])
        {
            downloadUrl= [NSString stringWithFormat:@"%@?type=smartplan&action=getMeetingmaterial&fileId=%@",[Global serverAddress],modelList.ID];
        }
        else
        {
            
            downloadUrl = [NSString stringWithFormat:@"%@?type=smartplan&action=getmaterial&fileId=%@",[Global serverAddress],modelList.MaterialDetials];
            
        }
        [fvc openFile:fileId url:downloadUrl ext:ext];
        //[[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController: fvc animated: YES completion:nil];
        //[self.nav pushViewController:fvc animated:YES];
        if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
        {
            
            [self.nav pushViewController:fvc animated:YES];
        }
        else
        {
            //                    [self presentViewController:fvc animated:YES completion:nil];
            //[self.view.window.rootViewController presentViewController:fvc animated:YES completion:nil];
            //[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:fvc animated:YES completion:nil];
            id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.window.rootViewController presentViewController:fvc animated:YES completion:nil];
        }
        
        
        
        
    }
    else
    {
        
        FormViewController *formView = [[FormViewController alloc] initWithNibName:@"FormViewController" bundle:nil];
        NSDictionary *dict = @{@"identity":modelList.MaterialDetials,@"project":modelList.projectId,@"busiFormId":modelR.createUserId,@"name":modelList.MaterialName};
        [formView projectInfo:dict];
        formView.meetingForm = 1;
        formView.tab = self.tabBarController;
        [self.nav pushViewController:formView animated:YES];
        //[self presentViewController:formView animated:YES completion:nil];
        if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
        {
            [self.nav pushViewController:formView animated:YES];
        }
        else
        {
            //[self.view.window.rootViewController presentViewController:fvc animated:YES completion:nil];
            //[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:fvc animated:YES completion:nil];
            id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.window.rootViewController presentViewController:formView animated:YES completion:nil];
            //[self presentViewController:formView animated:YES completion:nil];
        }
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.5;
}

#pragma mark-PTreeHeaderFooterView代理方法

- (void)clickHeaderView
{
    [self.tableView reloadData];
    
}

-(void)layoutSubViews
{
    //    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
    //    self.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-50);
    //    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
