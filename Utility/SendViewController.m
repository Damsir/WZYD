//
//  SendViewController.m
//  iBusiness
//
//  Created by zhangliang on 15/5/5.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "SendViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DejalActivityView.h"
#import "Global.h"
#import "SPDetailVC.h"
#import "MBProgressHUD+MJ.h"
#import "SPDetailModel.h"


@interface SendViewController (){
    NSDictionary *_project;
    SPDetailModel *_projectModel;
    NSArray *_activities;
    int _sendType;
    int _status;
    NSString *_sendTypeKey;
    UIView *_sendBackView;
    UITextField *_sendBackText;
    UIButton *_sendBackButton;
    NSString *_signXml;
    NSIndexPath *_selectedIndexPath;
    NSTimer *_searchTimer;
    NSMutableArray *_searchResult;
    NSMutableArray *_selectedItems;
}
@end

@implementation SendViewController
@synthesize delegate  = _delegate;

- (void)fildName:(NSString *)fildName
{
    
    _fildName = fildName;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (_sendType == 0) {
        self.title=@"发送给(单选)";
        _sendTypeKey = @"send";
    }else if(_sendType == 1){
        self.title=@"回退至(单选)";
        _sendTypeKey = @"sendback";
    }else if(_sendType == 2){
        self.title=@"发送给(可多选)";
        _sendTypeKey = @"send";
        self.activityTable.allowsMultipleSelection = YES;
    }else if(_sendType == 3){
        self.title=@"回退给(可多选)";
        _sendTypeKey = @"sendback";
        self.activityTable.allowsMultipleSelection = YES;
    }else if(_sendType == 4){
        self.title=@"传阅给(可多选)";
        _sendTypeKey = @"toread";
        self.activityTable.allowsMultipleSelection = YES;
    }
    else if(_sendType == 5)
    {
        self.title=@"签阅给(可多选)";
        _sendTypeKey = @"toread";
        self.activityTable.allowsMultipleSelection = YES;
        
    }
    self.btnComplete.layer.cornerRadius = 5;
    
    self.sendView.layer.shadowOffset = CGSizeMake(0, -.5);
    self.sendView.layer.shadowOpacity = 0.30;
    
    self.activityTable.touchDelegate = self;
    [self loadActivity];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (nil!=_searchTimer) {
        [_searchTimer invalidate];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSendBackPanel{
    _sendBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    _sendBackView.backgroundColor = [UIColor whiteColor];
    _sendBackView.layer.shadowOffset = CGSizeMake(0, -.5);
    _sendBackView.layer.shadowOpacity = 0.30;
    //UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    //line.backgroundColor = [UIColor grayColor];
    //[_sendBackView addSubview:line];
    _sendBackText = [[UITextField alloc] initWithFrame:CGRectMake(10, 13, self.view.frame.size.width-110, 35)];
    _sendBackText.borderStyle = UITextBorderStyleRoundedRect;
    //_signView.tintColor = [UIColor whiteColor];
    _sendBackText.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1];
    //_sendBackText.delegate = self;
    _sendBackText.placeholder = _sendType==1? @"请输入回退意见":@"请输入传阅意见";
    _sendBackText.enabled = NO;
    
    [_sendBackView addSubview:_sendBackText];
    
    _sendBackButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBackButton.frame  = CGRectMake(self.view.frame.size.width-80, 13, 70, 35);
    [_sendBackButton setTitle:@"完成" forState:UIControlStateNormal];
    _sendBackButton.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
    _sendBackButton.layer.cornerRadius = 5;
    _sendBackButton.enabled = NO;
    
    [_sendBackButton addTarget:self action:@selector(sendback) forControlEvents:UIControlEventTouchUpInside];
    
    [_sendBackView addSubview:_sendBackButton];
    [self.view addSubview:_sendBackView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (nil!=_sendBackText) {
        [_sendBackText resignFirstResponder];
    }
    [self.searchBar resignFirstResponder];
}

-(void)signXml:(NSString *)xml{
    _signXml = xml;
}

-(void)projectInfo:(NSDictionary *)data{
    _project = data;
}

-(void)projectInfoModel:(SPDetailModel *)model
{
    _projectModel = model;
}
//发送类型
-(void)sendType:(int)type{
    _sendType = type;
}

- (void)sendStutas:(int)status
{
    _status = status;
}

-(void)loadActivity
{
    _selectedItems = [NSMutableArray arrayWithCapacity:10];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,@"service/form/SendList.ashx"];

    
    NSDictionary *parameters;
    // _sendType == 4,续传
    if(_sendType == 4||_sendType == 5)
    {
        parameters = @{@"type":@"smartplan",@"action":@"allusers"};
        
    }else
    {
        if (_projectModel.ProjectId)
        {
            parameters = @{@"project":_projectModel.ProjectId,@"user":[Global userId],@"type":_sendTypeKey,@"deviceNumber":DeviceId,@"username":[Global userName]};
        }
        else if (_projectModel.Id)
        {
            parameters = @{@"project":_projectModel.Id,@"user":[Global userId],@"type":_sendTypeKey,@"deviceNumber":DeviceId,@"username":[Global userName]};
        }

    }
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"发送列表%@",requestAddress);
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"加载数据"];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *rs = (NSDictionary *)responseObject;
        //NSLog(@"success%@",[rs objectForKey:@"success"]);
        if ([[rs objectForKey:@"success"] isEqual:@1])
        {
            // 人员列表数组
            _activities = [rs objectForKey:@"result"];
            [DejalBezelActivityView removeViewAnimated:YES];
            [self showActivities];
        }else{
            [self showError];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showError];
    }];
}

