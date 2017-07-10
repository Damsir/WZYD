//
//  ComprehensiveVC.m
//  XAYD
//
//  Created by songdan Ye on 16/2/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ComprehensiveVC.h"
#import "SHSearchBar.h"
#import "SearchMore.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "SPDetailCell.h"
#import "ComprehensiveModel.h"
#import "DY_searchHistoryDataBase.h"
#import "PDetailViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"


@interface ComprehensiveVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>


@property (nonatomic,strong)NSString *string;

@property (nonatomic,strong)NSString *pageIndex;

@property (nonatomic,strong)NSString *pageSize;

@end

@implementation ComprehensiveVC

- (NSMutableArray *)dataSourceArray
{
    if (_dataSourceArray==nil) {
        _dataSourceArray =[NSMutableArray array];
    }
    return _dataSourceArray;

}

- (NSMutableArray *)hisData
{
    if (_hisData == nil) {
        _hisData =[NSMutableArray array];
    }
    return _hisData;


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden= YES;

}

- (void)searchAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _string = self.searchBar.searchTextField.text;
    NSDictionary *parameters = @{@"pageindex":self.pageIndex,@"querystring":self.searchBar.searchTextField.text,@"queryjson":@"",@"type":@"smartplan",@"pagesize":self.pageSize,@"action":@"queryproject"};
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=parameters)
    {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"综合%@",requestAddress);

    [MBProgressHUD showMessage:@"正在加载" toView:self.view];

    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ComprehensiveModel *spModel;
        NSMutableArray *mulA=[NSMutableArray array];
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            spModel =[[ComprehensiveModel alloc] mj_setKeyValues:operation.responseString];

            for (searchResultModel *model in spModel.result)
            {
                [mulA addObject:model];
                
            }
            _dataSourceArray =[mulA copy];
            self.historyTabelView.searchResultCount = _dataSourceArray.count;
            [self.historyTabelView reloadData];
            [self.searchResultTabelView reloadData];
        }
       
        
        if(self.dataSourceArray.count == 0)
        {
            self.searchResultTabelView.hidden = YES;
            [self showWithoutDataAndHiden:NO];
        
        }else
        {
            self.searchResultTabelView.hidden = NO;
            [self showWithoutDataAndHiden:YES];
        }
        [_searchResultTabelView.header endRefreshing];
        [_searchResultTabelView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [_searchResultTabelView.header endRefreshing];
        [_searchResultTabelView.footer endRefreshing];
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = @"0";
    _pageSize = @"166";
    
    //初始化导航栏;
    [self initNav];
    //创建是搜索栏
    self.searchBar  = [[DY_newSearchBar alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 50)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    //初始化搜索历史tableView
    [self createHistoryTableView];
    //初始化tableView
    [self createWithResultTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeComS) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self searchAction];
}
//屏幕旋转结束执行的方法
- (void)changeComS
{
    self.searchBar.frame=CGRectMake(0, 0, MainR.size.width, 50);
    self.historyTabelView.frame=CGRectMake(0, self.searchBar.frame.size.height, MainR.size.width, (MainR.size.height-64-self.searchBar.frame.size.height)/2);
    if (self.searchBar.frame.size.height+self.historyTabelView.historyArray.count*40+30+44 <= (MainR.size.height-64-self.searchBar.frame.size.height)/2)
    {
        self.searchResultTabelView.frame = CGRectMake(0,self.searchBar.frame.size.height+self.historyTabelView.historyArray.count*40+30+44, MainR.size.width,MainR.size.height-self.searchBar.frame.size.height-64-(self.historyTabelView.historyArray.count*40+30+44));
        _loadBtn.frame =CGRectMake((MainR.size.width-150)*0.5, self.searchBar.frame.size.height+self.historyTabelView.historyArray.count*40+30+44+20, 150, 200);
    }
    else
    {
        self.searchResultTabelView.frame = CGRectMake(0,(MainR.size.height-64-self.searchBar.frame.size.height)/2+self.searchBar.frame.size.height, MainR.size.width,MainR.size.height-(MainR.size.height-64-self.searchBar.frame.size.height)/2-64-self.searchBar.frame.size.height);
        _loadBtn.frame =CGRectMake((MainR.size.width-150)*0.5, (MainR.size.height-64-self.searchBar.frame.size.height)/2+self.searchBar.frame.size.height+20, 150, 200);
    }
    _tipLable.frame= CGRectMake((MainR.size.width-150-30)*0.5,CGRectGetMaxY(_loadBtn.frame)-44, _loadBtn.frame.size.width+30,44);

    
    if (self.historyTabelView.hidden)
    {
        [self.historyTabelView reloadData];

    }
    if (self.searchResultTabelView.hidden) {
        
        [self.searchResultTabelView reloadData];
    }
    
}
//初始化搜索历史栏
- (void)createHistoryTableView
{
    self.historyTabelView =[[DY_historyTableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height, MainR.size.width, (MainR.size.height-64-self.searchBar.frame.size.height)/2)];

    [self.view addSubview:self.historyTabelView];
    __weak typeof(self)weakSelf = self;
    self.historyTabelView.bgeinDraggingBlock = ^(){
        [weakSelf.searchBar.searchTextField resignFirstResponder];
    };
    //设置选中历史cell 的block
    self.historyTabelView.selectHistoryCell = ^(NSString *string)
    {
        [weakSelf searchDataWithInputString:string];
    };
    self.historyTabelView.deleteHistoryRecordBlock = ^(BOOL isDeleteHistory)
    {
        [weakSelf changeResultTableViewFrame];
    };
    
    
}
//初始化搜索结果tableView
-(void)createWithResultTableView{
    //439
    self.searchResultTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.searchBar.frame.size.height+self.historyTabelView.historyArray.count*40+30+44, MainR.size.width,MainR.size.height-self.searchBar.frame.size.height-64-(self.historyTabelView.historyArray.count*40+30+44)) style:UITableViewStylePlain];
    self.searchResultTabelView.hidden = NO;
    self.searchResultTabelView.dataSource = self;
    self.searchResultTabelView.delegate = self;
    self.searchResultTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchResultTabelView];
    
    [self changeResultTableViewFrame];
    //self.searchResultTabelView.tableHeaderView = self.historyTabelView;
    //..下拉刷新
    self.searchResultTabelView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _pageIndex = @"0";
        [self searchAction];
    }];
    
    //..上拉刷新
    self.searchResultTabelView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageSize = [NSString stringWithFormat:@"%d",[_pageSize intValue] + 20];
        [self searchAction];
        
    }];
    
}

