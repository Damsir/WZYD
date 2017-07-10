//
//  SendViewController.m
//  iBusiness
//
//  Created by zhangliang on 15/5/5.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "SendViewController.h"
#import "AFNetworking.h"
#import "DejalActivityView.h"
#import "Global.h"
#import "SPDetailVC.h"
#import "MBProgressHUD+MJ.h"
#import "SPDetailModel.h"
#import "MKTreeView.h"

static NSString *keyPath_CicrleAnimation = @"clickCicrleAnimation";
static NSString *keyPath_CicrleAnimationGroup = @"clickCicrleAnimationGroup";


@interface SendViewController ()<UIAlertViewDelegate,TreeDelegate>
{
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
    NSString *_projectType;
    NSIndexPath *_selectedIndexPath;
   // NSTimer *_searchTimer;
    NSMutableArray *_searchResult;
    NSMutableArray *_selectedItems;//toUserIDs
    NSMutableArray *_selectedactivityIDs;//activityIDs
    MKTreeView *_treeView;
    NSArray *_selectArray;
}

@end

@implementation SendViewController

@synthesize delegate  = _delegate;


- (void)fildName:(NSString *)fildName
{
    _fildName = fildName;
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
// 发送类型(公文,审批,发送,回退)
-(void)sendType:(int)type{
    _sendType = type;
}
// 项目类型( 项目: 1 公文: 2 )
-(void)projectType:(NSString *)projectType{
    _projectType = projectType;
}

- (void)sendStutas:(int)status
{
    _status = status;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    //    if (nil != _searchTimer) {
    //        [_searchTimer invalidate];
    //    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_sendType == 0) {
        //self.navigationItem.title=@"发送给 (单选)";
        [self initNavigationBarTitle:@"发送给 (单选)"];
        _sendTypeKey = @"send";
    }else if(_sendType == 1){
        //self.navigationItem.title=@"回退至 (单选)";
        [self initNavigationBarTitle:@"回退至 (单选)"];
        _sendTypeKey = @"sendback";
    }else if(_sendType == 2){
        //self.navigationItem.title=@"发送给 (可多选)";
        [self initNavigationBarTitle:@"发送给 (可多选)"];
        _sendTypeKey = @"send";
    }else if(_sendType == 3){
        //self.navigationItem.title=@"回退给 (可多选)";
        [self initNavigationBarTitle:@"回退给 (单选)"];
        _sendTypeKey = @"sendback";
    }else if(_sendType == 4){
        //self.navigationItem.title=@"传阅给 (可多选)";
        [self initNavigationBarTitle:@"传阅给 (可多选)"];
        _sendTypeKey = @"toread";
    }
    else if(_sendType == 5)
    {
        //self.navigationItem.title=@"签阅给 (可多选)";
        [self initNavigationBarTitle:@"签阅给 (可多选)"];
        _sendTypeKey = @"toread";
    }
    self.btnComplete.layer.cornerRadius = 5;
    self.sendView.layer.shadowOffset = CGSizeMake(0, -.5);
    self.sendView.layer.shadowOpacity = 0.30;
    
    // 加载环节人员列表
    [self loadActivityPersonList];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

#pragma mark -- 屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _treeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-60);
    [_treeView screenRotation];
}

#pragma mark -- 加载环节人员列表