-(void)showError{
    [DejalBezelActivityView removeViewAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"流程加载失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [_sendBackText becomeFirstResponder];
    }
}

- (IBAction)onBtnCompleteTap:(id)sender
{
    [self uploadOne];
}

// 发送 || 回退 || 续传
- (void)uploadOne
{
    // 创建一个参数字典
    NSDictionary *params = [NSDictionary dictionary];
    if(_signXml == nil)
    {  // 意见
        _signXml = @"";
    }
    NSString *activityId = @"";
    NSString *toUid = @"";
    if (_sendType==2||_sendType==3||_sendType == 4||_sendType ==5)
    {
        toUid = [_selectedItems componentsJoinedByString:@","];
    }
    else
    {
        NSDictionary *activity = [_activities objectAtIndex:_selectedIndexPath.section];
        activityId =[activity objectForKey:@"activityID"];
        
        toUid= [[[activity objectForKey:@"users"] objectAtIndex:_selectedIndexPath.row] objectForKey:@"userId"];
    }

    if(_sendType == 4||_sendType == 5)
    {
        //    fromUserid:发起人id
        //    toUserIdArray:接收人id，用逗号隔开
        //    strategy:签阅结束策略，传阅时不填该值：all表示全部阅毕，appointed表示指定人员签阅完，firstall表示一级人员签阅完，manual手动结束
        //    needSign:是否需要签字，传阅时不填该值
        //    endDate:签字日期，传阅时不填该值
        //    remark:备注信息
        //2.168.2.239/WSYDService/ServiceProvider.ashx?type=smartplan&action=createforward&resourceId=122&resourceType=1&forwardType=1&fromUserid&toUserIdArray=&stategy=&needSign=false&endDate=&remark=
        //        ,@"smsMsg":@"ture",@"stategy":@""
        
        NSString *forwordType =@"";
        if (_sendType == 2)
        {
            //传阅--
            forwordType = @"0";
            params = @{@"fromUserid":[Global myuserId],@"type":@"smartplan",@"action":@"createforward",@"resourceId":[_project objectForKey:@"projectId"],@"sendtype":_sendTypeKey,@"resourceType":@"1",@"forwardType":forwordType,@"toUserIdArray":toUid,@"sysMsg":@"ture",@"remark":_signXml,@"needSign":@"false",@"strategy":@"",@"endDate":@""};
        }else
        {//签阅--
            forwordType = @"1";
            params = @{@"fromUserid":[Global myuserId],@"type":@"smartplan",@"action":@"createforward",@"resourceId":[_project objectForKey:@"projectId"],@"sendtype":_sendTypeKey,@"resourceType":@"1",@"data":_signXml,@"forwardType":forwordType,@"toUserIdArray":toUid,@"opt":_signXml,@"remark":_signXml,@"strategy":@"all",@"endDate":@"",@"needSign":@"false"};
        }
        
        
    }
    // 发送 回退
    else
    {
        if (_projectModel.ProjectId)
        {
            params = @{@"project":_projectModel.ProjectId,@"fromUser":[Global userId],@"toUser":toUid,@"businessMode":@"2",@"activityID":activityId,@"opt":_signXml,@"type":_sendTypeKey,@"deviceNumber":DeviceId,@"username":[Global userName]};
        }
        else if (_projectModel.Id)
        {
            params = @{@"project":_projectModel.Id,@"fromUser":[Global userId],@"toUser":toUid,@"businessMode":@"2",@"activityID":activityId,@"opt":_signXml,@"type":_sendTypeKey,@"deviceNumber":DeviceId,@"username":[Global userName]};
        }
    }
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if ( nil!=params )
    {
        for (NSString *key in params.keyEnumerator) {
            NSString *val = [params objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    NSLog(@"发送意见等%@",requestAddress);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",Url,@"service/form/Send.ashx"];

    //加载提示框
    [MyProgressView showJiaZaiWithBool:YES WithTitle:@"正在发送" WithAnimation:NO WithSuperViewStyle:1];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *rs= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers |NSJSONReadingMutableLeaves error:nil];
        if (_sendType == 4||_sendType == 5)
        {
            if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
                [DejalBezelActivityView removeViewAnimated:YES];
                if(_sendType ==4)
                {
                    [MBProgressHUD showSuccess:@"传阅成功" toView:[self.navigationController.viewControllers objectAtIndex:0].view];
                }else if(_sendType ==5)
                {
                    [MBProgressHUD showSuccess:@"签阅成功" toView:[self.navigationController.viewControllers objectAtIndex:0].view];
                }
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];            }
            else{
                [self showSendError];
            }
        }
        else
        {
            //加载提示框
            [MyProgressView showJiaZaiWithBool:NO WithTitle:@"" WithAnimation:NO WithSuperViewStyle:1];
            NSLog(@"发送&回退::%@",[rs objectForKey:@"result"]);
            if ([[rs objectForKey:@"result"] isEqual:@1])
            {
                [DejalBezelActivityView removeViewAnimated:YES];
                [self sendCompleted];
            }else{
                [self showSendError];
            }
        }
        
    }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {

        //加载提示框
        [MyProgressView showJiaZaiWithBool:NO WithTitle:@"" WithAnimation:NO WithSuperViewStyle:1];
        [self showSendError];
    }];
    
}

