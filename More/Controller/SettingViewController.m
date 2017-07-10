//
//  SettingViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/31.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "SettingViewController.h"
#import "SHImformationDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SHFeedbackViewController.h"
#import "GesturesUnLock.h"
#import "AppDelegate.h"
#import "ChangePasswordVC.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) SHImformationDetailViewController *informationDetail;
@property (nonatomic,strong) UIImageView *touxiang;

//手势开关
@property (nonatomic,strong) UISwitch *gesSwitch;
@property (nonatomic,strong) UIButton *exitBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL mask;
@property (nonatomic,strong) UIAlertView* exitAlert;
@property (nonatomic,strong) UIView *topview;
@property (nonatomic,assign) CGFloat size;

@end

@implementation SettingViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;

    // 读取缓存数据
    [self readSystemDataSize];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic=[userDefaults objectForKey:@"touchLock"];
    if (_tableView) {
        _tableView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    //存在密码
    if (dic!=nil&&dic.count>0) {
        NSString *flag=[dic objectForKey:@"isLock"];
        //需要密码
        if ([flag isEqualToString:@"YES"]) {
            _gesSwitch.on=YES;
        }
        else
            _gesSwitch.on=NO;
    }
    else
        _gesSwitch.on=self.swhOn;
    
    if (self.gesSwitch.on == YES) {
        [self.tableView reloadData];

    }
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    //self.title = @"设置";
    [self initNavigationBarTitle:@"设置"];
    
    UIView *topview =[[UIView alloc] initWithFrame:CGRectMake(0, -64, MainR.size.width,64)];
    topview.backgroundColor = [UIColor whiteColor];
    _topview =topview;
    [self.view addSubview:_topview];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(setgetureState) name:@"PassworldResetSuccess" object:nil];
    self.view.backgroundColor = RGB(245, 245, 245);
    //创建tableView
    [self creatTabel];
    //创建退出按钮
    [self createExitBtn];
    //创建switch
    [self createGesSwit];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSetting) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转结束执行的方法
- (void)changeSetting
{
    self.tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _gesSwitch.frame=CGRectMake(MainR.size.width - 65, 5, 0, 0);
    _exitBtn.frame= CGRectMake(20, MainR.size.height-64-64, MainR.size.width-40, 44);
    [self.tableView reloadData];
    
}

#pragma mark -- 读取缓存数据大小
-(void)readSystemDataSize
{
    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    _size = size;
}
#pragma mark -- 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            // 偏好设置不能清理(用户信息)
            if (![fileName isEqualToString:@"Preferences/com.dist.WZYD.plist"] && ![fileName isEqualToString:@"Preferences"]) {
                NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
            }
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}


- (void)createExitBtn
{
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exitBtn.frame= CGRectMake(20, MainR.size.height-64-64, MainR.size.width-40, 44);
    [exitBtn setBackgroundColor:RGB(34, 152, 239)];
//    [exitBtn setBackgroundColor:[UIColor blackColor]];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(exitApp) forControlEvents:UIControlEventTouchUpInside];
    _exitBtn = exitBtn;
    [self.view addSubview:_exitBtn];

}


- (void)creatTabel
{
    UITableView *tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-64) style:UITableViewStyleGrouped];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    //分割线的颜色
    tabelView.separatorColor = RGB(230, 230, 230);
    tabelView.backgroundColor = RGB(245, 245, 245);
    _tableView = tabelView;
    [self.view addSubview:_tableView];
    
}

#pragma  mark - uitableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
      
        if(self.gesSwitch.on == YES)
        {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    else if (section ==1)
    {
        
        return 1;
    }
//    else if (section == 2)
//    {
//        return 1;
//        
//    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
   
    //cell左侧label
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 9, 200, 30)];
    leftLabel.font=[UIFont systemFontOfSize:17];
    leftLabel.textColor=[UIColor blackColor];
  
    [cell.contentView addSubview:leftLabel];
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            //设置cell的选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [leftLabel setText:@"手势密码"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];

            NSDictionary *dic=[userDefaults objectForKey:@"touchLock"];

                //存在密码
                    if (dic!=nil&&dic.count>0) {
                        NSString *flag=[dic objectForKey:@"isLock"];
                        //需要密码
                        if ([flag isEqualToString:@"YES"]) {
                            _gesSwitch.on=YES;
                        }
                        else
                            _gesSwitch.on=NO;
                    }
                    else
                        _gesSwitch.on=self.swhOn;
            
                [cell.contentView addSubview:_gesSwitch];
            
        }
        else if (indexPath.row==1){
            
            [leftLabel setText:@"修改手势密码"];
            
        }
    }
    else if(indexPath.section==1){

        if (indexPath.row==0) {
            //[leftLabel setText:@"修改登录密码"];
            [leftLabel setText:@"缓存数据"];
            NSString *size = _size > 1 ? [NSString stringWithFormat:@"%.0f M", _size] : [NSString stringWithFormat:@"%.0f K", _size * 1024.0];
            cell.detailTextLabel.text = size;
        }
    }