-(void)loadActivityPersonList
{
    _selectedItems = [NSMutableArray array];
    _selectedactivityIDs = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/SendList.ashx"];

    NSDictionary *parameters;

    if(_sendType == 4||_sendType == 5)
    {
        parameters = @{@"type":@"smartplan",@"action":@"allusers"};
        
    }
    else
    {
        if (_projectModel.ProjectId)
        {
            parameters = @{@"project":_projectModel.ProjectId,@"user":[Global userId],@"type":_sendTypeKey,@"projectType":_projectType,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        }
        else if (_projectModel.Id)
        {
            parameters = @{@"project":_projectModel.Id,@"user":[Global userId],@"type":_sendTypeKey,@"projectType":_projectType,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
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
    
    NSLog(@"发送回退列表%@",requestAddress);
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"加载数据"];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [DejalBezelActivityView removeViewAnimated:YES];
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        NSArray *result = [rs objectForKey:@"result"];
        if (result.count)
        {
            // 人员列表数组
            _activities = [rs objectForKey:@"result"];
            MKTreeView *treeView = [[MKTreeView instanceView] initTreeWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-60) dataArray:_activities haveHiddenSelectBtn:NO haveHeadView:NO isEqualX:NO];
            _treeView = treeView;
            treeView.delegate = self;
            [self.view addSubview:treeView];
            
            //[self showActivities];
        }else{
            [self showError];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [self showError];
    }];
}

#pragma mark -- TreeDelegate

-(void)itemSelectArray:(NSArray *)selectArray
{
    _selectArray = selectArray;
    if (selectArray.count) {
        
        self.btnComplete.enabled = YES;
        //self.btnComplete.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
        self.btnComplete.backgroundColor = BLUECOLOR;
        
    }else
    {
        self.btnComplete.enabled = NO;
        self.btnComplete.backgroundColor = [UIColor lightGrayColor];
    }
    
    //[UIColor colorWithRed:37.0/255.0 green:189.0/255.0 blue:21.0/255.0 alpha:1];
}

-(void)itemSelectInfo:(MKPeopleCellModel *)item
{
    NSLog(@"item::%@",item.activityName);
}

#pragma mark -- 流程加载错误
-(void)showError{
    [DejalBezelActivityView removeViewAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"人员列表加载失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [_sendBackText becomeFirstResponder];
    }
}


//画圆
-(UIBezierPath *)drawclickCircleBezierPath:(CGFloat)radius{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    /**
     *  center: 弧线中心点的坐标
     radius: 弧线所在圆的半径
     startAngle: 弧线开始的角度值
     endAngle: 弧线结束的角度值
     clockwise: 是否顺时针画弧线
     *
     */
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return bezierPath;
}

#pragma mark -- 发送回退
- (IBAction)onBtnCompleteTap:(id)sender
{
    //点击出现白色圆形
    CAShapeLayer *clickCicrleLayer = [CAShapeLayer layer];
    _clickCicrleLayer = clickCicrleLayer;

    clickCicrleLayer.frame = CGRectMake(_btnComplete.bounds.size.width/2, _btnComplete.bounds.size.height/2, 5, 5);
    clickCicrleLayer.fillColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.path = [self drawclickCircleBezierPath:5].CGPath;
    [_btnComplete.layer addSublayer:clickCicrleLayer];
    
    //放大变色圆形
    CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation2.duration = 0.5;
    basicAnimation2.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(_btnComplete.bounds.size.height - 10*2)/2].CGPath);
    basicAnimation2.removedOnCompletion = NO;
    basicAnimation2.fillMode = kCAFillModeForwards;
    
    [clickCicrleLayer addAnimation:basicAnimation2 forKey:keyPath_CicrleAnimation];
    
    //圆形变圆弧
    clickCicrleLayer.fillColor = [UIColor clearColor].CGColor;
    clickCicrleLayer.strokeColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.lineWidth = 10;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    //圆弧变大
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.5;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(_btnComplete.bounds.size.height - 10*2)].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    //变透明
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.5;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    animationGroup.duration = basicAnimation1.beginTime + basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    
    [clickCicrleLayer addAnimation:animationGroup forKey:keyPath_CicrleAnimationGroup];
    
    [self uploadSendOrRollBack];
}

