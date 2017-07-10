//
//  SearchDocViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/26.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SearchDocViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "PDetailViewController.h"
#import "BaseMessageVC.h"
#import "QueryCell.h"

@interface SearchDocViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIView *searchView;
@property(nonatomic,strong) UILabel *startLabel;
@property(nonatomic,strong) UILabel *finishLabel;
@property(nonatomic,strong) UITextField *nameText;
@property(nonatomic,strong) UITextField *companyText;
@property(nonatomic,strong) UIButton *searchBtn;
@property(nonatomic,strong) UIButton *clearBtn;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *projectNo;
@property(nonatomic,strong) NSString *type;

@property(nonatomic,strong) PDetailViewController *pDetail;
@property(nonatomic,strong) BaseMessageVC *baseMessage;

@end

@implementation SearchDocViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"公文查询";
    [self initNavigationBarTitle:@"公文查询"];
    
    [self createUI];
    // 查询权限(发文)
    [self loadQueryPermissions];
    
    _pageSize = 20;
    _dataArray = [NSMutableArray array];
    
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _startLabel.frame = CGRectMake(20, 20, 90, 40);
    _finishLabel.frame = CGRectMake(20, CGRectGetMaxY(_startLabel.frame)+20, 90, 40);
    _nameText.frame = CGRectMake(CGRectGetMaxX(_startLabel.frame), 20, MainR.size.width-130, 40);
    _companyText.frame = CGRectMake(CGRectGetMaxX(_finishLabel.frame), CGRectGetMaxY(_nameText.frame)+20, MainR.size.width-130, 40);
    
    CGFloat btn_W = (MainR.size.width-60)/2;
    _clearBtn.frame = CGRectMake(20, CGRectGetMaxY(_companyText.frame) + 50, btn_W, 40);
    _searchBtn.frame = CGRectMake(CGRectGetMaxX(_clearBtn.frame)+20, _clearBtn.frame.origin.y, btn_W, 40);
    
    self.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
    [self.tableView reloadData];
    
}

// 发文查询权限
-(void)loadQueryPermissions
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/gw/GwList.ashx"];
    NSDictionary *paremeters = @{@"type":@"qx",@"userId":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // 有权限
         if ([[responseObject objectForKey:@"result"] isEqual:@1])
         {
             _searchBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
             _searchBtn.enabled = YES;
             [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         }
         else
         {   // 没有权限
//             _searchBtn.backgroundColor = GRAYCOLOR;
//             [_searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//             _searchBtn.enabled = NO;
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@",error);
         
    }];
}

