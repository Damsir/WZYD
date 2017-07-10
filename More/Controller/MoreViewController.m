//
//  MoreViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/30.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "MoreViewController.h"
#import "Global.h"
#import "SHImformationDetailViewController.h"
#import "PersenalViewController.h"
#import "SettingViewController.h"
#import "ContactViewController.h"
#import "AFNetworking.h"
#import "SHMembers.h"
#import "SHMembersModel.h"
#import "DigitMaterialViewController.h"
#import "ComprehensiveVC.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MyRequestManager.h"
#import "MBProgressHUD+MJ.h"
#import "QueryViewController.h"
#import "LoginViewController.h"
#import "ChangePasswordVC.h"
#import "MeetingViewController.h"
#import "NoticeViewController.h"
#import "MicroblogViewController.h"
#import "HelpViewController.h"
#import "AppDelegate.h"

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *tableViewMore;
@property(nonatomic,strong) NSArray *contacts;
@property(nonatomic,strong) UIImageView *portaitI;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong) NSString *placeUrl;
@property(nonatomic,strong) NSString *currentDownlaodPath;
@property(nonatomic,assign) CGFloat downloadRate;
@property(nonatomic,strong) NSTimer *downloadReateTimer;
@property(nonatomic,strong) UIImage *image;

@property(nonatomic,strong) NSArray *userInfo;

@end

@implementation MoreViewController
- (NSArray *)contacts
{
    if (_contacts==nil) {
        _contacts =[NSArray array];
    }
    return  _contacts;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    
}

-(void)LoadImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"type":@"smartplan",@"action":@"getUserPic",@"userId":[Global userId]};
    
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"])
        {
            _url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?r=%ld",[rs objectForKey:@"result"],random()/10]];
            
            [_portaitI setImageWithURL:_url placeholderImage:[UIImage imageNamed:@"profile"]];
            
        }
        else
        {
            [_portaitI setImage:[UIImage imageNamed:@"profile"]];
            
        }
        //[_tableViewMore reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_portaitI setImage:[UIImage imageNamed:@"profile"]];
        
        [_tableViewMore reloadData];
        
    }];
    
}

