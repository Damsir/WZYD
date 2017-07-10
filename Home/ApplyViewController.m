//
//  ApplyViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ApplyViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "DeviceInfo.h"

@interface ApplyViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UILabel *warnLabel;
@property(nonatomic,strong) UIButton *reloadButton;
@property(nonatomic,strong) UITextField *nameText;
@property(nonatomic,strong) UITextField *companyText;
@property(nonatomic,strong) UITextField *addressText;
@property(nonatomic,strong) UITextField *systemText;
@property(nonatomic,strong) UIButton *searchBtn;

@property(nonatomic,strong) UIView *naviView;
@property(nonatomic,strong) UILabel *naviTitle;

@property(nonatomic,strong) NSString *deviceUUID;
@property(nonatomic,strong) NSString *deviceName;
@property(nonatomic,strong) NSString *system;
@property(nonatomic,strong) NSString *hardware;


@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    [self initNavigationBarTitle:@"设备申请"];
    
    _deviceUUID = [DeviceInfo deviceUUID];
    
    [self createUI];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _warnLabel.frame = CGRectMake(20, 64+HeaderHeight, SCREEN_WIDTH-40, 300);
    [_warnLabel sizeToFit];
    _reloadButton.frame = CGRectMake(20, CGRectGetMaxY(_warnLabel.frame) + HeaderHeight, SCREEN_WIDTH-40, 40);


    _naviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    _naviTitle.frame = CGRectMake(0, 24, SCREEN_WIDTH, 40);
    
    _nameText.frame = CGRectMake(20, CGRectGetMaxY(_naviView.frame)+20, MainR.size.width-40, 40);
    _companyText.frame = CGRectMake(20, CGRectGetMaxY(_nameText.frame)+20, MainR.size.width-40, 40);
    _addressText.frame = CGRectMake(20, CGRectGetMaxY(_companyText.frame)+20, MainR.size.width-40, 40);
    _systemText.frame = CGRectMake(20, CGRectGetMaxY(_addressText.frame)+20, MainR.size.width-40, 40);
    
    _searchBtn.frame = CGRectMake(20, CGRectGetMaxY(_systemText.frame) + 50, SCREEN_WIDTH-40, 40);
    
}

-(void)createUI
{
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _backView = backView;
    [self.view addSubview:backView];
    
    UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_naviView.frame)+20, MainR.size.width-40, 40)];
    nameText.delegate = self;
    if (SCREEN_WIDTH == 320)
    {
        nameText.font = [UIFont systemFontOfSize:9.5];
    }
    else if (SCREEN_WIDTH >= 768)
    {
    }
    else
    {
        nameText.font = [UIFont systemFontOfSize:11.5];
    }
    nameText.text = [NSString stringWithFormat:@"设备编码: %@",_deviceUUID];
    nameText.enabled = NO;
    nameText.borderStyle = UITextBorderStyleRoundedRect;
    nameText.returnKeyType = UIReturnKeyDone;
    _nameText = nameText;
    [backView addSubview:nameText];
    
    UITextField *companyText = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(nameText.frame)+20, MainR.size.width-40, 40)];
    companyText.delegate = self;
    companyText.placeholder = @"请输入设备名称";
    companyText.clearButtonMode = UITextFieldViewModeAlways;
    companyText.borderStyle = UITextBorderStyleRoundedRect;
    companyText.returnKeyType = UIReturnKeyDone;
    _companyText = companyText;
    [backView addSubview:companyText];
    
    UITextField *addressText = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(companyText.frame)+20, MainR.size.width-40, 40)];
    addressText.delegate = self;
    if (SCREEN_WIDTH > 736)
    {
        addressText.text = @"设备类型: iPad";
        _hardware = @"Pad";
    }
    else
    {
        addressText.text = @"设备类型: iPhone";
        _hardware = @"Phone";
    }
    addressText.enabled = NO;
    addressText.borderStyle = UITextBorderStyleRoundedRect;
    addressText.returnKeyType = UIReturnKeyDone;
    _addressText = addressText;
    [backView addSubview:addressText];
    
    
    UITextField *systemText = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(addressText.frame)+20, MainR.size.width-40, 40)];
    systemText.delegate = self;
    systemText.text = @"操作系统: IOS";
    systemText.enabled = NO;
    _system = @"IOS";
    systemText.borderStyle = UITextBorderStyleRoundedRect;
    systemText.returnKeyType = UIReturnKeyDone;
    _systemText = systemText;
    [backView addSubview:systemText];
    
    //
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(20, CGRectGetMaxY(_systemText.frame) + 50, SCREEN_WIDTH-40, 40);
    searchBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    searchBtn.layer.borderWidth = 1;
    searchBtn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0].CGColor;
    [searchBtn setTitle:@"提交" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(ApplyInfo) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.cornerRadius = 3;
    searchBtn.clipsToBounds = YES;
    _searchBtn = searchBtn;
    [backView addSubview:searchBtn];
}

