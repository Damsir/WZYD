//
//  HomeViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "HomeViewController.h"
#import "MainCViewController.h"
#import "QueryViewController.h"
#import "SearchViewController.h"
#import "MeetingRoomViewController.h"
#import "PresignedViewController.h"
#import "HelpViewController.h"
#import "MapViewController.h"
#import "QuestionViewController.h"
#import "DamUpdateManager.h"
#import "DigitMaterialViewController.h"// FTP
#import "ContactsViewController.h"

#define Button_W 80.0

@interface HomeViewController ()

@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIButton *searchButton;//项目查询
@property(nonatomic,strong) UIButton *meetingButton;//日程
@property(nonatomic,strong) UIButton *approveButton;//审批
@property(nonatomic,strong) UIButton *documentButton;//公文
@property(nonatomic,strong) UIButton *mapButton;//地图
@property(nonatomic,strong) UIButton *materialButton;//FTP文档
@property(nonatomic,strong) UIButton *mailButton;//电子邮件
@property(nonatomic,strong) UIButton *presignButton;//预签
@property(nonatomic,strong) UIButton *helpButton;//帮助

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //版本请求
    //[self checkVersion];
    [self checkUpdated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"主页";
    [self initNavigationBarTitle:@"主页"];
    
    [self createHomePageButtons];
    //屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _backView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-113)/2);
}