//    else if (indexPath.section == 2)
//    {
//        [leftLabel setText:@"用户反馈"];
//        
//    }
    
    cell.contentView.backgroundColor =[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1];
    
    return cell;
}


- (void)createGesSwit
{
    UISwitch *gesSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(MainR.size.width - 65, 5, 0, 0)];
    gesSwitch.onTintColor = RGB(34, 152, 239);
    
    //监听switch状态改变
    [gesSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    
    _gesSwitch =gesSwitch;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 &&indexPath.row ==1) {
        //修改手势密码
        [self  reGesture];
    }
    if(indexPath.section == 2&& indexPath.row == 0)
    {
     //意见反馈
        [self feedBackClick];
        
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        //ChangePasswordVC *changePassword =[[ChangePasswordVC alloc] init];
        //[self.navigationController pushViewController:changePassword animated:YES];
        [self putBufferBtnClicked];
    }
}

#pragma mark -- 清理缓存提示

-(void)putBufferBtnClicked
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要清空缓存数据吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSTemporaryDirectory()];
        
        [MBProgressHUD showSuccess:@"清除成功"];
        [self readSystemDataSize];
        [_tableView reloadData];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 偏好设置不能清理(用户信息)
            if (![fileName isEqualToString:@"Preferences/com.dist.WZYD.plist"] && ![fileName isEqualToString:@"Preferences"]) {
                // 拼接路径
                NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                // 将文件删除
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2)
    {
        return 0.1;
    }
    if (section ==1) {
        return 30;
    }
    
    return 30;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if(section ==1)
    {
        return 20;
    }
    else{
        return 0.1;
    }


}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *tipView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 30)];
//    tipView.backgroundColor =[UIColor lightGrayColor];
//    NSString *name;
//    if (section ==0) {
//        name = @"手势密码";
//    }
//    else if (section ==1)
//    {
//        
//        name = @"登录密码";
//        
//    }
//    else
//    {
//        name = @"";
//        
//    }
//    UILabel *label =[self labelWithFrame:CGRectMake(10, 0, MainR.size.width,30) text:name font:13];
//    label.textColor =[UIColor blackColor];
//    [tipView addSubview:label];
//    
//    return tipView;
//    
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(35, 0, CGRectGetWidth(tableView.frame)-35, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 20)];
    view.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    return view;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *name;
        if (section ==0)
        {
            name = @"手势密码";
        }
        else if (section ==1)
        {
            //name = @"登录密码";
             name = @"缓存数据";
    
        }
        else
        {
            name = @"";
        }
    
    return name;

}


//密码设置成功后开启手势密码
- (void)setgetureState
{
    self.gesSwitch.on = YES;
    self.swhOn = YES;
    
}


//设置功能列表
- (void) setListFunction
{
    //    //手势密码
    //    UILabel *gesTipL =[self labelWithFrame:CGRectMake(20, 10, MainR.size.width, 30) text:@"手势密码" font:13];
    //
    //       //手势密码
    //    UIButton *gesture = [UIButton buttonWithType:UIButtonTypeCustom];
    //    gesture.frame= CGRectMake(0, CGRectGetMaxY(gesTipL.frame)+15, MainR.size.width, 40);
    //    [self buttonwithName:gesture title:@"手势密码" imageName:@"iconfont-shoushimima0"];
    ////    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(120, 0, 110, 40)];
    ////    [label setText:@"点击修改密码"];
    ////    label.font =[UIFont systemFontOfSize:13];
    ////    label.textColor =[UIColor lightGrayColor];
    ////    [gesture addSubview:label];
    //    //添加方法
    //    [gesture addTarget:self action:@selector(reGesture) forControlEvents:UIControlEventTouchUpInside];
    //    UISwitch *gesSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(MainR.size.width-80, CGRectGetMaxY(gesTipL.frame)+18, 0, 0)];
    //        gesSwitch.onTintColor = [UIColor colorWithRed:31.0/255.0 green:88.0/255.0 blue:212.0/255.0 alpha:1];
    //
    //        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //        NSDictionary *dic=[userDefaults objectForKey:@"touchLock"];
    //    //存在密码
    //        if (dic!=nil&&dic.count>0) {
    //            NSString *flag=[dic objectForKey:@"isLock"];
    //            //需要密码
    //            if ([flag isEqualToString:@"YES"]) {
    //                gesSwitch.on=YES;
    //            }
    //            else
    //                gesSwitch.on=NO;
    //        }
    //        else
    //            gesSwitch.on=self.swhOn;
    //        //监听switch状态改变
    //        [gesSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    //
    //    _gesSwitch =gesSwitch;
    //    [self.view addSubview:_gesSwitch];
    //
    //
    //
    //
    //    //用户反馈
    //    UIButton *feedBack = [UIButton buttonWithType:UIButtonTypeCustom];
    //    feedBack.frame= CGRectMake(0, CGRectGetMaxY(gesture.frame), MainR.size.width, 40);
    //    [self buttonwithName:feedBack title:@"用户反馈" imageName:@"iconfont-yonghufankui"];
    //
    //
    //    [feedBack addTarget:self action:@selector(feedBackClick) forControlEvents:UIControlEventTouchUpInside];
    //    //修改密码
    //    UIButton *modifyS = [UIButton buttonWithType:UIButtonTypeCustom];
    //    modifyS.frame= CGRectMake(0, CGRectGetMaxY(feedBack.frame), MainR.size.width, 40);
    //    //    [self buttonwithName:modifyS title:@"修改密码" imageName:@"ic_mima_alter"];
    //    [self buttonwithName:modifyS title:@"修改密码" imageName:@"iconfont-xiugaimima"];
    ////
    ////
    ////    [modifyS addTarget:self action:@selector(modifyPassWordClick) forControlEvents:UIControlEventTouchUpInside];
    
}
//label的初始化
- (UILabel *)labelWithFrame:(CGRect )rect text:(NSString *)text font:(CGFloat )fontS
{
    UILabel *label= [[UILabel alloc] initWithFrame:rect];
    label.textColor =[UIColor lightGrayColor];
    [label setFont:[UIFont systemFontOfSize:fontS]];
    [label setText:text];
    [self.view addSubview:label];
    return label;
    
}

