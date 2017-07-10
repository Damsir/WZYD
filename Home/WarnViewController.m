//
//  WarnViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "WarnViewController.h"
#import "DeviceInfo.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "AppDelegate.h"

@interface WarnViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UILabel *warnLabel;
@property(nonatomic,strong) UIButton *reloadButton;
@property(nonatomic,strong) UIView *naviView;
@property(nonatomic,strong) UILabel *naviTitle;
@property(nonatomic,strong) NSString *deviceUUID;

@end

@implementation WarnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    [self initNavigationBarTitle:@"设备未授权"];
    
    _deviceUUID = [DeviceInfo deviceUUID];
    
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.frame = CGRectMake(20, 64+HeaderHeight, SCREEN_WIDTH-40, 300);
   // warnLabel.backgroundColor = [UIColor grayColor];
    warnLabel.text = [NSString stringWithFormat:@"您的硬件码是: %@ ,目前尚未获取授权，请记录硬件码并反馈给管理员!",_deviceUUID];
    warnLabel.numberOfLines = 0;
    //label的frame根据文字自适应高宽
    [warnLabel sizeToFit];
    
    _warnLabel = warnLabel;

    [self.view addSubview:warnLabel];
    
    [self createReloadButton];
    
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _warnLabel.frame = CGRectMake(20, 64+HeaderHeight, SCREEN_WIDTH-40, 300);
    [_warnLabel sizeToFit];
    _reloadButton.frame = CGRectMake(20, CGRectGetMaxY(_warnLabel.frame) + HeaderHeight, SCREEN_WIDTH-40, 40);

    
    _naviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    _naviTitle.frame = CGRectMake(0, 24, SCREEN_WIDTH, 40);
    

}

#pragma mark -- 刷新按钮

-(void)createReloadButton
{
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reloadButton.frame = CGRectMake(20, CGRectGetMaxY(_warnLabel.frame) + HeaderHeight, SCREEN_WIDTH-40, 40);
    [reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
    reloadButton.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    [reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(reloadApply) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.layer.cornerRadius = 3;
    reloadButton.clipsToBounds = YES;
    _reloadButton = reloadButton;
    [self.view addSubview:reloadButton];
}

#pragma mark -- 刷新

-(void)reloadApply
{
    // 设备验证是否通过(是否授权)
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //NSString *url = [NSString stringWithFormat:@"%@%@",@"http://61.153.29.234:8888/mobileService/",@"service/Device.ashx"];
    NSString *url = DeviceVerify_Url;
    NSDictionary *paremeters = @{@"deviceNumber":_deviceUUID,@"action":@"validate"};

    [MBProgressHUD showMessage:@"正在刷新" toView:self.view];
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@ ,%@",[JsonDic objectForKey:@"result"],[JsonDic objectForKey:@"state"]);
        if ([[JsonDic objectForKey:@"result"] isEqualToString:@"1"])
        {
            [defaults setObject:_deviceUUID forKey:@"deviceUUID"];
            [defaults synchronize];
            // 通过验证
            [defaults setBool:YES forKey:@"isPassApplyDevice"];
            [defaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
           // [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSLog(@"%@",error);
        
    }];
}


#pragma mark -- textField代理

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

//导航栏标题
-(void)initNavigationBarTitle:(NSString *)title
{
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    naviView.backgroundColor = [UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000];
    _naviView = naviView;
    [self.view addSubview:naviView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 40)];
    lab.textColor     = [UIColor whiteColor];
    lab.font          = [UIFont boldSystemFontOfSize:17.0];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text          = title;
    _naviTitle = lab;
    [naviView addSubview:lab];
}

@end