//首页导航按钮
-(void)createHomePageButtons
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    backView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-113)/2);
    //backView.backgroundColor = [UIColor orangeColor];
    _backView = backView;
    [self.view addSubview:backView];
    
    
    
    CGFloat gap_h = (SCREEN_WIDTH-Button_W*3)/4;
    CGFloat gap_v = 30.0;
    
    // 公文办理
    UIButton *documentButton  = [self createButtonWithImage:@"gwbl" andTitle:@"公文办理" andFrame:CGRectMake(gap_h, 0, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:101];
    _documentButton = documentButton ;
    [backView addSubview:documentButton];
    
    // 项目审批
    UIButton *approveButton  = [self createButtonWithImage:@"xmsp" andTitle:@"项目审批" andFrame:CGRectMake(CGRectGetMaxX(_documentButton.frame)+gap_h, 0, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:102];
    _approveButton = approveButton ;
    [backView addSubview:approveButton];
    
    // 项目查询
    UIButton *searchButton = [self createButtonWithImage:@"xmcx" andTitle:@"项目查询" andFrame:CGRectMake(CGRectGetMaxX(_approveButton.frame)+gap_h, 0, Button_W, Button_W)andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:103];
    _searchButton = searchButton;
    [backView addSubview:searchButton];
    
    // GIS地图 (规划成果)
    UIButton *mapButton  = [self createButtonWithImage:@"dt" andTitle:@"规划成果" andFrame:CGRectMake(gap_h, CGRectGetMaxY(_searchButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:104];
    _mapButton = mapButton ;
    [backView addSubview:mapButton];
    
    // 材料 (规划资料)
    UIButton *materialButton  = [self createButtonWithImage:@"wd" andTitle:@"规划资料" andFrame:CGRectMake(CGRectGetMaxX(_mapButton.frame)+gap_h, CGRectGetMaxY(_searchButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:105];
    _materialButton = materialButton ;
    [backView addSubview:materialButton];
    
    // 预签
    UIButton *presignButton = [self createButtonWithImage:@"yq" andTitle:@"预签" andFrame:CGRectMake(CGRectGetMaxX(_materialButton.frame)+gap_h, CGRectGetMaxY(_searchButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:106];
    _presignButton = presignButton;
    [backView addSubview:presignButton];
    
    // 通讯录
    UIButton *mailButton  = [self createButtonWithImage:@"txl" andTitle:@"通讯录" andFrame:CGRectMake(gap_h, CGRectGetMaxY(_presignButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:107];
    _mailButton = mailButton ;
    [backView addSubview:mailButton];

    // 会议安排
    UIButton *meetingButton = [self createButtonWithImage:@"hysap" andTitle:@"会议安排" andFrame:CGRectMake(CGRectGetMaxX(_mailButton.frame)+gap_h, CGRectGetMaxY(_presignButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:108];
    _meetingButton = meetingButton;
    [backView addSubview:meetingButton];

    // 问题反馈
    UIButton *helpButton  = [self createButtonWithImage:@"wtfk" andTitle:@"问题反馈" andFrame:CGRectMake(CGRectGetMaxX(_meetingButton.frame)+gap_h, CGRectGetMaxY(_presignButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:109];
    _helpButton = helpButton ;
    [backView addSubview:helpButton];
   
}

-(UIButton *)createButtonWithImage:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame andTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets andTag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
   // button.backgroundColor = [UIColor orangeColor];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInsets];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 10)];
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = tag;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)buttonOnclick:(UIButton *)btn
{
    // 公文办理
    if (btn.tag == 101)
    {
        self.tabBarController.selectedIndex = 2;
    }
    // 项目审批
    else if (btn.tag == 102)
    {
        self.tabBarController.selectedIndex = 1;
    }
    // 项目查询
    else if (btn.tag == 103)
    {
        QueryViewController *queryVC = [[QueryViewController alloc] init];
        queryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:queryVC animated:YES];
//        SearchViewController *searchVC = [[SearchViewController alloc] init];
//        searchVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:searchVC animated:YES];
    }
    // 规划成果(地图)
    else if (btn.tag == 104)
    {
        MapViewController *mapVC = [[MapViewController alloc] init];
        mapVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    // 规划资料(FTP文档)
    else if (btn.tag == 105)
    {
        DigitMaterialViewController *digitVC = [[DigitMaterialViewController alloc] init];
        digitVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:digitVC animated:YES];
    }
    // 预签
    else if (btn.tag == 106)
    {
        PresignedViewController *presignedVC = [[PresignedViewController alloc] init];
        presignedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:presignedVC animated:YES];
    }
    // 通讯录
    else if (btn.tag == 107)
    {
        ContactsViewController *ContactsVC = [[ContactsViewController alloc] init];
        ContactsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ContactsVC animated:YES];
    }
    // 会议安排
    else if (btn.tag == 108)
    {
        MeetingRoomViewController *meetVC=[[MeetingRoomViewController alloc] init];
        meetVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:meetVC animated:YES];
    }
    // 问题反馈
    else if (btn.tag == 109)
    {
        QuestionViewController *questionVC = [[QuestionViewController alloc] init];
        questionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:questionVC animated:YES];
    }
}

#pragma mark -- 检测版本更新

- (void)checkVersion
{
    NSError *error;
    NSString *newVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.dist.com.cn/App/wz/wzyd/version.txt"] encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"newVersion=%@",newVersion);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"currentVersion=%@",currentVersion);
    
    
    if(newVersion != nil && ![newVersion isEqualToString:@""] && ![newVersion isEqualToString:currentVersion])
    {
        if (![newVersion isEqualToString:currentVersion]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"新版本已发布" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去更新", nil];
            
            [alert show];
        }
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSURL *url=[NSURL URLWithString:@"http://dist.com.cn/app/wz/wzyd"];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark -- 检测版本更新

-(void)checkUpdated{
    
    // 1.
    [DamUpdateManager compareVersionWithPlist:^(BOOL isNewVersion,NSString *versionAddress) {
        
        if(isNewVersion){
            // 当前是最新版本
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
            return ;
            
        }else if(!isNewVersion && [versionAddress isEqualToString:VersionUrl_Dist]){
            [self showAlertWithDownloadUrl:AppDownloadUrl_Dist];
        }else if(!isNewVersion && [versionAddress isEqualToString:VersionUrl_Mayun]){
            [self showAlertWithDownloadUrl:AppDownloadUrl_Pgyer];
        }
    }];
    
    
    // 2.
    //    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    //    // 系统更新方法
    //    //[[PgyUpdateManager sharedPgyManager] checkUpdate];
    //    // 自定义更新方法
    //    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
}

/**
 *  检查更新回调
 *
 *  @param response 检查更新的返回结果
 */
- (void)updateMethod:(NSDictionary *)response
{
    if (response[@"downloadURL"]) {
        
        NSString *message = response[@"releaseNote"];
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本,是否前往更新?" message:message delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil,nil];
        //        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本,请前往更新" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            //  调用checkUpdateWithDelegete后可用此方法来更新本地的版本号，本地存储的Build号被更新后，SDK会将本地版本视为最新。对当前版本调用检查更新方法将不再回传更新信息。
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:updateAction];
        //[alert addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alert animated:YES completion:nil];
    }
}

-(void)showAlertWithDownloadUrl:(NSString *)downloadUrl{
    
    NSError *error;
    NSString *updateContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:UpdateUrl_Mayun] encoding:NSUTF8StringEncoding error:&error];
    // 提示更新
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新版本已发布,请前往更新" message:updateContent preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
    }];
    
    //[alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}


//导航栏标题
-(void)initNavigationBarTitle:(NSString *)title
{
    UILabel *lab      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    lab.textColor     = [UIColor whiteColor];
    lab.font          = [UIFont boldSystemFontOfSize:17.0];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text          = title;
    
    self.navigationItem.titleView = lab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
