//
//  PrintFromViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "PrintFromViewController.h"
#import "SPViewController.h"
#import "FormsCell.h"
#import "SPDetailModel.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MBProgressHUD+MJ.h"
#import "PrintFromModel.h"
#import "FormViewController.h"
#import "BaseInfoModel.h"
#import "BaseMessageCell.h"

@interface PrintFromViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) BaseInfoModel *baseInfoModel;
@property(nonatomic,strong) NSArray *formIdArray;//表单Id
@property(nonatomic,strong) NSMutableArray *baseInfoArray;//表单数据
@property(nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标
@property(nonatomic,strong) UIImageView *headImage;//头部图标

@end

@implementation PrintFromViewController


-(void)loadData
{
    _baseInfoArray = [NSMutableArray array];
    
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    /**
     *  表单
     */
    // 1.表单数据需要先请求
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/FormList.ashx"];
    NSDictionary *parameters = [NSDictionary dictionary];
    if (_model.ProjectId)
    {
        parameters = @{@"project":_model.ProjectId,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    }
    else if (_model.Id)
    {
        parameters = @{@"project":_model.Id,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    }
    
    // 1.表单数据需要先请求
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        _formIdArray = [dic objectForKey:@"result"];
        
        if (_formIdArray.count)
        {
            _markArray = [NSMutableArray array];
            _groupImgArray = [NSMutableArray array];
            for (int i=0; i<_formIdArray.count; i++)
            {
                NSString *mark = @"";
                NSString *image = @"";
                mark = @"0";
                image = @"zhankai";
                [_groupImgArray addObject:image];
                [_markArray addObject:mark];
                
            }
            
            
            for (int i=0; i<_formIdArray.count; i++)
            {
                NSString *Id = [_formIdArray[i] objectForKey:@"Id"];
                NSString *ProjectId = [_formIdArray[i] objectForKey:@"ProjectId"];
                NSString *BusiFormId = [_formIdArray[i] objectForKey:@"BusiFormId"];
                
                NSDictionary *parameters = @{@"form":Id,@"busiFormId":BusiFormId,@"project":ProjectId,@"user":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
                NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/FormDetail.ashx"];
                
                // 2.表单信息
                [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
                    
                    // 每个表单信息
                    NSMutableArray *baseArray = [NSMutableArray array];
                    
                    for (NSDictionary *dic in [responseObject objectForKey:@"result"])
                    {
                        _baseInfoModel = [[BaseInfoModel alloc] initWithDictionary:dic];
                        if (![_baseInfoModel.text isEqualToString:@""]) {
                            
                            [baseArray addObject:_baseInfoModel];
                        }
                        
                    }
                    [_baseInfoArray addObject:baseArray];
                    [_tableView reloadData];
                    
                    //加载提示框
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"%@",error);
                }];
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];

    }];
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // self.navigationItem.title = @"项目表单";
    [self initNavigationBarTitle:@"项目表单"];

    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"BaseMessageCell" bundle:nil] forCellReuseIdentifier:@"BaseMessageCell"];
    
    
    [self.view addSubview:_tableView];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFroms) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    
}
//屏幕旋转结束执行的方法
- (void)changeFroms
{
    //self.view.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
    self.tableView.frame=CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.tableView reloadData];
}

#pragma -- tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _formIdArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *mark = [_markArray objectAtIndex:section];
    
    if ([mark isEqualToString:@"1"])
    {
        NSArray *array = _baseInfoArray[section];
        return array.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseMessageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _baseInfoModel = _baseInfoArray[indexPath.section][indexPath.row];
    cell.title.text = _baseInfoModel.text;
    cell.detailTitle.text = _baseInfoModel.value;
    
//    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(15, cell.frame.size.height-0.5, MainR.size.width, 0.5)];
//    line.backgroundColor = GRAYCOLOR_MIDDLE;
//    [cell.contentView addSubview:line];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _baseInfoModel = _baseInfoArray[indexPath.section][indexPath.row];
    CGFloat cellHeight = [self GetCellHeightWithContent:[_baseInfoModel value]];
    if (cellHeight >= 44.0)
    {
        return cellHeight;
    }
    
    return 44.0;
}

- (CGFloat)GetCellHeightWithContent:(NSString *)content
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MainR.size.width-180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height + 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0;
    }
    return 10.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [_formIdArray[section] objectForKey:@"Name"];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];

    return footView;
}
//头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    headView.tag = section;
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView *line_t =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 0.5)];
    line_t.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line_t];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 44.5, MainR.size.width, 0.5)];
    line.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line];
    
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.frame = CGRectMake(15, 25/2.0, 20, 20);
    headImage.image = [UIImage imageNamed:@"baiodan"];
    [headView addSubview:headImage];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+10, 0, MainR.size.width-90, 45)];
    lab.font = [UIFont boldSystemFontOfSize:16.0];
    lab.textColor = BLUECOLOR;
    [headView addSubview:lab];
    
    UIButton *groupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    groupBtn.frame = CGRectMake(CGRectGetMaxX(headView.frame)-35, 30/2.0, 15, 15);
    groupBtn.enabled = NO;
    groupBtn.tag = section+1000;
    [headView addSubview:groupBtn];
    
    lab.text = [NSString stringWithFormat:@"%@",[_formIdArray[section] objectForKey:@"Name"]];
    [groupBtn setImage:[UIImage imageNamed:_groupImgArray[section]] forState:UIControlStateNormal];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseHeader:)];
    [headView addGestureRecognizer:tap];
    return headView;
}

//打开关闭分组
-(void)openOrCloseHeader:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    
    //UIButton *btn = (UIButton *)[tapView viewWithTag:tapView.tag+1000];
    //NSLog(@"tag: %ld, %@",(long)btn.tag,btn);
    NSString *mark = _markArray[tapView.tag];
    
    if ([mark isEqualToString:@"0"]) {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"1"];
        [UIView animateWithDuration:0.5 animations:^{
            //            [btn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"xiangshang"];
        }];
    }
    else
    {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"0"];
        [UIView animateWithDuration:0.5 animations:^{
            //[btn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"zhankai"];
        }];
    }
    
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