// 发送 || 回退 || 续传
- (void)uploadSendOrRollBack
{
    // 如果是审批,不能多选 ,回退不能多选
    if ((_sendType == 0 || _sendType == 1||_sendType == 3) && _selectArray.count > 1) {
        
        NSString *message = @"";
        if (_sendType == 0 || _sendType == 1) {
            message = @"项目审批只能发送(回退)给单人";
        }
        else if (_sendType == 3)
        {
            message = @"公文只能回退给单人";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    // 创建一个参数字典
    NSDictionary *params = [NSDictionary dictionary];
    if(_signXml == nil)
    {  // 意见
        _signXml = @"";
    }
    NSString *activityId = @"";
    NSString *toUid = @"";
    if (_sendType==2||_sendType == 4||_sendType ==5)
    {
//        toUid = [_selectedItems componentsJoinedByString:@","];
//        activityId = [_selectedactivityIDs componentsJoinedByString:@","];
        NSMutableArray *uidArray = [NSMutableArray array];
        NSMutableArray *activityArray = [NSMutableArray array];
        for (NSDictionary *person in _selectArray) {
            
            [uidArray addObject:[person objectForKey:@"userId"]];
            [activityArray addObject:[person objectForKey:@"activityID"]];
        }
        
        toUid = [uidArray componentsJoinedByString:@","];
        activityId = [activityArray componentsJoinedByString:@","];
        // 结束环节 (没有userId)
        if (toUid == nil) {
            toUid = @"";
        }
        
    }
    else
    {
        activityId =[[_selectArray firstObject] objectForKey:@"activityID"];
        toUid= [[_selectArray firstObject] objectForKey:@"userId"];
        // 结束环节 (没有userId)
        if (toUid == nil) {
            toUid = @"";
        }

    }

    if(_sendType == 4||_sendType == 5)
    {
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
        // 审批 (发送,回退单人) 公文(回退单人)
        if(_sendType == 0||_sendType == 1||_sendType == 3)
        {
            if (_projectModel.ProjectId)
            {
                params = @{@"project":_projectModel.ProjectId,@"fromUser":[Global userId],@"toUser":toUid,@"businessMode":@"2",@"activityID":activityId,@"opt":_signXml,@"type":_sendTypeKey,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
            }
            else if (_projectModel.Id)
            {
                params = @{@"project":_projectModel.Id,@"fromUser":[Global userId],@"toUser":toUid,@"businessMode":@"2",@"activityID":activityId,@"opt":_signXml,@"type":_sendTypeKey,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
            }
        }
        // 公文 (发送多人)
        else if(_sendType == 2)
        {
            _sendTypeKey = @"sendmore";
            if (_projectModel.ProjectId)
            {
                params = @{@"project":_projectModel.ProjectId,@"type":_sendTypeKey,@"fromUser":[Global userId],@"activityIDs":activityId,@"toUserIDs":toUid,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
            }
            else if (_projectModel.Id)
            {
                params = @{@"project":_projectModel.Id,@"type":_sendTypeKey,@"fromUser":[Global userId],@"activityIDs":activityId,@"toUserIDs":toUid,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
            }
            
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
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/Send.ashx"];

    //加载提示框
    [MBProgressHUD showMessage:@"正在发送" toView:self.view];
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (_sendType == 4||_sendType == 5)
        {
            if ([[JsonDic objectForKey:@"success"] isEqualToString:@"true"]) {
                [DejalBezelActivityView removeViewAnimated:YES];
                if(_sendType ==4)
                {
                    [MBProgressHUD showSuccess:@"传阅成功" toView:[self.navigationController.viewControllers objectAtIndex:0].view];
                }else if(_sendType ==5)
                {
                    [MBProgressHUD showSuccess:@"签阅成功" toView:[self.navigationController.viewControllers objectAtIndex:0].view];
                }
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }
            else{
                [self showSendError];
            }
        }
        else
        {
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];

            NSLog(@"发送&回退::%@",[JsonDic objectForKey:@"result"]);
            if ([[JsonDic objectForKey:@"result"] isEqual:@1])
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
        [MBProgressHUD hideHUDForView:self.view animated:NO];

        [self showSendError];
    }];
    
}

#pragma mark -- 发送完成

-(void)sendCompleted{

    if ([_delegate conformsToProtocol:@protocol(SendViewDelegate)] &&
        [_delegate respondsToSelector:@selector(sendViewDidSendCompleted)])
        //        if ([self.delegate respondsToSelector:@selector(sendViewDidSendCompleted)])
        
    {
        [self.delegate sendViewDidSendCompleted];
        
    }
    //   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    //[self.navigation popToViewController:[self.navigation.viewControllers objectAtIndex:0] animated:YES];
    //[self.navigation popToRootViewControllerAnimated:YES];
}

-(void)showSendError{
    [DejalBezelActivityView removeViewAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil] show];
}

//-(void)sendback{
//    NSString *suggest = _sendBackText.text;
//    if([suggest isEqualToString:@""]){
//        UIAlertView *msg =[[UIAlertView alloc] initWithTitle:@"提示" message:_sendType==1? @"请输入回退意见":@"请输入传阅意见" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        msg.tag = 1;
//        [msg show];
//    }else{
//        [_sendBackText resignFirstResponder];
//        [self onBtnCompleteTap:nil];
//    }
//}

//-(void)createSendBackPanel{
//
//    _sendBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
//    _sendBackView.backgroundColor = [UIColor whiteColor];
//    _sendBackView.layer.shadowOffset = CGSizeMake(0, -.5);
//    _sendBackView.layer.shadowOpacity = 0.30;
//    //UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
//    //line.backgroundColor = [UIColor grayColor];
//    //[_sendBackView addSubview:line];
//    _sendBackText = [[UITextField alloc] initWithFrame:CGRectMake(10, 13, self.view.frame.size.width-110, 35)];
//    _sendBackText.borderStyle = UITextBorderStyleRoundedRect;
//    //_signView.tintColor = [UIColor whiteColor];
//    _sendBackText.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1];
//    //_sendBackText.delegate = self;
//    _sendBackText.placeholder = _sendType==1? @"请输入回退意见":@"请输入传阅意见";
//    _sendBackText.enabled = NO;
//
//    [_sendBackView addSubview:_sendBackText];
//
//    _sendBackButton= [UIButton buttonWithType:UIButtonTypeCustom];
//    _sendBackButton.frame  = CGRectMake(self.view.frame.size.width-80, 13, 70, 35);
//    [_sendBackButton setTitle:@"完成" forState:UIControlStateNormal];
//    _sendBackButton.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
//    _sendBackButton.layer.cornerRadius = 5;
//    _sendBackButton.enabled = NO;
//
//    [_sendBackButton addTarget:self action:@selector(sendback) forControlEvents:UIControlEventTouchUpInside];
//
//    [_sendBackView addSubview:_sendBackButton];
//    [self.view addSubview:_sendBackView];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHide:) name:UIKeyboardWillHideNotification object:nil];
//}

//刷新tableView
//-(void)showActivities{
//    self.activityTable.delegate = self;
//    self.activityTable.dataSource = self;
//    [self.activityTable reloadData];
//}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
//{
//    if (nil!=_searchResult)
//    {
//        return _searchResult.count;
//    }
//    return _activities.count;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSArray *users=nil;
//    if (nil!=_searchResult)
//    {
//        users = [[_searchResult objectAtIndex:section] objectForKey:@"users"];
//    }else
//    {
//        users = [[_activities objectAtIndex:section] objectForKey:@"users"];
//    }
//    return users.count;
//    
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString *indentifierCell=@"Cell";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifierCell];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifierCell];
//    }
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:189.0/255.0 blue:21.0/255.0 alpha:1];
//    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
//    
//    NSArray *us = nil;
//    if (nil!=_searchResult) {
//        us = [[_searchResult objectAtIndex:indexPath.section] objectForKey:@"users"];
//    }else{
//        us = [[_activities objectAtIndex:indexPath.section] objectForKey:@"users"];
//    }
//    NSDictionary *userInfo = [us objectAtIndex:indexPath.row];
//    cell.textLabel.text = [userInfo objectForKey:@"userName"];
//    int si = [self selectedIndex:[userInfo objectForKey:@"userId"]];
//    cell.selected = si!=-1;
//    return cell;
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSDictionary *activity = [_activities objectAtIndex:section];
//    return [activity objectForKey:@"activityName"] ;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30.0;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.0;
//}
//
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (_sendType==2||_sendType==3) {
//        NSArray *users = nil;
//        if(nil!=_searchResult)
//        users = [[_searchResult objectAtIndex:indexPath.section] objectForKey:@"users"];
//        else
//        users = [[_activities objectAtIndex:indexPath.section] objectForKey:@"users"];
//        NSString *uid=[[users objectAtIndex:indexPath.row] objectForKey:@"userId"];
//        int si = [self selectedIndex:uid];
//        [_selectedItems removeObjectAtIndex:si];
//        [_selectedactivityIDs removeObjectAtIndex:si];
//        if (_selectedItems.count==0) {
//            //////
//            self.btnComplete.enabled = NO;
//            self.btnComplete.backgroundColor = [UIColor lightGrayColor];
//            
//            _sendBackButton.enabled = NO;
//            _sendBackButton.backgroundColor = [UIColor lightGrayColor];
//            _sendBackText.enabled = NO;
//            _sendBackText.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1];
//        }
//    }
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(_sendType==0||_sendType==1){
//        self.btnComplete.enabled = YES;
//        self.btnComplete.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
//    }else if(_sendType==2||_sendType==3){
//        NSArray *users = nil;
//        if(nil!=_searchResult)
//        users = [[_searchResult objectAtIndex:indexPath.section] objectForKey:@"users"];
//        else
//        users = [[_activities objectAtIndex:indexPath.section] objectForKey:@"users"];
//        NSString *uid=[[users objectAtIndex:indexPath.row] objectForKey:@"userId"];
//        [_selectedItems addObject:uid];
//        //
//        NSString *activityId = [[users objectAtIndex:indexPath.row] objectForKey:@"activityID"];
//        [_selectedactivityIDs addObject:activityId];
//        //////
//        
//        self.btnComplete.enabled = YES;
//        self.btnComplete.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
//        
//    }
//    _selectedIndexPath = indexPath;
//}

//-(void)keyboardWasHide:(NSNotification *)notif
//{
//    _sendBackView.frame = CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60);
//}

//- (void)keyboardWasShown:(NSNotification *) notif
//{
//    NSDictionary *info = [notif userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    _sendBackView.frame = CGRectMake(0, self.view.frame.size.height-keyboardSize.height-60, self.view.frame.size.width, 60);
//}

//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    if(nil!=_searchTimer)
//        [_searchTimer invalidate];
//    NSString *key = self.searchBar.text;
//    if ([key isEqualToString:@""]) {
//        [self clearSearch];
//    }else {
//        _searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(doSearch) userInfo:nil repeats:NO];
//    }
//}

//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [self clearSearch];
//}

//-(void)clearSearch{
//    if(nil!=_searchTimer)
//        [_searchTimer invalidate];
//    _searchResult = nil;
//    [self.activityTable reloadData];
//}

//-(void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    if (nil!=_sendBackText) {
//        [_sendBackText resignFirstResponder];
//    }
//    [self.searchBar resignFirstResponder];
//}
//-(void)doSearch
//{
//    if (nil==_activities) {
//        return;
//    }
//    NSString *key = self.searchBar.text;
//    _searchResult = [[NSMutableArray alloc] initWithCapacity:_activities.count];
//    for (int i=0; i<_activities.count; i++) {
//        NSDictionary *targetGroup = [_activities objectAtIndex:i];
//        NSArray *targetUsers = [targetGroup objectForKey:@"users"];
//        NSMutableArray *sItems = [[NSMutableArray alloc] initWithCapacity:10];
//        for (int j=0; j<targetUsers.count; j++) {
//            NSString *n1 = [[targetUsers objectAtIndex:j] objectForKey:@"userName"];
//            if ([n1 rangeOfString:key].length>0) {
//                [sItems addObject:[targetUsers objectAtIndex:j]];
//            }
//        }
//        if (sItems.count>0) {
//            [_searchResult addObject:@{@"activityName":[targetGroup objectForKey:@"activityName" ],@"activityID":[targetGroup objectForKey:@"activityID"],@"users":sItems}];
//        }
//    }
//    [self.activityTable reloadData];
//}

//-(int)selectedIndex:(NSString *)uid{
//    for (int i=0; i<_selectedItems.count; i++) {
//        NSString *saveId = [_selectedItems objectAtIndex:i];
//        if ([saveId isEqualToString:uid]) {
//            return i;
//        }
//    }
//    
//    return -1;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