-(void)createUI
{
    UIView *searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _searchView = searchView;
    [self.view addSubview:searchView];
    
    //
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 90, 40)];
    startLabel.text = @"公文标题";
    startLabel.font = [UIFont boldSystemFontOfSize:17.5];
    startLabel.textColor = BLUECOLOR;
    _startLabel = startLabel;
    [self.view addSubview:startLabel];
    
    UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_startLabel.frame), 20, MainR.size.width-130, 40)];
    nameText.delegate = self;
    nameText.placeholder = @"请输入公文标题";
    nameText.clearButtonMode = UITextFieldViewModeAlways;
    nameText.borderStyle = UITextBorderStyleRoundedRect;
    nameText.returnKeyType = UIReturnKeyDone;
    _nameText = nameText;
    [searchView addSubview:nameText];
    
    //
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startLabel.frame)+20, 90, 40)];
    finishLabel.text = @"公文文号";
    finishLabel.font = [UIFont boldSystemFontOfSize:17.5];
    finishLabel.textColor = BLUECOLOR;
    _finishLabel = finishLabel;
    [self.view addSubview:finishLabel];
    
    UITextField *companyText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_finishLabel.frame), CGRectGetMaxY(nameText.frame)+20, MainR.size.width-130, 40)];
    companyText.delegate = self;
    companyText.placeholder = @"请输入公文文号";
    companyText.clearButtonMode = UITextFieldViewModeAlways;
    companyText.borderStyle = UITextBorderStyleRoundedRect;
    companyText.returnKeyType = UIReturnKeyDone;
    _companyText = companyText;
    [searchView addSubview:companyText];
    
    
    CGFloat btn_W = (MainR.size.width-60)/2;
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearBtn.frame = CGRectMake(20, CGRectGetMaxY(companyText.frame) + 50, btn_W, 40);
    [clearBtn setTitle:@"查询收文" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clearBtn.tag = 100;
    [clearBtn addTarget:self action:@selector(searchInfo:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.cornerRadius = 3;
    clearBtn.clipsToBounds = YES;
    _clearBtn = clearBtn;
    [searchView addSubview:clearBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(clearBtn.frame)+20, clearBtn.frame.origin.y, btn_W, 40);
    //searchBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    [searchBtn setTitle:@"查询发文" forState:UIControlStateNormal];
    //[searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.backgroundColor = GRAYCOLOR;
    [_searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    searchBtn.enabled = NO;
    searchBtn.tag = 101;
    [searchBtn addTarget:self action:@selector(searchInfo:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.cornerRadius = 3;
    searchBtn.clipsToBounds = YES;
    _searchBtn = searchBtn;
    [searchView addSubview:searchBtn];
}

#pragma mark -- 查询
-(void)searchInfo:(UIButton *)btn
{
    [self.view endEditing:YES];
    _searchView.hidden = YES;
    self.tableView.hidden = NO;
    
    if (btn.tag == 100)
    {
        //收文
        _type = @"sw";
    }
    else
    {
        //发文
        _type = @"fw";
    }
    _name = _nameText.text;
    _projectNo = _companyText.text;
    
    [_dataArray removeAllObjects];
    [self createTableView];
    [self loadData];
}

-(void)clearText
{
    _nameText.text = @"";
    _companyText.text = @"";
    
    self.tableView.hidden = YES;
    _searchView.hidden = NO;
}

#pragma mark -- textField代理
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([textField.text isEqualToString:@""])
//    {
//        self.tableView.hidden = YES;
//        _searchView.hidden = NO;
//    }
//    
//    return YES;
//}

#pragma mark -- 创建 tableView
-(void)createTableView
{
    if (!self.tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView = tableView;
        
        [tableView registerNib:[UINib nibWithNibName:@"QueryCell" bundle:nil] forCellReuseIdentifier:@"QueryCell"];
        [self.view addSubview:tableView];
    }
    
    
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        //_pageSize = 20;
        [self loadData];
    }];
    //上拉加载更多
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        _pageSize += 20;
        [self loadData];
    }];
    
//    UIButton *selectContacts = [self createButtonWithTitle:@"重新查询" andFrame:CGRectMake(0, 0, 80, 30)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectContacts];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新查询" style:UIBarButtonItemStylePlain target:self action:@selector(clearText)];
    
}

-(void)loadData
{
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/gw/GwList.ashx"];
    NSDictionary *paremeters = @{@"type":_type,@"name":_name,@"sh":_projectNo,@"index":@"0",@"size":[NSString stringWithFormat:@"%ld",(long)_pageSize],@"user":[Global userName],@"uid":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        NSArray *arr = [responseObject objectForKey:@"result"];
        for (NSDictionary *dic in arr)
        {
            SPDetailModel *model = [[SPDetailModel alloc] initWithDict:dic];
            if (![model.name isEqualToString:@""])
            {
                [_dataArray addObject:model];
            }
        }
        
        [self.tableView reloadData];
         
         // 暂无数据
         _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
         //加载提示框
         [MBProgressHUD hideHUDForView:self.view animated:NO];

        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);

        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
    
}

#pragma -mark  UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell"];
    if(_dataArray.count > indexPath.row)
    {
        SPDetailModel *model = _dataArray[indexPath.row];
        cell.title.text = model.name;
    }
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count > indexPath.row)
    {
        CGFloat cellHeight = [self GetCellHeightWithContent:[_dataArray[indexPath.row] name]];
        if (cellHeight > 44.0)
        {
            return cellHeight;
        }
        
    }
    return 44.0;
}

-(CGFloat)GetCellHeightWithContent:(NSString *)content
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MainR.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil];
    return rect.size.height + 10;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    PDetailViewController *pDetail = [[PDetailViewController alloc] init];
    pDetail.spOrgw = @"gw";
    //提前初始化basemessage(为了设置代理为SPDetailVC)
    BaseMessageVC  *baseMess = [[BaseMessageVC alloc] init];
    //baseMess.sendDelegate = self;
    baseMess.spOrgw = @"gw";
    baseMess.Id = @"gwcx";
    _baseMessage = baseMess;
    _pDetail =pDetail;
    pDetail.baseMessage = _baseMessage;
    
    SPDetailModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [pDetail setModel:model];
    
    
    [self.navigationController pushViewController:pDetail animated:YES];
    
}

// customButton
-(UIButton *)createButtonWithTitle:(NSString *)title andFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BLUECOLOR;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:14.5];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


@end
