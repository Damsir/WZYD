//
//  ContactViewController.m
//  XAYD
//
//  Created by songdan Ye on 16/1/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ContactViewController.h"
//#import "SHMembersModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "ContactHeaderView.h"
#import "SHMemberListViewCell.h"
//#import "SHMembers.h"
#import "MBProgressHUD+MJ.h"
#import "ContactsListTableViewCell.h"
#import "Global.h"
#import "ContactModel.h"
#import "MembersModel.h"


@interface ContactViewController ()<UITableViewDataSource,UITableViewDelegate,ContactHeaderViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UIView *sectionView;

@property (nonatomic,assign)NSInteger mode;

@property (nonatomic,strong)NSArray *allContacts;

@property (nonatomic,strong)UILabel *sectionCL;
@property(nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;

@end

@implementation ContactViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden= YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.view.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    
    self.view.backgroundColor =[UIColor whiteColor];
    [self createUserSearchBar];
    [self createSectionView];
    [self createTableView];
    [self loadContactData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContact) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转结束执行的方法
- (void)changeContact
{
    self.textField.frame = CGRectMake(10, 10, MainR.size.width-20, 40);
    CGFloat tabVY;
//    if(_mode == 0)//正常状态
//    {
        tabVY= CGRectGetMaxY(_textField.frame);
//    }
//    else{
//        
//        tabVY = 0;
//    }
  
    self.tableV.frame=CGRectMake(0,tabVY ,MainR.size.width ,MainR.size.height-tabVY-64);
    [self.tableV reloadData];
}
//获取所有人员

-(void)loadContactData
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    
//    http://192.168.2.239/HAYDService/ServiceProvider.ashx?type=smartplan&action=getContact
    
    NSDictionary *parameters;
    parameters = @{@"type":@"smartplan",@"action":@"getContact"};
    
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];

    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"Contact%@",requestAddress);
    //    if(!_isDropRefersh)//下拉刷新
    //    [MBProgressHUD showMessage:@"正在加载SP!"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/SendList.ashx"];
    
   [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
   [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
       [MBProgressHUD hideHUDForView:self.view animated:YES];
       NSDictionary *rs = (NSDictionary *)responseObject;
      
       NSArray *td= [rs objectForKey:@"result"];
       
       //分组标记
       _markArray = [[NSMutableArray alloc] init];
       _groupImgArray = [[NSMutableArray alloc] init];
       if (td.count)
       {
           for (int i=0; i<td.count; i++)
           {
               NSString *mark = @"0";
               [_markArray addObject:mark];
               [_groupImgArray addObject:@"zhankai"];
           }
       }
       
       NSMutableArray *array =[NSMutableArray array];
       for (NSDictionary *dict in td)
       {
           ContactModel *model =[[ContactModel alloc] initWithDict:dict];
           
           [array addObject:model];
       }
       _contacts = array;
       self.searchContacts = self.contacts;
       //获取所有人员
       //[self calculate];
       [self.tableV reloadData];
       //[_sectionCL setText:[NSString stringWithFormat:@"部门  (%ld)",(unsigned long)self.contacts.count]];
    
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD hideHUDForView:self.tableV animated:YES];
 
   }];




}

- (void)calculate
{
    if (_allContacts ==nil) {
        _allContacts = [NSArray array];
        
    }
    NSMutableArray *mulArr =[NSMutableArray array];
    for ( ContactModel *model in _contacts) {
        for (MembersModel *m in model.userList) {
            [mulArr addObject:m];
        }
    }
    _allContacts = [mulArr copy];
}


- (void) createTableView
{
    CGFloat tabVY;
//    if(_mode == 0)//正常状态
//    {
        tabVY= CGRectGetMaxY(_textField.frame);
//    }
//    else{
//        
//        tabVY = 0;
//    }
    UITableView *tableV=[[UITableView alloc] initWithFrame:CGRectMake(0,tabVY ,MainR.size.width ,MainR.size.height-tabVY-64) style:UITableViewStylePlain];
    tableV.backgroundColor = [UIColor whiteColor];
    tableV.dataSource = self;
    tableV.delegate = self;
    tableV.separatorStyle =UITableViewCellSeparatorStyleNone;
    _tableV= tableV;

    [self.view addSubview:_tableV];
    
}

- (void)createSectionView
{
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textField.frame), MainR.size.width, 44)];
    _sectionView = sectionView;
    //[self.view addSubview:_sectionView];
    self.view.backgroundColor = RGB(250, 250, 250);
    UILabel *sectionCL =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
    sectionCL.textColor =[UIColor darkGrayColor];
    //[_sectionView addSubview:sectionCL];
    _sectionCL =sectionCL;
    
}