-(void)loadUserInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    // 个人信息
    //{"success":true,"result":[{"ID":"Dist.Mobile.SmartPlan.sp.UserVO","LoginName":"lw-test(李卫)","Name":"李卫","BmName":"信息中心"}]}
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/UserDetail.ashx"];
    NSDictionary *parameters = @{@"userID":[Global userId]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([JsonDic objectForKey:@"result"])
        {
            _userInfo = [JsonDic objectForKey:@"result"];
        }
        [_tableViewMore reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self LoadImage];
    [self loadUserInfo];

    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    //self.navigationItem.title = @"更多";
    [self initNavigationBarTitle:@"更多"];
    
    
    UITableView *tabLeMore = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    if (MainR.size.width > 414)
    {
        tabLeMore.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    _tableViewMore = tabLeMore;
    _tableViewMore.delegate =self;
    _tableViewMore.dataSource= self;
    _tableViewMore.backgroundColor =[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    [self.view addSubview:_tableViewMore];

    _tableViewMore.bounces = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMore) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //监听头像修改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadImage) name:@"portaitChange"object:nil];
   
}

//屏幕旋转结束执行的方法
- (void)changeMore
{
    self.tableViewMore.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.tableViewMore reloadData];
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (MainR.size.width<414 && indexPath.section != 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    CGFloat marw = 0;
    if (MainR.size.width>414) {
        marw = 10;
    }
    
    if (indexPath.section==0) {
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//        UIImageView *imageview1=[[UIImageView alloc] initWithFrame:CGRectMake(15+marw, 15, 70, 70)];
//        imageview1.layer.borderWidth = 0.5;
//        imageview1.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
//        imageview1.layer.cornerRadius = 5;
//        imageview1.layer.masksToBounds = YES;
//        _portaitI = imageview1;
        
//        [_portaitI sd_setImageWithURL:_url placeholderImage:[UIImage imageNamed:@"icon"]];
//        if ([_placeUrl isEqualToString:@""] || _isSucceed == NO)
//        {
//             _portaitI.image = [UIImage imageNamed:@"profile"];
//        }
//        else
//        {
//            _portaitI.image = _image;
//        }
//        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(102+marw, 20, 120, 30)];
//        lblName.text=[[Global userInfo] objectForKey:@"name"];
//        lblName.font=[UIFont boldSystemFontOfSize:17];
//        
//        UILabel *lblHint=[[UILabel alloc]initWithFrame:CGRectMake(102+marw, 50, 180, 30)];
//        lblHint.textColor=[UIColor grayColor];
//        lblHint.font=[UIFont systemFontOfSize:15];
//        lblHint.text=[Global userId];
        
        
//        [cell.contentView addSubview:_portaitI];
//        [cell.contentView addSubview:lblName];
//        [cell.contentView addSubview:lblHint];
        cell.textLabel.text = [Global userName];
        cell.detailTextLabel.text =[[_userInfo firstObject] objectForKey:@"BmName"];
        
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(7+marw, 10, 32, 32)];
            imageView.image=[UIImage imageNamed:@"rc"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(50+marw, 9, 100, 30)];
            setting.text=@"日程";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
        }
        else if (indexPath.row == 1)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(7+marw, 10, 32, 32)];
            imageView.image=[UIImage imageNamed:@"weibo"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(50+marw, 9, 100, 30)];
            setting.text=@"微博";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
        }
        else if (indexPath.row == 2)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(7+marw, 10, 32, 32)];
            imageView.image=[UIImage imageNamed:@"gg"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(50+marw, 9, 100, 30)];
            setting.text=@"公告";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
        }
        else if (indexPath.row == 3)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(7+marw, 10, 32, 32)];
            imageView.image=[UIImage imageNamed:@"bz"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(50+marw, 9, 100, 30)];
            setting.text=@"帮助";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
        }
        else if (indexPath.row == 4)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(7+marw, 10, 32, 32)];
            imageView.image=[UIImage imageNamed:@"sz"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(50+marw, 9, 100, 30)];
            setting.text=@"设置";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
            
        }
        else if (indexPath.row == 5)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(7+marw, 10, 32, 32)];
            imageView.image=[UIImage imageNamed:@"zx"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(50+marw, 9, 100, 30)];
            setting.text=@"注销";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
            
        }
        else if (indexPath.row == 6)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(7+marw, 10, 32, 32)];
            imageView.image=[UIImage imageNamed:@"xgmm"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(50+marw, 9, 100, 30)];
            setting.text=@"修改密码";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
        }
    }
    
    cell.contentView.backgroundColor =[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1];
    CGFloat y = 0;
    CGFloat jtY = 0;
    if (MainR.size.width>414) {
        if (indexPath.section==0) {
            y = 99;
            jtY = (100-20)*0.5;
        }
        else
        {
            y= 49;
            jtY = (50-20)*0.5;
            
        }
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, y, MainR.size.width, 1)];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        [cell.contentView addSubview:line];
        if (indexPath.section == 1 &&indexPath.row==0) {
            UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
            line.backgroundColor =RGB(238.0, 238.0, 238.0);
            [cell.contentView addSubview:line];
        }
        
        if (indexPath.section ==1) {
            UIImageView *jiantouI = [[UIImageView alloc] initWithFrame:CGRectMake(MainR.size.width-40, jtY, 20,20 )];
            jiantouI.image =[UIImage imageNamed:@"jiant"];
            [cell.contentView addSubview:jiantouI];
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1)
    {
        return 7;
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0.1;
            break;
        case 1:
            return 10.0;
            break;
        default:
            break;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 100;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIViewController *VC=nil;
//    NSString *title=nil;
    if (indexPath.section==0)
    {
        
        SHImformationDetailViewController *informatin =[[SHImformationDetailViewController alloc] init];
//        VC=informatin;
//        title= @"返回";
        informatin.hidesBottomBarWhenPushed = YES;
       // [self.navigationController pushViewController:informatin animated:YES];
        
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row == 0)
        {
            MeetingViewController *meetVC=[[MeetingViewController alloc] init];
            meetVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:meetVC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            MicroblogViewController *microVC = [[MicroblogViewController alloc] init];
            microVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:microVC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            NoticeViewController *noticeVC = [[NoticeViewController alloc] init];
            noticeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:noticeVC animated:YES];
        }
        else if (indexPath.row == 3)
        {
            HelpViewController *helpVC = [[HelpViewController alloc] init];
            helpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpVC animated:YES];
        }
        else if (indexPath.row == 4)
        {
            SettingViewController *setting= [[SettingViewController alloc] init];
            setting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setting animated:YES];
        }
        else if (indexPath.row == 5)
        {
//            LoginViewController *loginVC= [[LoginViewController alloc] init];
            //id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
            //[self removeFromParentViewController];
            //AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
            //[delegate changeRootView];
           // self.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
           // [self presentViewController:loginVC animated:YES completion:nil];
            //[UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
//            BOOL autoBtn = [[defaults objectForKey:@"auto"] boolValue];
//            if (autoBtn)
//            {
//                CATransition *transition = [CATransition animation];
//                transition.duration = 1.8;
//                transition.type = @"rippleEffect";
//                //transition.type = @"cube";
//                transition.subtype = kCATransitionFromRight;
//                //transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//                [self.view.layer addAnimation:transition forKey:nil];
//                //[self.navigationController.view.layer addAnimation:transition forKey:nil];
//                
//                // 定时
//                [self performSelector:@selector(push:) withObject:nil afterDelay:1.5];
//            }else
//            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:self userInfo:nil];
//            }
            
        
        }
        else if (indexPath.row == 6)
        {
            ChangePasswordVC *changePassword =[[ChangePasswordVC alloc] init];
            changePassword.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changePassword animated:YES];
        }
        
        
    }
    else if (indexPath.section==2)
    {
        exit(0);
    }
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- push
-(void)push:(id)sender
{
    LoginViewController *loginVC= [[LoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
}


-(void)exitLogin
{
    NSLog(@"退出登录");
    exit(0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