//////按钮的初始化
//-( void)buttonwithName:(UIButton *)name title:(NSString *)title imageName:(NSString *)imageName
//{
//
//    //    文字
//    name.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
//    [name setTitle:title forState:UIControlStateNormal];
//    [name setTitleEdgeInsets:UIEdgeInsetsMake(0,28, 0, MainR.size.width -100)];
//
//    [name setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [name setFont:[UIFont systemFontOfSize:13]];
//
//    //    图标
//    [name setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [name setImageEdgeInsets:UIEdgeInsetsMake(12, 15, 12, self.universal.frame.size.width-18)];
//    [self.universal addSubview:name];
//
//
//}


//个人资料详情
- (void)informationDetailClick
{
    if (!_informationDetail) {
        _informationDetail =[[SHImformationDetailViewController alloc] init];
        
    }
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:_informationDetail animated:YES];
    
}

//手势密码方法
- (void)reGesture
{
    GesturesUnLock *lockVC=[[GesturesUnLock alloc]init];
    lockVC.Flag=YES;
    lockVC.reSet=YES;
    lockVC.isHomePage=NO;
    lockVC.btnBack.alpha=1.0;
    [self.navigationController pushViewController:lockVC animated:NO];
    
}
//手势密码
- (void)switchChange:(UISwitch *)sender
{
    [self.tableView reloadData];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"touchLock"]];
    NSLog(@"是否开启手势%d",sender.on);
    
    if (sender.on==YES) {
        //有密码了
        if (dic!=nil&&dic.count>0) {
            [dic setObject:@"YES" forKey:@"isLock"];
            //保存密码数据
            [userDefaults setObject:dic forKey:@"touchLock"];
            return;
        }
        //无密码
        else{
            //询问是否设置手势
            UIAlertView *lockAlert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未设置手势密码，现在开始设置?" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"不了", nil];
            [lockAlert show];
        }
    }
    else{
        if (dic!=nil&&dic.count>0) {
            [dic setObject:@"NO" forKey:@"isLock"];
            [userDefaults setObject:dic forKey:@"touchLock"];
            return;
        }
        else
            return;
        //        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        //        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    }
    
    NSLog(@"开关被点击");
    
}


//用户反馈

- (void)feedBackClick
{
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    SHFeedbackViewController *feedBackC=[[SHFeedbackViewController alloc] init];
    
    [self.navigationController pushViewController:feedBackC animated:YES];
    
}




//退出登录
- (void)exitApp
{
    UIAlertView* exitAlert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出后您将无法获取推送信息,确定退出当前账号吗?" delegate:self cancelButtonTitle:@"退出"otherButtonTitles:@"取消",nil];
    _exitAlert = exitAlert;
    [_exitAlert show];
}

//退出应用方法
- (void)exitApplication {
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:0.3f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

#pragma -mark     UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==textAlert) {
        if (buttonIndex==0) {
            NSLog(@"密码是 :%@",[alertView textFieldAtIndex:0].text);
        }
        else
            NSLog(@"取消");
    }
    else if (alertView==_exitAlert)
    {
        if (buttonIndex==0) {
            
            //清空数据
            [defaults setObject:@"" forKey:@"pwd"];
            [defaults setValue:@"" forKey:@"name"];
            [defaults setBool:NO   forKey:@"rem"];
            [defaults setBool:NO forKey:@"auto"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:nil forKey:@"touchLock"];
            //强制同步
            [defaults synchronize];
            
            [self exitApplication];

        }
      
    }
    else
    {
        if (buttonIndex==0) {
            GesturesUnLock *lockVC=[[GesturesUnLock alloc]init];
            lockVC.Flag=YES;
            lockVC.isHomePage=NO;
            
            [self.navigationController pushViewController:lockVC animated:YES];
        }
        else//不了
        {
            _gesSwitch.on = NO;
            [self.tableView reloadData];
            return;
        }
    }
    
}




 -(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