- (void)createUserSearchBar
{
    //搜索框
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, MainR.size.width-20, 40)];
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.placeholder = @"输入搜索关键字";
    self.textField.text = @"";
    self.textField.backgroundColor = RGB(242, 242, 242);
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.textField];
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    searchIcon.image = [UIImage imageNamed:@"searchm"];
    self.textField.leftView = searchIcon;
    [self.textField leftViewRectForBounds:CGRectMake(0, 0, 38, 38)];
    
    self.textField.leftViewMode =UITextFieldViewModeAlways;
    
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_mode ==0)
    {   //正常状态
//        NSString *mark = [_markArray objectAtIndex:section];
//        
//        if ([mark isEqualToString:@"1"])
//        {
//            ContactModel *model= [_contacts objectAtIndex:section];
//            NSInteger count = model.userList.count;
//            return count;
//        }
//        else
//        {
//            return 0;
//        }
        return  _contacts.count;
    }
    else
    {
        NSInteger count=  _searchContacts.count;
        return count;
        
    }
    
}

#pragma mark -tabelViewDelge代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, MainR.size.width, 50);
    headView.tag = section;
    headView.backgroundColor = [UIColor whiteColor];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainR.size.width-50, 50)];
    //lab.text = [NSString stringWithFormat:@"%@  (%ld)", [_contacts[section] organName],(unsigned long)[[_contacts[section] userList] count]];
    lab.text = [NSString stringWithFormat:@"%@", [_contacts[section] organName]];
    [headView addSubview:lab];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(15, headView.frame.size.height-1, MainR.size.width-15, 1)];
    line.backgroundColor = GRAYCOLOR;
    [headView addSubview:line];
    
    UIButton *groupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    groupBtn.frame = CGRectMake(MainR.size.width-35, 35/2.0, 15, 15);
    [groupBtn setImage:[UIImage imageNamed:_groupImgArray[section]] forState:UIControlStateNormal];
    groupBtn.enabled = NO;
    [headView addSubview:groupBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseHeader:)];
    [headView addGestureRecognizer:tap];
    
    return nil;
}
//打开关闭分组
-(void)openOrCloseHeader:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    NSString *mark = _markArray[tapView.tag];
    
    if ([mark isEqualToString:@"0"])
    {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"1"];
        [UIView animateWithDuration:0.5 animations:^{
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"xiangshang"];
            
        }];
    }
    else
    {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"0"];
        [UIView animateWithDuration:0.5 animations:^{
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"zhankai"];
            
        }];
        
    }
    [_tableV reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (_mode ==0)
//    {
//        if (self.contacts.count>0)
//        {
//            NSInteger count =self.contacts.count;
//            return  count;
//        }
//        else
//        {
//            return 0;
//        }
//    }
//    else
//    {
        return 1;
//    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建自定制cell
//    SHMembersModel *model = nil;
//    SHMembers *mem = nil;
    ContactModel *model= nil;
    MembersModel *mem = nil;
    ContactsListTableViewCell *cell = [ContactsListTableViewCell cellWithTableView:tableView];
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(cell.name.frame.origin.x, cell.frame.size.height-1, MainR.size.width, 1)];
    line.backgroundColor = GRAYCOLOR;
    [cell.contentView addSubview:line];
    //2.给cell设置要显示的数据

    if (_mode==0)
    {
//        model = _contacts[indexPath.section] ;
//        NSArray *tmp = model.userList;
//        mem = tmp[indexPath.row];
        model = _contacts[indexPath.row] ;

    }
    else
    {
        model = [_searchContacts objectAtIndex:indexPath.row];
    }
    
    [cell setMModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SHMemberListViewCell *cell = (SHMemberListViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    ContactModel *memsModel = _contacts[indexPath.section];
    NSArray *tmp = memsModel.userList;
    MembersModel *mem = tmp[indexPath.row];
    NSString *telMobile=[NSString stringWithFormat:@"tel://%@",mem.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telMobile]];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (self.mode == 0)
//    {
//        return 50;
//    }
    return 0.0;
}

- (void)clickHeaderView
{
    [self.tableV reloadData];
    
}


- (void)dosearch:(UITextField *)textfield
{
    _mode =1;
    
    NSMutableArray *mulA=[NSMutableArray array];
    for (ContactModel *m in _contacts)
    {
        NSRange range = [m.Name
                         rangeOfString:textfield.text];
        if(range.location != NSNotFound)
        {
            [mulA addObject:m];
        }
        NSRange range1 =[m.bmName rangeOfString:textfield.text];
        if (range1.location != NSNotFound) {
            [mulA addObject:m];
        }
    }
    self.searchContacts = [mulA copy];
    [self.tableV reloadData];
    
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dosearch:textField];
    
    [textField resignFirstResponder];
    
    return YES;
}

//监听文本框右侧清除按钮响应的方法

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _mode = 0;
    [self.tableV reloadData];
    
    return YES;
}

//监听输入框文本的变化
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length == 1 && [string isEqualToString:@""]) {
        _mode = 0;
        [self.tableV reloadData];
    }
    return YES;
    
}

//开始拽tableview的时候隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
