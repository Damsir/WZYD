//
//  SearchViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SearchViewController.h"
#import "PDetailViewController.h"
#import "BaseMessageVC.h"
#import "SendViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "QueryCell.h"
#import "ProjectsViewController.h"

@interface SearchViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SendViewDelegate>

@property(nonatomic,strong) UILabel *startLabel;
@property(nonatomic,strong) UILabel *finishLabel;
@property(nonatomic,strong) UILabel *contextLabel;
@property(nonatomic,strong) UILabel *zhengNoLabel;
@property(nonatomic,strong) UITextField *nameText;
@property(nonatomic,strong) UITextField *companyText;
@property(nonatomic,strong) UITextField *addressText;
@property(nonatomic,strong) UITextField *zhengNoText;
@property(nonatomic,strong) UIButton *searchBtn;
@property(nonatomic,strong) UIButton *clearBtn;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,strong) PDetailViewController *pDetail;
@property(nonatomic,strong) BaseMessageVC *baseMessage;
@property(nonatomic,strong) NSString *name;//项目名称
@property(nonatomic,strong) NSString *company;//建设单位
@property(nonatomic,strong) NSString *address;//建设地址
@property(nonatomic,strong) NSString *zhengNo;//证书编号;

@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"项目查询";
    [self initNavigationBarTitle:@"项目查询"];
    
    [self createUI];
    
    _name = @"";
    _company = @"";
    _address = @"";
    _zhengNo = @"";
    _pageSize = 20;
    _dataArray = [NSMutableArray array];

    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _startLabel.frame = CGRectMake(20, 20, 90, 40);
    _finishLabel.frame = CGRectMake(20, CGRectGetMaxY(_startLabel.frame)+20, 90, 40);
    _contextLabel.frame = CGRectMake(20, CGRectGetMaxY(_finishLabel.frame)+20, 90, 40);
    _nameText.frame = CGRectMake(CGRectGetMaxX(_startLabel.frame), 20, MainR.size.width-130, 40);
    _companyText.frame = CGRectMake(CGRectGetMaxX(_finishLabel.frame), CGRectGetMaxY(_nameText.frame)+20, MainR.size.width-130, 40);
    _addressText.frame = CGRectMake(CGRectGetMaxX(_contextLabel.frame), CGRectGetMaxY(_companyText.frame)+20, MainR.size.width-130, 40);
    _zhengNoLabel.frame = CGRectMake(20, CGRectGetMaxY(_contextLabel.frame)+20, 90, 40);
    _zhengNoText.frame = CGRectMake(CGRectGetMaxX(_zhengNoLabel.frame), CGRectGetMaxY(_addressText.frame)+20, MainR.size.width-130, 40);
    
    CGFloat btn_W = (MainR.size.width-60)/2;
    _clearBtn.frame = CGRectMake(20, CGRectGetMaxY(_zhengNoText.frame) + 50, btn_W, 40);
    _searchBtn.frame = CGRectMake(CGRectGetMaxX(_clearBtn.frame)+20, _clearBtn.frame.origin.y, btn_W, 40);
    
}

