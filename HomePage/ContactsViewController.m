//
//  ContactsViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/12/22.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsModel.h"
#import "ContactsCell.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MBProgressHUD+MJ.h"
#import "DeviceInfo.h"
#import "ContactsPickerView.h"
#import "ZYPinYinSearch.h"
#import "HCSortString.h"

@interface ContactsViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchDataArray;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL isEditing;
@property(nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0  blue:206/255.0  alpha:1.0];
    [self initNavigationBarTitle:@"通讯录"];
    
    [self createTableViewAndSearchBar];
    [self loadData];
    
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    if (_isSearch || _isEditing) {
        _searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }else{
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        _tableView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    }
    
    [_tableView reloadData];
}

#pragma mark -- 创建 tableView && SearchBar

-(void)createTableViewAndSearchBar
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    //tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"ContactsCell" bundle:nil] forCellReuseIdentifier:@"ContactsCell"];
    [self.view addSubview:tableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    //设置输入颜色
    //searchBar.tintColor = [UIColor blackColor];
    //UIImage *image =[self imageWithColor:[UIColor whiteColor]];
    //设置搜索框的背景图片
    //[searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    //设置背景颜色
    //[searchBar setBarTintColor:GRAYCOLOR];
    searchBar.placeholder = @"搜索";
    searchBar.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0  blue:206/255.0  alpha:1.0].CGColor;
    searchBar.layer.borderWidth = 0.5;
    searchBar.delegate = self;
    searchBar.clearsContextBeforeDrawing = YES;
    //searchBar.showsCancelButton = NO;
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    //[searchBar sizeToFit];
    _searchBar = searchBar;
    
    [self.view addSubview:_searchBar];

    
}

-(void)loadData
{
    _dataArray = [NSMutableArray array];
    _searchDataArray = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //61.153.29.236:8891/mobileService/service/address.ashx
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/address.ashx"];
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *result = [responseObject objectForKey:@"result"];
        _markArray = [NSMutableArray array];
        _groupImgArray = [NSMutableArray array];
        for (int i=0; i<result.count; i++)
        {
            NSString *mark = @"";
            NSString *image = @"";
            mark = @"0";
            image = @"zhankai";
            [_groupImgArray addObject:image];
            [_markArray addObject:mark];
            
        }
        for (NSDictionary *dic in result) {
            ContactsModel *model = [[ContactsModel alloc] initWithDictionary:dic];
            [_dataArray addObject:model];
        }
        
        [_tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSLog(@"error:%@",error);
    }];
                                 
}

#pragma mark -- tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isSearch ? 1 : _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *mark = [_markArray objectAtIndex:section];
    
    if ([mark isEqualToString:@"1"])
    {
        return _isSearch ? _searchDataArray.count : [[_dataArray[section] users] count];
    }
    return _isSearch ? _searchDataArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_isSearch) {
        ChildrenModel *childModel = _searchDataArray[indexPath.row];
        cell.name.text = childModel.name;
        cell.phoneNumber.text = [NSString stringWithFormat:@"手机号: %@",childModel.ch];
        if (![childModel.dh isEqualToString:@""]) {
            cell.cornet.text = [NSString stringWithFormat:@"短号: %@",childModel.dh];
        }else{
            cell.cornet.text = @"";
        }
        
    }else{
        ContactsModel *model = _dataArray[indexPath.section];
        ChildrenModel *childModel = model.users[indexPath.row];
        cell.name.text = childModel.name;
        cell.phoneNumber.text = [NSString stringWithFormat:@"手机号: %@",childModel.ch];
        if (![childModel.dh isEqualToString:@""]) {
            cell.cornet.text = [NSString stringWithFormat:@"短号: %@",childModel.dh];
        }else{
            cell.cornet.text = @"";
        }
    }

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _isSearch ? 0.0 : 40.0;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 10.0;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footView = [[UIView alloc] init];
//    footView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
//    return footView;
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_dataArray[section] org];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainR.size.width, 40)];
    headerView.tag = section;
    headerView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:250/255.0 alpha:1.0];
    //headerView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    //headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *line_t =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 0.5)];
    line_t.backgroundColor = GRAYCOLOR_MIDDLE;
    //[headerView addSubview:line_t];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 39.5, MainR.size.width, 0.5)];
    line.backgroundColor = GRAYCOLOR_MIDDLE;
    [headerView addSubview:line];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainR.size.width-60, 40)];
    lab.textColor = BLUECOLOR;
    lab.font = [UIFont boldSystemFontOfSize:15];
    lab.text = [_dataArray[section] org];
    [headerView addSubview:lab];
    
    UIButton *groupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    groupBtn.frame = CGRectMake(CGRectGetMaxX(headerView.frame)-35, 25/2.0, 15, 15);
    groupBtn.enabled = NO;
    groupBtn.tag = section+1000;
    [headerView addSubview:groupBtn];
    [groupBtn setImage:[UIImage imageNamed:_groupImgArray[section]] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseHeader:)];
    [headerView addGestureRecognizer:tap];
    
    return headerView;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    // 提示：不要将webView添加到self.view，如果添加会遮挡原有的视图
    // 懒加载
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    
    ChildrenModel *childModel;
    if (_isSearch) {
        childModel = _searchDataArray[indexPath.row];
    }else{
        ContactsModel *model = _dataArray[indexPath.section];
        childModel = model.users[indexPath.row];
    }
    // 判断设备能否打电话
    if(!([[DeviceInfo deviceModel] isEqualToString:@"iPod touch"]||[[DeviceInfo deviceModel] isEqualToString:@"iPad"]||[[DeviceInfo deviceModel] isEqualToString:@"iPhone Simulator"])){
        
        // 只有手机号
        if ([childModel.dh isEqualToString:@""]||childModel.dh == nil) {
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",childModel.ch]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [_webView loadRequest:request];
        }
        // 有短号和手机号
        else{
            ContactsPickerView *pickerView = [[ContactsPickerView alloc] initWithFrame:SCREEN_BOUNDS withChildrenModel:childModel];
            // 拨打电话
            pickerView.selectedBlock = ^(NSString *phoneNumber)
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                [_webView loadRequest:request];
            };
            
            [pickerView showInView:self.view.window.rootViewController.view animated:YES];
            
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 先清空原来的搜索结果
    [_searchDataArray removeAllObjects];
    
    NSString *searchString = searchBar.text;
    //删除空格符
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    for (ContactsModel *model in _dataArray)
    {
        for (ChildrenModel *childrenModel in model.users)
        {
            if ([childrenModel.name rangeOfString:searchString].location != NSNotFound || [childrenModel.dh rangeOfString:searchString].location != NSNotFound || [childrenModel.ch rangeOfString:searchString].location != NSNotFound )
            {
                [_searchDataArray addObject:childrenModel];
            }
        }
    }
    if (searchText.length == 0) {
        _isSearch = NO;
    }else {
        _isSearch = YES;
    }
    [_tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 当前处于编辑状态
    _isEditing = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        _searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _searchBar.showsCancelButton = YES;
        // 状态栏颜色
        [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleDefault;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 状态栏颜色
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = NO;
    _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    _tableView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    _isSearch = NO;
    // 当前处于未编辑状态
    _isEditing = NO;
    
    [_tableView reloadData];
}

#pragma mark -- 防止搜索状态下tableView下面遮挡的问题

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == _tableView)
//    {
//        [self.view endEditing:YES];
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