#pragma mark -- 申请
-(void)ApplyInfo
{
    [self.view endEditing:YES];
    
    if ([_companyText.text isEqualToString:@""]||[_companyText.text isEqualToString:@"请输入设备名称"])
    {
        [MBProgressHUD showError:@"设备名称未填写!"];
    }
    else
    {
        _deviceName = _companyText.text;
       // _deviceName = [_deviceName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //加载提示框
        [MBProgressHUD showMessage:@"正在提交" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //NSString *url = [NSString stringWithFormat:@"%@%@",@"http://61.153.29.234:8888/mobileService/",@"service/Device.ashx"];
        NSString *url = DeviceVerify_Url;
        
        NSDictionary *paremeters = @{@"name":_deviceName,@"remark":@"备注",@"system":_system,@"hardware":_hardware,@"deviceNumber":_deviceUUID,@"action":@"regist"};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

            
            [MBProgressHUD hideHUDForView:self.view animated:NO];

            
            if ([[JsonDic objectForKey:@"result"] isEqualToString:@"0"])
            {
                // 记住设备UUID
                [defaults setObject:_deviceUUID forKey:@"deviceUUID"];
                [defaults synchronize];
                
                // 设备已经提交申请
                [defaults setBool:YES forKey:@"isSubmitApplyDevice"];
                [defaults synchronize];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备申请提交成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alert show];
                
            }
            else
            {
                [MBProgressHUD showError:@"设备申请提交失败!"];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:NO];

            [MBProgressHUD showError:@"设备申请提交失败!"];
            
        }];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 设备验证是否通过(是否授权)
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    //NSString *url = [NSString stringWithFormat:@"%@%@",@"http://61.153.29.234:8888/mobileService/",@"service/Device.ashx"];
    NSString *url = DeviceVerify_Url;
    NSDictionary *paremeters = @{@"deviceNumber":_deviceUUID,@"action":@"validate"};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        
        if ([[JsonDic objectForKey:@"result"] isEqualToString:@"1"])
        {
//            AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//            [UIView animateWithDuration:1.5 animations:^{
//                
//                self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
//                self.view.alpha = 0.0;
//                [delegate changeRootView];
//                
//            } completion:^(BOOL finished) {
//                
//                [self.view removeFromSuperview];
//                
//            }];
            
            // 通过验证
            [defaults setBool:YES forKey:@"isPassApplyDevice"];
            [defaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
           // [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            _backView.hidden = YES;
            [self initNavigationBarTitle:@"设备未授权"];
            // 刷新
            [self createReloadButton];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"网络请求失败!"];
        
    }];
    
    
}

#pragma mark -- 刷新按钮

-(void)createReloadButton
{
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.frame = CGRectMake(20, 64+HeaderHeight, SCREEN_WIDTH-40, 300);
    warnLabel.text = [NSString stringWithFormat:@"您的硬件码是: %@ ,目前尚未获取授权，请记录硬件码并反馈给管理员!",_deviceUUID];
    warnLabel.font = [UIFont systemFontOfSize:15.0];
    _warnLabel = warnLabel;
    warnLabel.numberOfLines = 0;
    [warnLabel sizeToFit];
    
    [self.view addSubview:warnLabel];
    
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

        
        if ([[JsonDic objectForKey:@"result"] isEqualToString:@"1"])
        {
            // 通过验证
            [defaults setBool:YES forKey:@"isPassApplyDevice"];
            [defaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
           // [self dismissViewControllerAnimated:YES completion:nil];
           // [self.navigationController popViewControllerAnimated:YES];
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