//初始化导航栏
- (void)initNav
{
    //设置导航栏标题
    self.navigationItem.title = @"综合查询";
    //搜索
    UIButton *sBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    sBtn.frame = CGRectMake(0, 0, 80, 40);
    [sBtn setTitle:@"高级搜索" forState:UIControlStateNormal];
    [sBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sBtn addTarget:self action:@selector(OnTapsBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:sBtn];

}

//高级搜索
- (void)OnTapsBtn:(UIButton *)btn
{
    [self.view endEditing:YES];

    SearchMore *sM =[[SearchMore alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:sM animated:YES];
    
    
    if (_loadBtn !=nil) {
        _loadBtn.hidden= YES;
        _tipLable.hidden= YES;
    }
    

}

//  没有数据
- (void)showWithoutDataAndHiden:(BOOL)hiden
{
    
    if (!_loadBtn) {
        UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //loadBtn.frame =CGRectMake((MainR.size.width-150)*0.5, (MainR.size.height-200)*0.5-50, 150, 200);
        loadBtn.frame =CGRectMake((MainR.size.width-150)*0.5, self.searchBar.frame.size.height+self.historyTabelView.historyArray.count*40+30+44+20, 150, 200);
        [loadBtn setImage:[UIImage imageNamed:@"nofav"]  forState:UIControlStateNormal];
        [loadBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 44,0)];
        _loadBtn = loadBtn;
        [self.view addSubview:_loadBtn];

    }
    if (!_tipLable) {
        UILabel *tipLabel =[[UILabel alloc] init];
        [tipLabel setText:@"没有对应的数据"];
        [tipLabel setFont:[UIFont systemFontOfSize:12]];
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
       // tipLabel.frame= CGRectMake((MainR.size.width-150-30)*0.5,CGRectGetMaxY(_loadBtn.frame)-44, _loadBtn.frame.size.width+30,44);
        tipLabel.frame= CGRectMake((MainR.size.width-150-30)*0.5,CGRectGetMaxY(_loadBtn.frame)-44, _loadBtn.frame.size.width+30,44);

        [tipLabel setTextColor:[UIColor lightGrayColor]];
        _tipLable =tipLabel;
        [self.view addSubview:_tipLable];


    }
    _loadBtn.hidden = hiden;
    _tipLable.hidden = hiden;


}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return _dataSourceArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (tableView.tag == 100) {
//        NSString *indentifierCell=@"Cell";
//        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifierCell];
//        if (cell==nil) {
//            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifierCell];
//        }
////        for (UIView *view in cell.contentView.subviews) {
////            [view removeFromSuperview];
////        }
////
//        cell.imageView.image =[UIImage imageNamed:@"search"];
//        cell.textLabel.text = [self.hisData objectAtIndex:indexPath.row];
//
//        return cell;
//    }
    SPDetailCell *spCell ;
    if (spCell==nil) {
        spCell =[SPDetailCell cellWithTableView:tableView];
    }
    spCell.comModel =[_dataSourceArray objectAtIndex:indexPath.row];
    
    return spCell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PDetailViewController *pDetail = [[PDetailViewController alloc] init];
    //提前初始化basemessage(为了设置代理为SPDetailVC)
    BaseMessageVC  *baseMess=[[BaseMessageVC alloc] init];

    pDetail.baseMessage = baseMess;
    
    searchResultModel *model;
   
    model =[_dataSourceArray objectAtIndex:indexPath.row];
    
    [pDetail setCompreModel:model];
   
    [self.navigationController pushViewController:pDetail animated:YES];
    
}

#pragma  mark - DY_searchBarDelegate
//隐藏搜索结果页，显示历史记录页（在点击输入框内的清除按钮或者用键盘把文字一个个删除后）
- (void)hideSearchResultTabelView
{
    //隐藏搜索结果列表,显示历史列表
    self.searchResultTabelView.hidden = NO;
    [self searchAction];
    
    [self showWithoutDataAndHiden:YES];

}

//点击键盘上的搜索进行搜索操作
- (void)searchDataWithInputString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return;
    }
    //开始搜索,显示搜索结果列表
    self.searchResultTabelView.hidden = NO;

    self.searchBar.searchTextField.text = string;
    
    [self searchAction];
    
    self.historyTabelView.searchResultCount = _dataSourceArray.count;
    //添加一条历史记录
    [self.historyTabelView addHistoryWithString:string];
    [self changeResultTableViewFrame];
}
// 位置改变
-(void)changeResultTableViewFrame
{
//    if (self.historyTabelView.frame<= (MainR.size.height-64-self.searchBar.frame.size.height)/2)
//    {
//        self.historyTabelView.frame=CGRectMake(0, self.searchBar.frame.size.height, MainR.size.width, (self.historyTabelView.historyArray.count)*40+30+44);
//    }
//    else
//    {
        self.historyTabelView.frame=CGRectMake(0, self.searchBar.frame.size.height, MainR.size.width, (MainR.size.height-64-self.searchBar.frame.size.height)/2);
//    }
    
    [self.historyTabelView reloadData];

    if (self.searchBar.frame.size.height+self.historyTabelView.historyArray.count*40+30+44 <= (MainR.size.height-64-self.searchBar.frame.size.height)/2)
    {
        self.searchResultTabelView.frame = CGRectMake(0,self.searchBar.frame.size.height+self.historyTabelView.historyArray.count*40+30+44, MainR.size.width,MainR.size.height-self.searchBar.frame.size.height-64-(self.historyTabelView.historyArray.count*40+30+44));
         _loadBtn.frame =CGRectMake((MainR.size.width-150)*0.5, self.searchBar.frame.size.height+self.historyTabelView.historyArray.count*40+30+44+20, 150, 200);
    }
    else
    {
        self.searchResultTabelView.frame = CGRectMake(0,(MainR.size.height-64-self.searchBar.frame.size.height)/2+self.searchBar.frame.size.height, MainR.size.width,MainR.size.height-(MainR.size.height-64-self.searchBar.frame.size.height)/2-64-self.searchBar.frame.size.height);
         _loadBtn.frame =CGRectMake((MainR.size.width-150)*0.5, (MainR.size.height-64-self.searchBar.frame.size.height)/2+self.searchBar.frame.size.height+20, 150, 200);
    }
    
    [self.searchResultTabelView reloadData];

   
    _tipLable.frame= CGRectMake((MainR.size.width-150-30)*0.5,CGRectGetMaxY(_loadBtn.frame)-44, _loadBtn.frame.size.width+30,44);
}


//#pragma mark - UITextFieldDelegate
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    if ([self.textField.text isEqualToString:@""]) {
//        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容再搜索" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//        [alertV show];
//    }
//    else
//    {
//        [self searchAction];
////        [self.hisData addObject:self.textField.text];
////        [defaults setObject:self.hisData forKey:@"searchHis"];
////        [defaults  synchronize];
////        self.tableView.hidden =NO;
//    
//    
//    }
//    
//    
//    return YES;
//}
//
//

//触摸空白处
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar.searchTextField resignFirstResponder];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