-(void)createUI
{
    //
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 90, 40)];
    startLabel.text = @"项目名称";
    startLabel.font = [UIFont boldSystemFontOfSize:17.5];
    startLabel.textColor = BLUECOLOR;
    _startLabel = startLabel;
    [self.view addSubview:startLabel];
    
    UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame), 20, MainR.size.width-130, 40)];
    nameText.delegate = self;
    nameText.placeholder = @"请输入项目名称";
    nameText.clearButtonMode = UITextFieldViewModeAlways;
    nameText.borderStyle = UITextBorderStyleRoundedRect;
    nameText.returnKeyType = UIReturnKeyDone;
    _nameText = nameText;
    [self.view addSubview:nameText];
    
    //
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startLabel.frame)+20, 90, 40)];
    finishLabel.text = @"建设单位";
    finishLabel.font = [UIFont boldSystemFontOfSize:17.5];
    finishLabel.textColor = BLUECOLOR;
    _finishLabel = finishLabel;
    [self.view addSubview:finishLabel];
    
    UITextField *companyText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(finishLabel.frame), CGRectGetMaxY(nameText.frame)+20, MainR.size.width-130, 40)];
    companyText.delegate = self;
    companyText.placeholder = @"请输入建设单位";
    companyText.clearButtonMode = UITextFieldViewModeAlways;
    companyText.borderStyle = UITextBorderStyleRoundedRect;
    companyText.returnKeyType = UIReturnKeyDone;
    _companyText = companyText;
    [self.view addSubview:companyText];
    
    //
    UILabel *contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(finishLabel.frame)+20, 90, 40)];
    contextLabel.text = @"建设地址";
    contextLabel.font = [UIFont boldSystemFontOfSize:17.5];
    contextLabel.textColor = BLUECOLOR;
    _contextLabel = contextLabel;
    [self.view addSubview:contextLabel];
    
    UITextField *addressText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contextLabel.frame), CGRectGetMaxY(companyText.frame)+20, MainR.size.width-130, 40)];
    addressText.delegate = self;
    addressText.placeholder = @"请输入建设地址";
    addressText.clearButtonMode = UITextFieldViewModeAlways;
    addressText.borderStyle = UITextBorderStyleRoundedRect;
    addressText.returnKeyType = UIReturnKeyDone;
    _addressText = addressText;
    [self.view addSubview:addressText];
    
    //
    UILabel *zhengNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contextLabel.frame)+20, 90, 40)];
    zhengNoLabel.text = @"证书编号";
    zhengNoLabel.font = [UIFont boldSystemFontOfSize:17.5];
    zhengNoLabel.textColor = BLUECOLOR;
    _zhengNoLabel = zhengNoLabel;
    [self.view addSubview:zhengNoLabel];
    
    UITextField *zhengNoText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zhengNoLabel.frame), CGRectGetMaxY(addressText.frame)+20, MainR.size.width-130, 40)];
    zhengNoText.delegate = self;
    zhengNoText.placeholder = @"请输入证书编号";
    zhengNoText.clearButtonMode = UITextFieldViewModeAlways;
    zhengNoText.borderStyle = UITextBorderStyleRoundedRect;
    zhengNoText.returnKeyType = UIReturnKeyDone;
    _zhengNoText = zhengNoText;
    [self.view addSubview:zhengNoText];
    
    
    CGFloat btn_W = (MainR.size.width-60)/2;
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearBtn.frame = CGRectMake(20, CGRectGetMaxY(zhengNoText.frame) + 50, btn_W, 40);
    [clearBtn setTitle:@"重置" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    clearBtn.layer.borderWidth = 1;
    clearBtn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0].CGColor;
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.cornerRadius = 3;
    clearBtn.clipsToBounds = YES;
    _clearBtn = clearBtn;
    [self.view addSubview:clearBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(clearBtn.frame)+20, clearBtn.frame.origin.y, btn_W, 40);
    searchBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    searchBtn.layer.borderWidth = 1;
    searchBtn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0].CGColor;
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchInfo) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.cornerRadius = 3;
    searchBtn.clipsToBounds = YES;
    _searchBtn = searchBtn;
    [self.view addSubview:searchBtn];
}

#pragma mark -- 查询
-(void)searchInfo
{
    [self.view endEditing:YES];
    NSDictionary *searchInfoDic = @{@"name":_nameText.text,@"company":_companyText.text,@"address":_addressText.text,@"zhengNo":_zhengNoText.text};
    
    ProjectsViewController *projestsVC = [[ProjectsViewController alloc] init];
    
    projestsVC.searchInfoDic = searchInfoDic;
    
    projestsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:projestsVC animated:YES];
    
    //
//    _name = _nameText.text;
//    _company = _companyText.text;
//    _address = _addressText.text;
//    self.tableView.hidden = NO;
//    [_dataArray removeAllObjects];
//    [self createTableView];
//    [self loadData];
    
}

-(void)clearText
{
    [self.view endEditing:YES];
    _nameText.text = @"";
    _companyText.text = @"";
    _addressText.text = @"";
    _zhengNoText.text = @"";
    self.tableView.hidden = YES;
}

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
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //61.153.29.236:8891/mobileService/service/project/Project.ashx?userID=580&pageIndex=0&pageSize=20&businessname=&projName=&buildOrg=&buildAddr=&deviceNumber=c9e9163d-5619-3b91-af06-34cb890c496f&username=李卫

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/project/Project.ashx"];
    NSDictionary *paremeters = @{@"userID":[Global userId],@"pageIndex":@"0",@"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageSize],@"businessname":@"",@"projName":_name,@"buildOrg":_company,@"buildAddr":_address,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [JsonDic objectForKey:@"result"];
        for (NSDictionary *dic in arr)
        {
            SPDetailModel *model = [[SPDetailModel alloc] initWithDict:dic];
            [_dataArray addObject:model];
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
        cell.title.text = model.projName;
        
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count > indexPath.row)
    {
        CGFloat cellHeight = [self GetCellHeightWithContent:[_dataArray[indexPath.row] projName]];
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
    _selectedIndex = indexPath.row;
    
    PDetailViewController *pDetail = [[PDetailViewController alloc] init];
    pDetail.spOrgw = @"sp";
    //提前初始化basemessage(为了设置代理为SPDetailVC)
    BaseMessageVC  *baseMess = [[BaseMessageVC alloc] init];
    baseMess.sendDelegate = self;
    baseMess.Id = @"xmcx";
    _baseMessage = baseMess;
    _pDetail =pDetail;
    pDetail.baseMessage = _baseMessage;
    
    SPDetailModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [pDetail setModel:model];
    
    
    [self.navigationController pushViewController:pDetail animated:YES];
    
}

// customButton
-(UIButton *)createButtonWithImage:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame andTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BLUECOLOR;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInsets];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 50)];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.highlighted = NO;
    button.adjustsImageWhenHighlighted = NO;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(searchOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)sendViewDidSendCompleted
{
    
}

#pragma mark -- textField代理
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField == _startText)
//    {
//        [self selectTimePicker:_startText];
//    }
//    else if (textField == _finishText)
//    {
//        [self selectTimePicker:_finishText];
//    }
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


@end
