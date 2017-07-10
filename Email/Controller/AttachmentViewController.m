//
//  AttachmentViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "AttachmentViewController.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MBProgressHUD+MJ.h"
#import "materialListCell.h"
#import "AttachmentModel.h"
#import "FileViewController.h"

@interface AttachmentViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,FileViewerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) UIButton *tip;//无附件
@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong)NSString *fileId;
@property (nonatomic,strong)NSString *ext;


@end

@implementation AttachmentViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationItem.title = @"附件列表";
    [self initNavigationBarTitle:@"附件列表"];
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 50;
    
    [self.view addSubview:_tableView];
    
    
    
    [self loadData];
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation
{
    _tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64)/2.0);
    _tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
}

-(void)loadData
{
    _dataArray = [NSMutableArray array];
    
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 创建一个参数字典
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/Attachment.ashx"];

    NSDictionary *parameters = @{@"project":_model.tempId,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"附件:%@",requestAddress);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        NSArray *array= [rs objectForKey:@"result"];
        
        if (array.count)
        {
            for (NSDictionary *dict in array)
            {
                AttachmentModel *model = [[AttachmentModel alloc] initWithDictionary:dict];
                NSArray *name = [model.Name componentsSeparatedByString:@"."];
                NSString *Extension = [name lastObject];
                model.Extension = [NSString stringWithFormat:@".%@",Extension];
                [_dataArray addObject:model];
            }
        }
        else
        {
            // 无附件材料
            [self showNoneAttachmentTip];
        }
        
        [self.tableView reloadData];
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);

        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}

-(void)showNoneAttachmentTip
{
    if (!_tip) {
        
        UIButton *tip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tip.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64)/2.0);
        [tip setTitle:@"暂无附件材料!点击刷新" forState:UIControlStateNormal];
        [tip.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [tip setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        [tip addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
        _tip = tip;
        [self.view addSubview:tip];
    }
    
//    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64)/2.0);
//    tip.text = @"暂无附件材料!";
//    tip.textAlignment = NSTextAlignmentCenter;
//    tip.textColor = BLUECOLOR;
//    _tip = tip;
//    [self.view addSubview:tip];
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建自定制cell
    materialListCell *cell =[materialListCell cellWithTableView:tableView];
    
    AttachmentModel *model = _dataArray[indexPath.row];
    [cell setAttachmentModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileViewController *fvc = [[FileViewController alloc]init];
    fvc.fileViewDelegate = self;
    AttachmentModel *model=[_dataArray objectAtIndex:indexPath.row];
    NSString *fileId = [NSString stringWithFormat:@"%@",model.Name];
    _fileId = fileId;
    _ext = model.Extension;
    
    NSString *downloadUrl = [NSString stringWithFormat:@"%@%@?fn=%@&id=%@",[Global Url],@"service/mail/DownAttachment.ashx",_model.tempId,model.MailID];
    
    NSLog(@"mDetailModel.ext:%@",model.Extension);
    
    [fvc openFile:fileId url:downloadUrl ext:_ext];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
    {
        [self.navigationController pushViewController:fvc animated:YES];
    }
    else
    {
        [self presentViewController:fvc animated:YES completion:nil];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