-(void)sendback{
    NSString *suggest = _sendBackText.text;
    if([suggest isEqualToString:@""]){
        UIAlertView *msg =[[UIAlertView alloc] initWithTitle:@"提示" message:_sendType==1? @"请输入回退意见":@"请输入传阅意见" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        msg.tag = 1;
        [msg show];
    }else{
        [_sendBackText resignFirstResponder];
        [self onBtnCompleteTap:nil];
    }
}

-(void)sendCompleted{
    //     [[NSNotificationCenter defaultCenter] postNotificationName:@"sendCompleted" object:nil];
    if ([_delegate conformsToProtocol:@protocol(SendViewDelegate)] &&
        [_delegate respondsToSelector:@selector(sendViewDidSendCompleted)])
        //        if ([self.delegate respondsToSelector:@selector(sendViewDidSendCompleted)])
        
    {
        [self.delegate sendViewDidSendCompleted];
        
    }
    //   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)showSendError{
    [DejalBezelActivityView removeViewAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil] show];
    
    //    [self sendCompleted];
}

//刷新tableView
-(void)showActivities{
    self.activityTable.delegate = self;
    self.activityTable.dataSource = self;
    [self.activityTable reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    if (nil!=_searchResult)
    {
        return _searchResult.count;
    }
    return _activities.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *users=nil;
    if (nil!=_searchResult)
    {
        users = [[_searchResult objectAtIndex:section] objectForKey:@"users"];
    }else
    {
        users = [[_activities objectAtIndex:section] objectForKey:@"users"];
    }
    return users.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indentifierCell=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifierCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifierCell];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:189.0/255.0 blue:21.0/255.0 alpha:1];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    
    NSArray *us = nil;
    if (nil!=_searchResult) {
        us = [[_searchResult objectAtIndex:indexPath.section] objectForKey:@"users"];
    }else{
        us = [[_activities objectAtIndex:indexPath.section] objectForKey:@"users"];
    }
    NSDictionary *userInfo = [us objectAtIndex:indexPath.row];
    cell.textLabel.text = [userInfo objectForKey:@"userName"];
    int si = [self selectedIndex:[userInfo objectForKey:@"userId"]];
    cell.selected = si!=-1;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *activity = [_activities objectAtIndex:section];
    return [activity objectForKey:@"activityName"] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sendType==2||_sendType==3) {
        NSArray *users = nil;
        if(nil!=_searchResult)
        users = [[_searchResult objectAtIndex:indexPath.section] objectForKey:@"users"];
        else
        users = [[_activities objectAtIndex:indexPath.section] objectForKey:@"users"];
        NSString *uid=[[users objectAtIndex:indexPath.row] objectForKey:@"userId"];
        int si = [self selectedIndex:uid];
        [_selectedItems removeObjectAtIndex:si];
        if (_selectedItems.count==0) {
            //////
            self.btnComplete.enabled = NO;
            self.btnComplete.backgroundColor = [UIColor lightGrayColor];
            
            _sendBackButton.enabled = NO;
            _sendBackButton.backgroundColor = [UIColor lightGrayColor];
            _sendBackText.enabled = NO;
            _sendBackText.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_sendType==0||_sendType==1){
        self.btnComplete.enabled = YES;
        self.btnComplete.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
    }else if(_sendType==2||_sendType==3){
        NSArray *users = nil;
        if(nil!=_searchResult)
        users = [[_searchResult objectAtIndex:indexPath.section] objectForKey:@"users"];
        else
        users = [[_activities objectAtIndex:indexPath.section] objectForKey:@"users"];
        NSString *uid=[[users objectAtIndex:indexPath.row] objectForKey:@"userId"];
        [_selectedItems addObject:uid];
        //////
        
        self.btnComplete.enabled = YES;
        self.btnComplete.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
        
    }
    _selectedIndexPath = indexPath;
}

-(void)keyboardWasHide:(NSNotification *)notif
{
    _sendBackView.frame = CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60);
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _sendBackView.frame = CGRectMake(0, self.view.frame.size.height-keyboardSize.height-60, self.view.frame.size.width, 60);
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(nil!=_searchTimer)
        [_searchTimer invalidate];
    NSString *key = self.searchBar.text;
    if ([key isEqualToString:@""]) {
        [self clearSearch];
    }else {
        _searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(doSearch) userInfo:nil repeats:NO];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self clearSearch];
}

-(void)clearSearch{
    if(nil!=_searchTimer)
        [_searchTimer invalidate];
    _searchResult = nil;
    [self.activityTable reloadData];
}

-(void)doSearch
{
    if (nil==_activities) {
        return;
    }
    NSString *key = self.searchBar.text;
    _searchResult = [[NSMutableArray alloc] initWithCapacity:_activities.count];
    for (int i=0; i<_activities.count; i++) {
        NSDictionary *targetGroup = [_activities objectAtIndex:i];
        NSArray *targetUsers = [targetGroup objectForKey:@"users"];
        NSMutableArray *sItems = [[NSMutableArray alloc] initWithCapacity:10];
        for (int j=0; j<targetUsers.count; j++) {
            NSString *n1 = [[targetUsers objectAtIndex:j] objectForKey:@"userName"];
            if ([n1 rangeOfString:key].length>0) {
                [sItems addObject:[targetUsers objectAtIndex:j]];
            }
        }
        if (sItems.count>0) {
            [_searchResult addObject:@{@"activityName":[targetGroup objectForKey:@"activityName" ],@"activityID":[targetGroup objectForKey:@"activityID"],@"users":sItems}];
        }
    }
    [self.activityTable reloadData];
}

-(int)selectedIndex:(NSString *)uid{
    for (int i=0; i<_selectedItems.count; i++) {
        NSString *saveId = [_selectedItems objectAtIndex:i];
        if ([saveId isEqualToString:uid]) {
            return i;
        }
    }
    return -1;
}


@end
